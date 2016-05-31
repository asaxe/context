%function run_ctxt_sparse(theta,particle_id,expt_num)
clear 
tic 
theta = [2000 1.5 .01 10 .5 2];
N=theta(1);
alpha=theta(2);
P=round(N*alpha);
f=theta(3);
N_token=theta(4);
fn=theta(5);
alg = theta(6);

n_trials = 1;
overlaps = zeros(n_trials,1);
overlap_ef = zeros(n_trials,1);
dist_overlaps = zeros(n_trials,1);

for nn=1:n_trials
    
Pat=[zeros((1-f)*N,P); ones(f*N,P)];
for l=1:P
    Pat(:,l)=Pat(randperm(N),l);
end


    J=(Pat-f)*(Pat-f)'/(N*f*(1-f));
    % J=Pat*pinv(Pat'*Pat)*Pat';
    J=J-diag(diag(J));
    

    S1(:,1:N_token)=Pat(:,1:N_token);
    
    if alg == 1
    
         % Find max-margin gain + summed additive field solution
        cvx_clear
        cvx_begin
            variable w(N)
            variable h
            variable b
            minimize( norm(J*diag(w),'fro') )
            subject to
                (2*S1-1).*( 2*( J*diag(w)*S1 + h*sum(S1,2)*ones(1,N_token) - b)) > 1
        cvx_end
        k_margin = 1/cvx_optval;
        hext = h*sum(S1,2);
    
    elseif alg == 2
        % Find max-margin gain + additive solution
        cvx_clear
        cvx_begin
            variable w(N)
            variable h(N)
            minimize( norm(J*diag(w),'fro') )
            subject to
                (2*S1-1).*( 2*( J*diag(w)*S1 + h*ones(1,N_token) )) > 1
        cvx_end
        k_margin = 1/cvx_optval;
        hext = h;
        h_to_save = h;
        gain = w;
        clear h
    end
    
%     plot(1:N,w,1:N,h,1:N,sum(S1,2))
%     legend('w','h','s')
%     
    S=S1(:,1); S0=S; 
    ipos=randsample(find(S0==1),round(fn*length(find(S0==1))));
    S(ipos)=~S0(ipos);
    ineg=randsample(find(S0==0),round(fn*length(find(S0==1))));
    S(ineg)=~S0(ineg);
    %mean(S.*S0)

    normP=sum(Pat.*(Pat-f));
    T=50;
    T_ext_field_off = 30;
    M=zeros(T+1,1);
    MM=zeros(T+1,1);
    M(1)=S'*(Pat(:,1)-f)/normP(1);
    MM(1)=S'*(Pat(:,2)-f)/normP(2);
    
    for tt=1:T
        h=J*diag(gain)*S+hext;
        h_sort=sort(h);
        Thresh = h_sort(round((1-f)*length(h_sort)));
        S=(h>Thresh);
        M(tt+1,1:N_token)=S'*(Pat(:,1:N_token)-f)/normP(1);
        if tt>T_ext_field_off
            hext=zeros(N,1);
            gain=ones(N,1);
        end
    end
    
    overlaps(nn) = M(end,1);
    overlap_ef(nn) = M(T_ext_field_off,1);
    dist_overlaps(nn) = mean(M(end,2:end));
    
%     plot(1:T+1,M(:,1),'b-o'); hold on; 
%     for j=2:N_token
%         plot(1:T+1,M(:,j)); hold on; 
%     end
% 
%     axis([0 inf -0.1 1.1])
% 
% 
%     pause
%     clf
end

mean_overlap = mean(overlaps);
num_mach = sum(overlaps == 1);

simtime=toc



%%
%figure

dir_prefix = '/n/home13/asaxe/context/results';
save(sprintf('%s/expt%d/res_%d.mat',dir_prefix,expt_num,particle_id),'theta','overlaps','overlap_ef','dist_overlaps','mean_overlap','num_mach','w','h_to_save','k_margin')

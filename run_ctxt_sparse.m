function run_ctxt_sparse(theta,particle_id,expt_num)

tic 

N=theta(1);
alpha=theta(2);
P=round(N*alpha);
f=theta(3);
N_token=theta(4);
h0=theta(5)/f;
fn=theta(6);

n_trials = 100;
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
    S=S1(:,1); S0=S; 
    ipos=randsample(find(S0==1),round(fn*length(find(S0==1))));
    S(ipos)=~S0(ipos);
    ineg=randsample(find(S0==0),round(fn*length(find(S0==1))));
    S(ineg)=~S0(ineg);
    %mean(S.*S0)

    normP=sum(Pat.*(Pat-f));
    hext=h0*sum(S1,2);
    T=50;
    T_ext_field_off = 30;
    M=zeros(T+1,1);
    MM=zeros(T+1,1);
    M(1)=S'*(Pat(:,1)-f)/normP(1);
    MM(1)=S'*(Pat(:,2)-f)/normP(2);
    h=J*S+hext;
    for tt=1:T
        for l=1:N
            h(l)=J(l,:)*S+hext(l);
            h_sort=sort(h);
            Thresh = h_sort(round((1-f)*length(h_sort)));
            S=(h>Thresh);
        end
        M(tt+1,1:N_token)=S'*(Pat(:,1:N_token)-f)/normP(1);
        if tt>T_ext_field_off
            hext=zeros(N,1);
        end
    end
    
    overlaps(nn) = M(end,1);
    overlap_ef(nn) = M(T_ext_field_off,1);
    dist_overlaps(nn) = mean(M(end,2:end));
end

mean_overlap = mean(overlaps);
num_mach = sum(overlaps == 1);

simtime=toc

%figure
% plot(1:T+1,M(:,1),'b-o'); hold on; 
% for j=2:N_token
%     plot(1:T+1,M(:,j)); hold on; 
% end
% 
% axis([0 inf -0.1 1.1])
% 

dir_prefix = '/n/home13/asaxe/context/results';
save(sprintf('%s/expt%d/res_%d.mat',dir_prefix,expt_num,particle_id),'theta','overlaps','overlap_ef','dist_overlaps','mean_overlap','num_mach')

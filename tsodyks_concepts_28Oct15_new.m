clear all;
clf
%rng(10);
tic

N=2000;
% alpha=2;
% P=ceil(N*alpha);
P=3000;
f=0.01;
n_trials = 1;
overlaps = zeros(n_trials,1);

for nn=1:n_trials
    
Pat=[zeros((1-f)*N,P); ones(f*N,P)];
for l=1:P
    Pat(:,l)=Pat(randperm(N),l);
end
h0=.2/f;
fn=0.5;

    J=(Pat-f)*(Pat-f)'/(N*f*(1-f));
    % J=Pat*pinv(Pat'*Pat)*Pat';
    J=J-diag(diag(J));
    N_token=10;

    S1(:,1:N_token)=Pat(:,1:N_token);
    S=S1(:,1); S0=S; 
    ipos=randsample(find(S0==1),fn*length(find(S0==1)));
    S(ipos)=~S0(ipos);
    ineg=randsample(find(S0==0),fn*length(find(S0==1)));
    S(ineg)=~S0(ineg);
    %mean(S.*S0)

    normP=sum(Pat.*(Pat-f));
    hext=h0*sum(S1,2);
    T=50;
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
        if tt>30
            hext=zeros(N,1);
        end
    end
    
    overlaps(nn) = M(end,1);
end

mean_overlap = mean(overlaps);
num_mach = sum(overlaps == 1);

simtime=toc

%figure
plot(1:T+1,M(:,1),'b-o'); hold on; 
for j=2:N_token
    plot(1:T+1,M(:,j)); hold on; 
end

axis([0 inf -0.1 1.1])


% mean_overlap = 0.8778
% num_mach = 62
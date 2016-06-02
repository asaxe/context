function run_ctxt_combined(param_id,expt_num)
% theta = [N alpha f Nt fn]
addpath('~/cvx')
cvx_setup

%dir_prefix = '/Users/asaxe/Documents/postdoctoralwork/context/results';
dir_prefix = '/n/home13/asaxe/context/results';

% theta=[N    alpha f  Nt fn   alg]
%theta = [2000 1.5  .01 10  .77  1];
%param_id = 10;
%expt_num = 7;

% Load theta (array job mode)
load(sprintf('%s/expt%d/params.mat',dir_prefix,expt_num))
theta = theta(param_id,:);


% Unpack theta
N=theta(1);
alpha=theta(2);
P=round(N*alpha);
f=theta(3);
N_token=theta(4);
fn=theta(5);
alg = theta(6); % Alg for obtaining J

h0s = [0 logspace(-4,1,29)];

n_Js = 20;
n_token_sets_per_J = 50;

for j = 1:n_Js

    % Generate full pattern set
    Pat=[zeros((1-f)*N,P); ones(f*N,P)];
    for l=1:P
        Pat(:,l)=Pat(randperm(N),l);
    end
    
    % Compute J
    if alg == 1 % Tsodyks sparse Hebbian
        [J,b] = tsodyks_sparse_hebbian(Pat,f);
    elseif alg == 2 % SVM
        [J,b] = svm_J(Pat,false);
    end
    
    % Test performance on different sets of token inputs
    for ts = 1:n_token_sets_per_J
        
        tic
        % Draw random token set
        S1 = Pat(:,randsample(1:N,N_token));
        
        % Draw noise-corrupted input
        S=S1(:,1); S0=S; 
        ipos=randsample(find(S0==1),round(fn*length(find(S0==1))));
        S(ipos)=~S0(ipos);
        ineg=randsample(find(S0==0),round(fn*length(find(S0==1))));
        S(ineg)=~S0(ineg);
        
        % Test each algorithm variant on this token set
        
        % Additive variants
        ind = 1;
        for h0 = h0s
            [overlap(ind), overlap_i(ind), overlap_s(ind), overlap_is(ind)] = overlap_additive(J,b,S1,S,f,h0);
            ind = ind + 1;
        end
        a.o{j,ts} = overlap;
        a.oi{j,ts} = overlap_i;
        a.os{j,ts} = overlap_s;
        a.ois{j,ts} = overlap_is;
        
        % Gain variants
        [overlap, overlap_i, overlap_s, overlap_is, gain, hext, k_margin] = overlap_gain(J,b,S1,S,f);
        g.o(j,ts) = overlap;
        g.oi(j,ts) = overlap_i;
        g.os(j,ts) = overlap_s;
        g.ois(j,ts) = overlap_is;
        g.gain{j,ts} = double(gain);
        g.hext{j,ts} = double(hext);
        g.k_margin(j,ts) = k_margin;
        
        toc
        
    end
    % Save after each J just in case...

    save(sprintf('%s/expt%d/res_%d.mat',dir_prefix,expt_num,param_id),'theta','h0s','a','g')

end




%%
%figure
% 
% 
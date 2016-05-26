clear
tic
% Parameters
N = 500;
alpha = 1.5;
alg = 3;

P = round(alpha*N);
should_plot = false;


% Create patterns
xi = 2*(rand(N,P)>.5)-1;

% Create Hebbian associations
if alg == 1 % Create Hebbian associations
    J = 1/N*(xi*xi');
    for i = 1:length(J)
        J(i,i)=0; 
    end
elseif alg == 2 % Create pseudoinverse associations
    J = zeros(N,N);
    for i = 1:N
        inds = setdiff(1:N,i);
        J(i,inds) = xi(i,:)*pinv(xi(inds,:));
    end
elseif alg == 3 % Create SVM associations
    J = zeros(N,N);
    for i = 1:N
        inds = setdiff(1:N,i);

        cvx_clear
        cvx_begin
            variable w(N-1)

            minimize( norm(w) )
            subject to
                xi(i,:).*(w'*xi(inds,:)) > 1
        cvx_end
        if isinf(cvx_optval)
           error('not linearly separable') 
        end
        J(i,inds) = w';
    end
end


% Select context subset
Nv = P;
Nvs = round(linspace(2,10,9));
for nv = 1:length(Nvs)

    v = 1:Nvs(nv);
    xi_v = xi(:,v);

    % Find max-margin additive solution
    cvx_clear
    cvx_begin
        variable k
        variable h(N)
        maximize( k )
        subject to
            xi_v.*(J*xi_v) + xi_v.*(h*ones(1,Nvs(nv))) > k
    cvx_end
    ka(nv) = k/norm(J,'fro');

  
    % Find max-margin gain solution
%     cvx_clear
%     cvx_begin
%         variable w(N)
%         minimize( norm(J*diag(w),'fro') )
%         subject to
%             xi_v.*(J*diag(w)*xi_v) > 1
%     cvx_end
%     kg(nv) = 1/cvx_optval;
   
    % Find max-margin gain + summed additive field solution
%     cvx_clear
%     cvx_begin
%         variable w(N)
%         variable h
%         minimize( norm(J*diag(w),'fro') )
%         subject to
%             xi_v.*(J*diag(w)*xi_v) + xi_v.*(h*mean(xi_v,2)*ones(1,Nvs(nv))) > 1
%     cvx_end
%     ksg(nv) = 1/cvx_optval;
    
    % Find max-margin gain + additive solution
    cvx_clear
    cvx_begin
        variable w(N)
        variable h(N)
        minimize( norm(J*diag(w),'fro') )
        subject to
            xi_v.*(J*diag(w)*xi_v) + xi_v.*(h*ones(1,Nvs(nv))) > 1
    cvx_end
    kag(nv) = 1/cvx_optval;

end
toc
%%
n = xi.*(J*xi);
k_no_ctxt = min(n(:))/norm(J,'fro');
subplot(121)
plot(Nvs,ones(length(Nvs),1)*k_no_ctxt,Nvs,ka,Nvs,kag,'.-','linewidth',2)
legend('No context','Additive','Add. & Gain')

ylabel('Margin \kappa')
xlabel('Size of context set N_v')
title(sprintf('N=%d, alpha=%g',N,alpha))

subplot(122)
plot(Nvs,kag/k_no_ctxt,'linewidth',2)
xlabel('Size of context set N_v')
ylabel('(Margin with context) / (Margin without context)')

%%
n = xi.*(J*xi);
k_no_ctxt = min(n(:))/norm(J,'fro');
plot(Nvs,ones(length(Nvs),1)*k_no_ctxt,Nvs,ka,Nvs,kg,Nvs,ksg,Nvs,kag,'.-','linewidth',2)
legend('No context','Additive','Gain','Fixed add. & Gain','Add. & Gain')

ylabel('Margin \kappa')
xlabel('Size of context set N_v')
title(sprintf('N=%d, alpha=%g',N,alpha))



%%
addpath('~/Documents/MATLAB/cvx')
cvx_setup

%% Try simple-minded idea... want Jv = J*diag(w)


cvx_clear
cvx_begin
    variable w(N)
    minimize( norm(Jv-J*diag(w),'fro') )
cvx_end



%%

imagesc([J Jv J*diag(w)])

%%
imagesc([h mean(xi_v,2)])

%%
imagesc([w 1-mean(xi_v,2)])

%%
w = ones(N,1)+.1*rand(N,1);
n = zeros(N,Nv);
for mu = 1:Nv
    for i = 1:N
        for j = 1:N
            n(i,mu) = n(i,mu) + J(i,j)*w(j)*xi_v(i,mu)*xi_v(j,mu);
        end
    end
end

n2 = xi_v.*(J*diag(w)*xi_v);

norm(n-n2,'fro')

%%


    %%
imagesc([Jv J J*diag(w)])


function run_linear_ineq_grid(theta,particle_id,expt_num)

% Theta = [N alpha alg]
%%
addpath('~/cvx')
cvx_setup


% Parameters
N = theta(1);
alpha = theta(2);
alg = theta(3);
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
Nvs = 2:20;
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


dir_prefix = '/n/home13/asaxe/context/results';
%dir_prefix = '.';
save(sprintf('%s/expt%d/res_alpha_%g_Nv_%d_alg_%d.mat',dir_prefix,expt_num,theta(1),theta(2),theta(3)),'theta','Nvs','k_no_ctxt','ka','kag')

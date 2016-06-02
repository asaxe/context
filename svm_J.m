function [J,b] = svm_J(Pat, self_connections)
% Must have already added CVX to path and run setup
% Patters assumed to be [0,1] coded

if nargin < 2
   self_connections = false; 
end


[N P] = size(Pat);

J = zeros(N,N);
b = zeros(N,1);
for i = 1:N
    inds = setdiff(1:N,i);

    if ~self_connections
        cvx_clear
        cvx_begin
            variable w(N-1)
            variable th

            minimize( norm(w) )
            subject to
                (2*Pat(i,:)-1).*(w'*Pat(inds,:) - th) > 1
        cvx_end
        if isinf(cvx_optval)
           warning('not linearly separable') 
        end
        J(i,inds) = w';
        b(i) = th;
    else
        cvx_clear
        cvx_begin
            variable w(N,N)
            variable th(N)

            minimize( norm(w) )
            subject to
                (2*Pat-1).*(w*Pat - repmat(th,1,P)) > 1
        cvx_end
        if isinf(cvx_optval)
           warning('not linearly separable') 
        end
        J = w';
        b = th;
    end
end
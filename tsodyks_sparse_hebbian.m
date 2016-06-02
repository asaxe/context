function [J,b] = tsodyks_sparse_hebbian(Pat,f)

N = size(Pat,1);
J=(Pat-f)*(Pat-f)'/(N*f*(1-f));
J=J-diag(diag(J));

b = 1/2;
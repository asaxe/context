N = 500;
alpha = 1.5;
f = .1;
Nv = 10;
alg = 3;


P = round(alpha*N);
should_plot = false;


% Create patterns
xi = 2*(rand(N,P)>1-f)-1;


v = 1:Nv;

xi_v = xi(:,v);

% Overlap histograpm
s = mean(xi_v,2);
hist(s,100);
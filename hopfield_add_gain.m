function m = hopfield_add_gain( ha, hg, hgm, J, xi, s0, v, Nitr )
N = size(xi,1);

c = mean(xi(:,v),2);
g = hgm*(1-hg*abs(c));

m = zeros(size(xi,2),Nitr);
s = s0;
for itr = 1:Nitr
    s = sign(J*(g.*s)+ha*c);
    m(:,itr) = 1/N*s'*xi;
end

m;

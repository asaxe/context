function [overlap, overlap_i, overlap_s, overlap_is] = overlap_additive(J,b,S1,S,f,hf)

[N Nt] = size(S1);
normP =  N*f*(1-f);

h0=hf/f;
hext=h0*sum(S1,2);

T=50;
T_ext_field_off = 30;
M = zeros(T,Nt);
M_s = zeros(T,Nt);
S_s = S;
for t=1:T
    % Non-sparse dynamics
    h = J*S - b + hext;
    S = double(h>0);
    M(t,:)=S'*(S1-f)/normP;
    
    % Sparse dynamics
    hs=J*S_s - b + hext;
    h_sort=sort(hs);
    Thresh = h_sort(round((1-f)*length(h_sort)));
    S_s=double((hs>Thresh));
    M_s(t,:)=S_s'*(S1-f)/normP;
    
    if t>T_ext_field_off
        hext=zeros(N,1);
    end
end

overlap = M(T,1);
overlap_i = M(T_ext_field_off,1);
overlap_s = M_s(T,1);
overlap_is = M_s(T_ext_field_off,1);
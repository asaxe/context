function [overlap, overlap_i, overlap_s, overlap_is, gain, h_to_save, k_margin] = overlap_gain(J,b,S1,S,f)

[N Nt] = size(S1);
normP =  N*f*(1-f);

%% Compute optimal gain + additive input solution
cvx_clear
cvx_begin
    variable w(N)
    variable h(N)
    minimize( norm(J*diag(w),'fro') )
    subject to
        (2*S1-1).*( 2*( J*diag(w)*S1 + h*ones(1,Nt) )) > 1
cvx_end
k_margin = 1/cvx_optval;
hext = h;
h_to_save = h;
gain = w;

%% Run dynamics
T=50;
T_ext_field_off = 30;
M = zeros(T,Nt);
M_s = zeros(T,Nt);

S0 = S;
S_s = S;

Jg = J*diag(gain);
for t=1:T
    % Non-sparse dynamics
    h = Jg*S + hext;
    S = double(h>0);
    M(t,:)=S'*(S1-f)/normP;
    
    % Sparse dynamics
    hs=Jg*S_s + hext;
    h_sort=sort(hs);
    Thresh = h_sort(round((1-f)*length(h_sort)));
    S_s=double((hs>Thresh));
    M_s(t,:)=S_s'*(S1-f)/normP;
    
    if t>T_ext_field_off
        hext=zeros(N,1);
        Jg = J;
    end
end

overlap = M(T,1);
overlap_i = M(T_ext_field_off,1);
overlap_s = M_s(T,1);
overlap_is = M_s(T_ext_field_off,1);
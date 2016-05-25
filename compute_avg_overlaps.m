function mout = compute_avg_overlaps(m_mat,v,corr_thresh)

for j = 1:size(m_mat,1)
    for k = 1:size(m_mat,2)    
        
        m = m_mat{j,k};
        
        P = size(m,1);
        Nv = length(v);

        tmp=mean(m,2);
        mout(j,k,1) = tmp(v(1)); % Target
        mout(j,k,2) = mean(tmp(v(2:Nv))); % Context
        mout(j,k,3) = mean(tmp(setdiff(1:P,v))); % Nonrel
        mout(j,k,4) = mean(m(1,:) >= corr_thresh,2); % Pct correct

    end
end
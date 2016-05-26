function [mb, ib, jb] = compute_optimal_err(m)

tmp = m(:,:,4);
[mval,m_ind] = max(tmp(:));

[ib,jb] = ind2sub(size(m(:,:,4)),m_ind);
mb = squeeze(m(ib,jb,:))';


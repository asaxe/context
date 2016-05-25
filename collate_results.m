function res = collate_results(expt_nm)


corr_thresh = 1;

fs = dir(sprintf('./results/expt%d/*.mat',expt_nm));

for i = 1:length(fs)
    i
    if strcmp(fs(i).name,'params.mat')
        continue;
    end
    load(sprintf('./results/expt%d/%s',expt_nm,fs(i).name))
    
    v = 1:theta(2);
    
    params(i,:) = theta;
    mvout{i} = compute_avg_overlaps(mv,v,corr_thresh);
    maout{i} = compute_avg_overlaps(ma,v,corr_thresh);
    mgout{i} = compute_avg_overlaps(mg,v,corr_thresh);
    magout{i} = compute_avg_overlaps(mag,v,corr_thresh);

end

mv = mvout;
ma = maout;
mg = mgout;
mag = magout;

save(sprintf('expt%d_results.mat',expt_nm),'mv','ma','mg','mag','params','has','hgs','hgms')
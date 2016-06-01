function res = collate_results(expt_nm)


corr_thresh = 1;

fs = dir(sprintf('./results/expt%d/*.mat',expt_nm));

ind = 1;
for i = 1:length(fs)
    
    if strcmp(fs(i).name,'params.mat')
        continue;
    end
    load(sprintf('./results/expt%d/%s',expt_nm,fs(i).name))
    
    
    params(ind,:) = theta;
    mdist_overlaps{ind} = dist_overlaps;
    mmean_overlap{ind} = mean_overlap;
    mnum_mach{ind} = num_mach;
    moverlap_ef{ind} = overlap_ef;
    moverlaps{ind} = overlaps;
 
    ind = ind + 1;
end

dist_overlaps = mdist_overlaps;
mean_overlap = mmean_overlap;
num_mach = mnum_mach;
overlap_ef = moverlap_ef;
overlaps = moverlaps;



save(sprintf('expt%d_results.mat',expt_nm),'params','dist_overlaps','mean_overlap','num_mach','overlap_ef','overlaps')
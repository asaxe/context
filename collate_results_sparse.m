function res = collate_results(expt_nm)


corr_thresh = 1;

fs = dir(sprintf('./results/expt%d/*.mat',expt_nm));

for i = 1:length(fs)
    i
    if strcmp(fs(i).name,'params.mat')
        continue;
    end
    load(sprintf('./results/expt%d/%s',expt_nm,fs(i).name))
    
    
    params(i,:) = theta;
    mdist_overlaps{i} = dist_overlaps;
    mmean_overlap{i} = mean_overlap;
    mnum_mach{i} = num_mach;
    moverlap_ef{i} = overlap_ef;
    moverlaps{i} = overlaps;
 
end

dist_overlaps = mdist_overlaps;
mean_overlap = mmean_overlap;
num_mach = mnum_mach;
overlap_ef = moverlap_ef;
overlaps = moverlaps;



save(sprintf('expt%d_results.mat',expt_nm),'params','dist_overlaps','mean_overlap','num_mach','overlap_ef','overlaps')
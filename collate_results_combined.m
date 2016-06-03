function [params, res] = collate_results_combined(expt_nm)


corr_thresh = 1;

fs = dir(sprintf('./results/expt%d/*.mat',expt_nm));

ind = 1;
for i = 1:length(fs)
    
    if strcmp(fs(i).name,'params.mat')
        continue;
    end
    load(sprintf('./results/expt%d/%s',expt_nm,fs(i).name))
    
    params(ind,:) = theta;
    res{ind}.a = a;
    res{ind}.h0s = h0s;
    res{ind}.g = g;
    
 
    ind = ind + 1;
end

% dist_overlaps = mdist_overlaps;
% mean_overlap = mmean_overlap;
% num_mach = mnum_mach;
% overlap_ef = moverlap_ef;
% overlaps = moverlaps;


%save(sprintf('expt%d_results.mat',expt_nm),'params','dist_overlaps','mean_overlap','num_mach','overlap_ef','overlaps')
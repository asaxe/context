clear
load expt4_results.mat

%% Optimize over h0

Nts = unique(params(2:end,4));
h0s = unique(params(2:end,5));
fns = unique(params(2:end,6));

for nt = 1:length(Nts)
    for fn = 1:length(fns)
        inds = find(abs(params(:,4)-Nts(nt))<.00001 & abs(params(:,6)-fns(fn))<.00001);
        [m,mi] = max(cell2mat(mean_overlap(inds)));
        ov(nt,fn) = m;
        oh(nt,fn) = params(inds(mi),5);
    end
end


clear
load expt5_results.mat

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
        
        tmp = cell2mat(overlap_ef(inds));
        m2 = max(mean(tmp));
        of(nt,fn)=m2;
        
        tmp = cell2mat(overlaps(inds));
        m3 = max(mean(tmp));
        o(nt,fn)=m3;
        
        [~,mi2] = min(params(inds,5));
        ov0(nt,fn) = mean_overlap{inds(mi2)};
        mi == mi2
        
    end
end

%%

i = 2;
plot(fns,ov(i,:),fns,ov0(i,:),fns,of(i,:),fns,o(i,:),'linewidth',2)
legend('Sparse + additive context','No context','Location','SouthWest')
xlabel('Noise level fn')
ylabel('Mean target overlap m')
title(sprintf('N = %d, alpha = %g, f = %g, Nt = %d',params(1,1),params(1,2),params(1,3),Nts(i)))
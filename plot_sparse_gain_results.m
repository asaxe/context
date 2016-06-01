clear
load expt6_results.mat

%% Optimize over h0

Nts = unique(params(:,4));
fns = unique(params(:,5));

for nt = 1:length(Nts)
    for fn = 1:length(fns)
        inds = find(abs(params(:,4)-Nts(nt))<.00001 & abs(params(:,5)-fns(fn))<.00001);
        [m,mi] = max(cell2mat(mean_overlap(inds)));
        if isempty(m)
           m = nan; 
        end
        ov(nt,fn) = m;
        
        tmp = cell2mat(overlap_ef(inds));
        m2 = max(mean(tmp));
        of(nt,fn)=m2;
        
        tmp = cell2mat(overlaps(inds));
        m3 = max(mean(tmp));
        o(nt,fn)=m3;
        
        
    end
end

%%

i = 2;
plot(fns,ov(i,:),fns,of(i,:),fns,o(i,:),'linewidth',2)
legend('Sparse + additive context','No context','Location','SouthWest')
xlabel('Noise level fn')
ylabel('Mean target overlap m')
title(sprintf('N = %d, alpha = %g, f = %g, Nt = %d',params(1,1),params(1,2),params(1,3),Nts(i)))
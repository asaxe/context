clear
%% Load and collate sparse results

load expt7_results.mat


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
        
        
    end
end
Nt_s = Nts;
fn_s = fns;
o_s = o;
of_s = of;
h_s = oh;
o0_s = ov0;


%% Load and collate gain results

load expt6_results.mat

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

Nt_g = Nts;
fn_g = fns;
o_g = o;

%% Plot


for nt = 1:max([Nt_g' Nt_s'])
    ig = find(Nt_g==nt);
    is = find(Nt_s==nt);
    if isempty(ig) || isempty(is)
       continue 
    end
    plot(fn_g,o_g(ig,:),fn_s,o_s(is,:),fn_s,o0_s(is,:),'linewidth',2)
    legend('Sparse + add + gain','Sparse + add','No Context','Location','SouthWest')
    xlabel('Noise level fn')
    ylabel('Mean target overlap m')
    title(sprintf('N = %d, alpha = %g, f = %g, Nt = %d',params(1,1),params(1,2),params(1,3),nt))
    xlim([.5 1])
    pause
end

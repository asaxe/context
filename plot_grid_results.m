clear
%%
load expt1_results
% Fix mistake
params(1,:)=[];
mv(1)=[];
ma(1)=[];
mg(1)=[];
mag(1)=[];
%%
clear mvb mab mgb magb opinfo_v opinfo_a opinfo_g opinfo_ag
Nex = size(params,1);
for e = 1:Nex 
e
    [mvb(e,:), ib, jb] = compute_optimal_err(mv{e});
    opinfo_v(e,:) = [has(ib) hgs(jb) ib jb];

    [mab(e,:), ib, jb] = compute_optimal_err(ma{e});
    opinfo_a(e,:) = [has(ib) hgs(jb) ib jb];

    [mgb(e,:), ib, jb] = compute_optimal_err(mg{e});
    opinfo_g(e,:) = [has(ib) hgs(jb) ib jb];

    [magb(e,:), ib, jb] = compute_optimal_err(mag{e});
    opinfo_ag(e,:) = [has(ib) hgs(jb) ib jb];
    
end

%% For fixed dS, plot acc as fun of alpha, Nv

alphas = unique(params(:,1));
Nvs = unique(params(:,2));
dSs = unique(params(:,3));

stat_ind = 4;

ds = 3;

for a = 1:length(alphas)
   for nv = 1:length(Nvs)
      resv(a,nv) = mvb(params(:,1)==alphas(a) & params(:,2)==Nvs(nv) & params(:,3)==dSs(ds),stat_ind);
   end
end
for a = 1:length(alphas)
   for nv = 1:length(Nvs)
      resa(a,nv) = mab(params(:,1)==alphas(a) & params(:,2)==Nvs(nv) & params(:,3)==dSs(ds),stat_ind);
   end
end
for a = 1:length(alphas)
   for nv = 1:length(Nvs)
      resg(a,nv) = mgb(params(:,1)==alphas(a) & params(:,2)==Nvs(nv) & params(:,3)==dSs(ds),stat_ind);
   end
end
for a = 1:length(alphas)
   for nv = 1:length(Nvs)
      resag(a,nv) = magb(params(:,1)==alphas(a) & params(:,2)==Nvs(nv) & params(:,3)==dSs(ds),stat_ind);
   end
end

imagesc([resv resa resg resag])
% Plot recall % as function of alpha
for n = 1:length(Nvs)
    nv = Nvs(n);
   plot(alphas,[resv(:,n) resa(:,n) resg(:,n) resag(:,n)],'.-','linewidth',2);
   legend('No Context','Additive','Gain','Add. & Gain','Location','East')
   title(sprintf('Nv=%d,dS=%g',nv,dSs(ds)))
   xlabel('Load \alpha')
   ylabel('% recalled perfectly')
   ylim([0 1])
   xlim([.08 .17])
   pause
end

%% Plot empirical alpha_c

criterion = .9;
for n = 1:length(Nvs)
   ind = find(resv(:,n)<criterion,1,'first');
   if isempty(ind)
      acv_ind(n) = length(alphas);
   else
      acv_ind(n) = ind; 
   end
   
   ind = find(resa(:,n)<criterion,1,'first');
   if isempty(ind)
      aca_ind(n) = length(alphas);
   else
      aca_ind(n) = ind; 
   end
   
      ind = find(resg(:,n)<criterion,1,'first');
   if isempty(ind)
      acg_ind(n) = length(alphas);
   else
      acg_ind(n) = ind; 
   end
   
      ind = find(resag(:,n)<criterion,1,'first');
   if isempty(ind)
      acag_ind(n) = length(alphas);
   else
      acag_ind(n) = ind; 
   end
   
   
end

plot([alphas(acv_ind) alphas(aca_ind) alphas(acg_ind) alphas(acag_ind)])
legend('No context','Additive','Gain','Add. & Gain')
xlabel('Nv')
ylabel('\alpha_c')

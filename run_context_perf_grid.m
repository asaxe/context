function run_context_perf_grid(theta,particle_id,expt_num)

has = .1:.1:1;
hgs = .1:.1:1;
hgms = 1;
for i = 1:length(has)
    for j = 1:length(hgs)
        [mv{i,j},ma{i,j},mg{i,j},mag{i,j}] = compute_context_perf(theta,has(i),hgs(i),hgms);
    end
end

dir_prefix = '/n/home13/asaxe/context/results';
%dir_prefix = '.';
save(sprintf('%s/expt%d/res_alpha_%g_Nv_%d_dS_%g.mat',dir_prefix,expt_num,theta(1),theta(2),theta(3)),'has','hgs','hgms','theta','mv','ma','mg','mag')
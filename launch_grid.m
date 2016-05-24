function launch_grid

expt_nm = 1;
mkdir(sprintf('~/context/results/expt%d',expt_nm))

alphas = linspace(.08, .17, 10); % Load (num patterns P/num dimensions N)
Nvs = 2:10;
dSs = .1:.1:.9; % How far from pattern to start (2*prob flipping each bit)

memorybudget = 1500;
ncores = 1;
fn_str = 'run_context_perf_grid';

i = 1;
for alpha = alphas
    for Nv = Nvs
        for dS = dSs
            theta(i,:) = [alpha Nv dS];
            i = i + 1;
        end
    end
end

save(sprintf('~/context/results/expt%d/params.mat',expt_nm),'theta','memory','ncores','expt_nm')
length(theta)

launch_fn = @run_odyssey;

launch_fn(theta, fn_str, memorybudget, ncores, expt_nm)
	 

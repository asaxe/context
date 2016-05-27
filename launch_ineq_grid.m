function launch_ineq_grid

expt_nm = 3;
mkdir(sprintf('~/context/results/expt%d',expt_nm))

Ns = [250 500 1000];
alphas = linspace(1,1.9,9); % Load (num patterns P/num dimensions N)
algs = 3; % How far from pattern to start (2*prob flipping each bit)

memorybudget = 10000;
ncores = 1;
fn_str = 'run_linear_ineq_grid';

i = 1;
for N = Ns
    for alpha = alphas
        for alg = algs
            theta(i,:) = [N alpha alg];
            i = i + 1;
        end
    end
end

save(sprintf('~/context/results/expt%d/params.mat',expt_nm),'theta','memorybudget','ncores','expt_nm')
length(theta)

launch_fn = @run_odyssey;

launch_fn(theta, fn_str, memorybudget, ncores, expt_nm)
	 

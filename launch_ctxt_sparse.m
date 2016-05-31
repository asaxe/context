function launch_ctxt_sparse

expt_nm = 4;
mkdir(sprintf('~/context/results/expt%d',expt_nm))

Ns = [2000];
alphas = [1.5]; % Load (num patterns P/num dimensions N)
fs = [.01]; % Sparsity
N_tokens = round(linspace(2,100,10));
h0s = logspace(0,2,10);
fns = linspace(0,1,10);


memorybudget = 2500;
ncores = 1;
fn_str = 'run_ctxt_sparse';

i = 1;
for N = Ns
    for alpha = alphas
        for f = fs
            for N_t = N_tokens
                for h0 = h0s
                    for fn = fns
                        theta(i,:) = [N alpha f N_t h0 fn];
                        i = i + 1;
                    end
                end
            end
        end
    end
end

save(sprintf('~/context/results/expt%d/params.mat',expt_nm),'theta','memorybudget','ncores','expt_nm')
length(theta)

launch_fn = @run_odyssey;

launch_fn(theta, fn_str, memorybudget, ncores, expt_nm)
	 

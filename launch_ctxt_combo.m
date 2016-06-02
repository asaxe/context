function launch_ctxt_combo

expt_nm = 8;
mkdir(sprintf('~/context/results/expt%d',expt_nm))

Ns = [2000];
alphas = [1.5]; % Load (num patterns P/num dimensions N)
fs = [.01]; % Sparsity
N_tokens = [round(linspace(2,20,10)) round(linspace(40,100,5))];
fns = linspace(.5,1,10);
algs = [2];

ndays = 3;
nhours = 0;
memorybudget = 6000;
ncores = 1;
fn_str = 'run_ctxt_combined';

i = 1;
for N = Ns
    for alpha = alphas
        for f = fs
            for N_t = N_tokens
                for fn = fns
                    for alg = algs
                        theta(i,:) = [N alpha f N_t fn alg];
                        i = i + 1;
                    end
                end
         
            end
        end
    end
end

save(sprintf('~/context/results/expt%d/params.mat',expt_nm),'theta','memorybudget','ncores','expt_nm')
length(theta)

launch_fn = @run_odyssey_array;

launch_fn(theta, fn_str, memorybudget, ndays, nhours, ncores, expt_nm)
	 

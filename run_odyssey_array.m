function run_odyssey_array(thetas, fn_str, membudget, ndays, nhours, ncores, expt_nm)

% make param file

wd = pwd;

N = size(thetas,1);


pf = 'job.sbatch';
fid = fopen(pf,'w');
jobarrayname = sprintf('d%d_%d',expt_nm,N);
jobname = sprintf('d%d_%%a_%d',expt_nm,N);
fprintf(fid,'#!/bin/bash\n');
fprintf(fid,'#SBATCH --job-name=%s\n',jobarrayname);
fprintf(fid,'#SBATCH --output=/n/home13/asaxe/context/results/expt%d/%s.out\n',expt_nm,jobname);
fprintf(fid,'#SBATCH --error=/n/home13/asaxe/context/results/expt%d/%s.err\n',expt_nm,jobname);
fprintf(fid,'#SBATCH -t %d-%d:00\n',ndays,nhours);
fprintf(fid,'#SBATCH -p general\n');
fprintf(fid,'#SBATCH -n %d\n',ncores);
fprintf(fid,'#SBATCH -N 1\n');
fprintf(fid,'#SBATCH --mail-type=FAIL\n');
fprintf(fid,'#SBATCH --mail-user=asaxe@fas.harvard.edu\n');
fprintf(fid,'#SBATCH --mem=%d\n\n',round(membudget));
fprintf(fid,'cd %s\n',wd);
fprintf(fid,'module load matlab/R2015a-fasrc01\n');
fprintf(fid,'cd %s; matlab-default -nodisplay -nojvm -nodesktop -nosplash -r "addpath(''~/context/''),startup,%s("${SLURM_ARRAY_TASK_ID}",%d),exit"\n',wd,fn_str,expt_nm);
% confusing string escaping note: to get one single quote, put in two

fclose(fid);

% Submit job

system(sprintf('sbatch --array=1-%d %s',N,pf));






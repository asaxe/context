function run_odyssey(thetas, membudget, ncores, expt_nm)

% make param file

wd = pwd;

N = size(thetas,1);

for i = 1:N
[i N]
	  pf = 'job.sbatch';
fid = fopen(pf,'w');
jobname = sprintf('d%d_%d_%d',expt_nm,i,N);
fprintf(fid,'#!/bin/bash\n');
fprintf(fid,'#SBATCH --job-name=%s\n',jobname);
fprintf(fid,'#SBATCH --output=/n/home13/asaxe/deepmaxpool/results/expt%d/%s.out\n',expt_nm,jobname);
fprintf(fid,'#SBATCH --error=/n/home13/asaxe/deepmaxpool/results/expt%d/%s.err\n',expt_nm,jobname);
fprintf(fid,'#SBATCH -t 6-00:00\n');
fprintf(fid,'#SBATCH -p general\n');
fprintf(fid,'#SBATCH -n %d\n',ncores);
fprintf(fid,'#SBATCH -N 1\n');
fprintf(fid,'#SBATCH --mail-type=FAIL\n');
fprintf(fid,'#SBATCH --mail-user=asaxe@fas.harvard.edu\n');
fprintf(fid,'#SBATCH --mem=%d\n\n',round(membudget*1.1));
fprintf(fid,'cd %s\n',wd);
fprintf(fid,'module load Anaconda/2.1.0-fasrc01\n');
fprintf(fid,'source activate anamkl2\n');
fprintf(fid,'export OMP_NUM_THREADS=%d\n',ncores);
fprintf(fid,'python run.py -network p:3,3,3,3 c:1,1,%d,%d:0:%d,%d m:%d,%d:%d,%d -mem %d',thetas(i,1),thetas(i,2),thetas(i,3),thetas(i,4),thetas(i,5),thetas(i,6),thetas(i,7),thetas(i,8),membudget);

    fclose(fid);
    
    % Submit job
    
    system(['sbatch ' pf]);
pause(.1);
end





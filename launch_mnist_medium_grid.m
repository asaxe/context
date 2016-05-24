function launch_mnist_medium_grid

expt_nm = 2;
mkdir(sprintf('~/deepmaxpool/results/expt%d',expt_nm))

wNs = 5:10; % filter dimension
mNs = 5:10; % maxpool dimension

sW = 1; % Filter stride
sM = 1; % maxpool stride

membudget = 190000; % in MB
ncores = 32;

i = 1;
for wN = wNs
    for mN = mNs
  for sW = 1:4:wN
	     for sM = mN:-4:1

                theta(i,:) = [wN wN sW sW mN mN sM sM ];
                i = i + 1;
end
end

    end
end

save(sprintf('~/deepmaxpool/results/expt%d/params.mat',expt_nm),'theta','membudget','ncores','expt_nm')
length(theta)

 launch_fn = @run_odyssey;

launch_fn(theta, membudget, ncores, expt_nm)
	 

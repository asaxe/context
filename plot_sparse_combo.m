clear
expt_num = 8;
%% Load and collate sparse results

[param,r] = collate_results_combined(expt_num);

%% 

for i = 1:length(param)

    Ns = length(r{i}.a.o);
    Nh = length(r{i}.h0s);
    om = mean(reshape(cell2mat(r{i}.a.o),Nh,Ns),2);
    oim = mean(reshape(cell2mat(r{i}.a.oi),Nh,Ns),2);
    osm = mean(reshape(cell2mat(r{i}.a.os),Nh,Ns),2);
    oism = mean(reshape(cell2mat(r{i}.a.ois),Nh,Ns),2);

    semilogx(r{i}.h0s,om,r{i}.h0s,oim,r{i}.h0s,osm,r{i}.h0s,oism,'linewidth',2)
    legend('Trans Add','Add','Sparse trans add','Sparse add')
    param(i,[4 5])
    pause
end

function res = collate_results(expt_nm)


corr_thresh = 1;

fs = dir(sprintf('./results/expt%d/*.mat',expt_nm));

for i = 1:length(fs)
    i
    if strcmp(fs(i).name,'params.mat')
        continue;
    end
    load(sprintf('./results/expt%d/%s',expt_nm,fs(i).name))
    
    
    params(i,:) = theta;
    mknctxt{i} = k_no_ctxt;
    mka{i} = ka;
    mkag{i} = kag;
    mNvs{i} = Nvs;
    
    plot(Nvs,ka,Nvs,kag)
    hline(k_no_ctxt)
pause
end




%save(sprintf('expt%d_results.mat',expt_nm),'mv','ma','mg','mag','params','has','hgs','hgms')
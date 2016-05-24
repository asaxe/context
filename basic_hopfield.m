clear

% Parameters
N = 500;
alpha = .09;
P = round(alpha*N);
should_plot = false;

% Create patterns
xi = 2*(rand(N,P)>.5)-1;

% Create Hebbian associations
J = 1/N*(xi*xi');
for i = 1:length(J)
   J(i,i)=0; 
end

%%

Nreps = 100;

m_n = zeros(P,Nreps);
m_a = zeros(P,Nreps);
m_g = zeros(P,Nreps);
m_ag = zeros(P,Nreps);

Nitr = 100;
m = zeros(P,Nitr);
for r = 1:Nreps
    r

    % Context patterns
    v = [1:5]; % Pattern #1 is to be recalled
    Nv = length(v);

    % Generate perturbation of memory location
    dS = .8; % Flip bits wp
    s0 = xi(:,v(1)).*(2*(rand(N,1)>dS/2)-1);

    % Simulate standard dynamics

    s = s0;
    for itr = 1:Nitr
        s = sign(J*s);
        m(:,itr) = 1/N*s'*xi;
    end
    m_n(:,r) = m(:,end);
    %
    if should_plot
        plot(m(v(1),:),'linewidth',2)
        hold on
        for i = 2:Nv
           plot(m(v(i),:),'c','linewidth',2)
        end
        plot(m(setdiff(1:P,v),:)','r')
        xlabel('Iteration')
        ylabel('Overlap m')
    end

    % Add summative context input from set of three patterns
    h = .2;

    c = sum(xi(:,v),2);

  
    s = s0;
    for itr = 1:Nitr
        s = sign(J*s+h*c);
        m(:,itr) = 1/N*s'*xi;
    end
    
    m_a(:,r) = m(:,end);
    %
  if should_plot
        plot(m(v(1),:),'linewidth',2)
        hold on
        for i = 2:Nv
           plot(m(v(i),:),'c','linewidth',2)
        end
        plot(m(setdiff(1:P,v),:)','r')
        xlabel('Iteration')
        ylabel('Overlap m')
    end


    % Add gain context modulation 
    h = 1;

    cp = mean(xi(:,v),2);
    %cm = mean(xi(:,setdiff(1:P,v)),2);
    c = 1-h*abs(cp);


    s = s0;
    for itr = 1:Nitr
        s = sign(J*(c.*s));
        m(:,itr) = 1/N*s'*xi;
    end

    %
    if should_plot
        plot(m(v(1),:),'linewidth',2)
        hold on
        for i = 2:Nv
           plot(m(v(i),:),'c','linewidth',2)
        end
        plot(m(setdiff(1:P,v),:)','r')
        xlabel('Iteration')
        ylabel('Overlap m')
    end
    m_g(:,r) = m(:,end);
    
    % Both add & gain
    ha = .3;
    hg = 1.2;

    ca = mean(xi(:,v),2);
    %cm = mean(xi(:,setdiff(1:P,v)),2);
    c = 1-hg*abs(ca);

    Nitr = 100;
    s = s0;
    for itr = 1:Nitr
        s = sign(J*(c.*s)+ha*ca);
        m(:,itr) = 1/N*s'*xi;
    end
    m_ag(:,r) = m(:,end);
    %
    if should_plot
        plot(m(v(1),:),'linewidth',2)
        hold on
        for i = 2:Nv
           plot(m(v(i),:),'c','linewidth',2)
        end
        plot(m(setdiff(1:P,v),:)','r')
        xlabel('Iteration')
        ylabel('Overlap m')
    end

end
%%
plot(1:P,mean(m_n,2),1:P,mean(m_a,2),1:P,mean(m_g,2),1:P,mean(m_ag,2),'linewidth',2)
legend('No Context','Additive field','Gain field','Add. & Gain')

%%
corr_thresh = 1;
pct_correct = false;
if pct_correct
    tmp=mean(m_n>=corr_thresh,2);
else
     tmp=mean(m_n,2);
end
m_n_targ = tmp(v(1));
m_n_ctxt = mean(tmp(v(2:Nv)));
m_n_unrl = mean(tmp(setdiff(1:P,v)));

if pct_correct
    tmp=mean(m_a>=corr_thresh,2);
else
    tmp=mean(m_a,2);
end
m_a_targ = tmp(v(1));
m_a_ctxt = mean(tmp(v(2:Nv)));
m_a_unrl = mean(tmp(setdiff(1:P,v)));

if pct_correct
    tmp=mean(m_g>=corr_thresh,2);
else
    tmp=mean(m_g,2);
end
m_g_targ = tmp(v(1));
m_g_ctxt = mean(tmp(v(2:Nv)));
m_g_unrl = mean(tmp(setdiff(1:P,v)));

if pct_correct
    tmp=mean(m_ag>=corr_thresh,2);
else
    tmp=mean(m_ag,2);
end
m_ag_targ = tmp(v(1));
m_ag_ctxt = mean(tmp(v(2:Nv)));
m_ag_unrl = mean(tmp(setdiff(1:P,v)));

bar([m_n_targ m_n_ctxt m_n_unrl;
     m_a_targ m_a_ctxt m_a_unrl;
     m_g_targ m_g_ctxt m_g_unrl;
     m_ag_targ m_ag_ctxt m_ag_unrl])
ylabel('Mean overlap')
set(gca,'XTickLabel',{'None','Additive','Gain','Add. & Gain'})
xlabel('Context manipulation')
legend('Overlap with target','Overlap with context','Overlap with unrelated','Location','NorthWest')

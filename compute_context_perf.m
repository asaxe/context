function [m_n, m_a, m_g, m_ag] = compute_context_perf(theta,ha,hg,hgm)

tic
% Parameters
N = 500;
alpha = theta(1);
P = round(alpha*N);
Nv = theta(2);
dS = theta(3); % Flip bits wp dS/2

% Context patterns
v = [1:Nv]; % Pattern #1 is to be recalled
 

should_plot = false;


%


Nreps = 100;

m_n = zeros(P,Nreps);
m_a = zeros(P,Nreps);
m_g = zeros(P,Nreps);
m_ag = zeros(P,Nreps);

Nitr = 100;
m = zeros(P,Nitr);
for r = 1:Nreps
    r
    % Create patterns
    xi = 2*(rand(N,P)>.5)-1;

    % Create Hebbian associations
    J = 1/N*(xi*xi');
    for i = 1:length(J)
       J(i,i)=0; 
    end

    % Generate perturbation of memory location
    s0 = xi(:,v(1)).*(2*(rand(N,1)>dS/2)-1);

    % Simulate standard dynamics
    m = hopfield_add_gain(0, 0, 1, J, xi, s0, v, Nitr);
    m_n(:,r) = m(:,end);
    
    if should_plot
        clf
        plot(m(v(1),:),'linewidth',2)
        hold on
        for i = 2:Nv
           plot(m(v(i),:),'c','linewidth',2)
        end
        plot(m(setdiff(1:P,v),:)','r')
        xlabel('Iteration')
        ylabel('Overlap m')
    end

    % Simulate additive dynamics
    m = hopfield_add_gain(ha, 0, 1, J, xi, s0, v, Nitr);
    m_a(:,r) = m(:,end);
    
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
    
    % Simulate gain dynamics
    m = hopfield_add_gain(0, hg, hgm, J, xi, s0, v, Nitr);
    m_g(:,r) = m(:,end);
    
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
  
    % Simulate additive & gain dynamics
    m = hopfield_add_gain(ha, hg, hgm, J, xi, s0, v, Nitr);
    m_ag(:,r) = m(:,end);
    
    if should_plot
        plot(m(v(1),:),'linewidth',2)
        hold on
        for i = 2:Nv
           plot(m(v(i),:),'c','linewidth',2)
        end
        plot(m(setdiff(1:P,v),:)','r')
        xlabel('Iteration')
        ylabel('Overlap m')
        pause
    end

end

%%
% plot(1:P,mean(m_n,2),1:P,mean(m_a,2),1:P,mean(m_g,2),1:P,mean(m_ag,2),'linewidth',2)
% legend('No Context','Additive field','Gain field','Add. & Gain')
% 
% %%
% corr_thresh = 1;
% pct_correct = false;
% if pct_correct
%     tmp=mean(m_n>=corr_thresh,2);
% else
%      tmp=mean(m_n,2);
% end
% m_n_targ = tmp(v(1));
% m_n_ctxt = mean(tmp(v(2:Nv)));
% m_n_unrl = mean(tmp(setdiff(1:P,v)));
% 
% if pct_correct
%     tmp=mean(m_a>=corr_thresh,2);
% else
%     tmp=mean(m_a,2);
% end
% m_a_targ = tmp(v(1));
% m_a_ctxt = mean(tmp(v(2:Nv)));
% m_a_unrl = mean(tmp(setdiff(1:P,v)));
% 
% if pct_correct
%     tmp=mean(m_g>=corr_thresh,2);
% else
%     tmp=mean(m_g,2);
% end
% m_g_targ = tmp(v(1));
% m_g_ctxt = mean(tmp(v(2:Nv)));
% m_g_unrl = mean(tmp(setdiff(1:P,v)));
% 
% if pct_correct
%     tmp=mean(m_ag>=corr_thresh,2);
% else
%     tmp=mean(m_ag,2);
% end
% m_ag_targ = tmp(v(1));
% m_ag_ctxt = mean(tmp(v(2:Nv)));
% m_ag_unrl = mean(tmp(setdiff(1:P,v)));
% 
% if should_plot
%     bar([m_n_targ m_n_ctxt m_n_unrl;
%          m_a_targ m_a_ctxt m_a_unrl;
%          m_g_targ m_g_ctxt m_g_unrl;
%          m_ag_targ m_ag_ctxt m_ag_unrl])
%     ylabel('Mean overlap')
%     set(gca,'XTickLabel',{'None','Additive','Gain','Add. & Gain'})
%     xlabel('Context manipulation')
%     legend('Overlap with target','Overlap with context','Overlap with unrelated','Location','NorthWest')
% end
toc



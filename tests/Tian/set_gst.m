function [S,T]=set_gst(t,stepamp,steptime,L,debug)
% [S,T]=SET_GST(TIME,STEPAMP,STEPTIME,L,DEBUG) initializes general step function
% for paleoclimate with amplitude stepamp at time steptime, g
% iven an input vector of temporal nodes at times t. L is the 
% length of a smoothing operator applied to the temperature time series.
% if debug > 0, a control plot is produced.
%
% V. R., July 20, 2005
if nargin < 5, debug=0; end
if nargin <4, L=0; end

ns=length(steptime);
nt=length(t);
maske=find(t<steptime(1));
T(maske)=stepamp(1);
for i=2:ns
    maske=find(t<steptime(i) & t>=steptime(i-1));
    T(maske)=stepamp(i);
end
maske=find(t>steptime(ns));
T(maske)=stepamp(ns);
S=T';

if L ~= 0,
    T=T';
    nT=length(T);
    % triangular window
    w = tri(2*L+1); w = w/sum(w);

    for k = L+1:nT-L
        aux = T(k-L:k+L);
        S(k-L) = sum(w.*aux);
    end;
end

if debug >0,
    figure;
    year2sec= 31557600;
    plot(-t/year2sec',S, 'LineWidth',2,'Color','r');hold on;
    if L ~= 0, plot(-t/year2sec',T, 'LineWidth',2,'Color','b','LineStyle','--');end
    set(gca,'XScale','log','XDir','reverse')
    grid on;
    xlabel('time b. p.(a)','FontSize',14);ylabel('\Delta T','FontSize',14);
    if L ~= 0, grid on;legend('smoothed','original','Location','NorthWest');end
    title(['test: set_paleo_boxcar'],'FontSize',14)
    if debug >=1,
        filename='GST.ps';
        saveas(gcf,filename,'psc2')
    end
end







clear all
close all
clc
%GRAPHICS
plotfmt='epsc2';
outsteps=false;
graph=false;
fontwg='normal';
fontsz=16;

Tfit=[0:1:120];

k0 = 2.91;
kfit=kmT(k0,Tfit);

% disp([' ']);
% disp(['Thermal conductivity (Clauser & Huenges, 1995): ']);
% disp(['Original coeffcient values = ',num2str(K   ,' %7.3g  %7.3g')]);
% disp(['Fitted coeffcient values   = ',num2str(Kfit,' %7.3g  %7.3g')]);


figure
plot(Tfit,kfit,'-r','LineWidth',2); hold on
set(gca,'FontSize',fontsz,'FontWeight',fontwg);
grid on
ylabel('\lambda (W m^{-1}K^{-1})','FontSize',fontsz,'FontWeight',fontwg)
xlabel('T (C)','FontSize',fontsz,'FontWeight',fontwg);
filename=strcat(['Olkiluoto_funTC']);
saveas(gcf,filename,plotfmt)

% HEAT CAPACITY
cp0=712;
cfit=cpmT(cp0,Tfit);

% disp([' ']);
% disp(['Heat capacity (Mottaghgy et al. 2005): ']);
% disp(['Original coeffcient values = ',num2str(C   ,' %7.3g  %7.3g')]);
% disp(['Fitted coeffcient values   = ',num2str(Cfit,' %7.3g  %7.3g')]);


figure
plot(Tfit,cfit,'-r','LineWidth',2); hold on
grid on;
set(gca,'FontSize',fontsz,'FontWeight',fontwg);
ylabel('c_p (J kg^{-1} K^{-1})','FontSize',fontsz,'FontWeight',fontwg)
xlabel('T (C)','FontSize',fontsz,'FontWeight',fontwg);
filename=strcat(['Olkiluoto_funCP']);
saveas(gcf,filename,plotfmt)




clear all
close all 
clc

% SET PATHS
pltpath='./';
datpath='./';
srcpath='../';
utlpath='../';

save('common','srcpath','utlpath','datpath','pltpath')

addpath(['local']);
addpath([srcpath,'/src']);
addpath([srcpath,'/src/mcmc']);
addpath([srcpath,'/tools'])

dfmt=1;ffmt='.zip';
archive(mfilename,strcat([mfilename '_' datestr(now,dfmt)]),ffmt);
yeartosec=31557600;sectoyear=1/yeartosec;

Tlimits=[0 30];
zlimits=[0 1600];

set_graphpars

U2012=load('Ullrigg_March2012.dat');
z2012=U2012(:,1);
T2012=U2012(:,2);

U2013=load('Ullrigg_March2013.dat');
z2013=abs(U2013(:,2));
T2013=U2013(:,1);

index=z2013>60 & z2013<1550;
Tinv=T2013(index);
zinv=z2013(index);

whos
figure
plot(T2012(:),z2012(:),'--b','LineWidth',1); hold on
plot(T2013(:),z2013(:),'--r','LineWidth',1);
plot(Tinv(:),zinv(:),'-r','LineWidth',2);

plot(T2013(:),z2013(:),'--r','LineWidth',1);
grid on
set(gca,'ydir','rev','FontSize',fontsz,'FontWeight',fontwg);
xlabel('T ($^\circ$C)','FontSize',fontsz);
ylabel('z (m)','FontSize',fontsz);
xlim(Tlimits)   
filename=strcat('Ullrigg ');
saveas(gcf,filename,plotfmt)
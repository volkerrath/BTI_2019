function [ierr]=SITE_Init(name)
% Site OTUKUMPU
% Prepare paeloclimate initial

ierr = 0;

load('common.mat')

y2s=3600*24*365.25;s2y=1./y2s;

out= 1;
debug=0;%


plotit              = 1;
plotmod             = 0;
zlimits             =[0 5000];

% CONSTANTS

site                = 'SYNB';
props               = 'syn';
init_type           = 'p';
init_form           = 'steps';
method              = 'linear';
GSTH_file           = 'GSTHBallingB.csv';
L                   = 0;
initial_iter        = 30;
GST0                = 7.;
Qb                  = -0.038;
POM                 = 0.;

% NUMERICAL PARAMETERS
% >>>>>>>>>>>>>>>>>>>> FIX POINT ITERATION
maxitnl= 4;
tolnl= 1.e-5;
relaxnl= 1.;

% >>>>>>>>>>>>>>>>>>>> FREEZE-THAW SWITCH
freeze= 1;
out            = 1;


%prepstr= ['_' init_type];
prepstr= [''];



% SET PATHS

addpath([srcpath,filesep,'src']);
addpath([srcpath,filesep,strcat(['src/props/',props])]);
addpath([srcpath,filesep,strcat(['tools'])]);

% dfmt=1;ffmt='.zip';
% archive(mfilename,strcat([mfilename '_' datestr(now,dfmt)]),ffmt);

F=strcat([name,'_FwdPar.mat']);
load(F);
mstruct(fwdpar);

% load MODEL
disp(strcat([' load model for ' name ]));
F=strcat([datpath name '_SiteMod.mat']);
load(F);
mstruct(sitemod);

Qb=qb;

F=strcat([name '_Init_in.mat']);
if exist(F)
    disp([mfilename ' defaults overwritten from ',F])
    load(F);
    mstruct(init_in);
end



if plotit
    set_graphpars
    %plotfmt='epsc2';
    close all
end

disp(['   ']);
disp(strcat([ ' ... Generating initial values for ', name]));


nt = length(t);dt=diff(t);
nz = length(z);dz=diff(z);

switch lower(init_type)
    case {'e' 'equi' 'equilibrium'}
        disp(strcat([ ' ... initial values: ', init_type]));
        Tin=GST0-POM;
        T0=heat1dns(k, kA, kB,h,r,p,Qb,Tin,dz,ip,maxitnl,tolnl,freeze,out);
        Tinit = T0;
        zinit =z;
        GSTinit=Tin;
        if plotit
            figure;
            plot(Tinit,zinit,'-r','LineWidth',3);hold on
            grid on
            ylim(zlimits);
            ylabel('z (m)','FontSize',fontsz);
            xlabel('T (C)','FontSize',fontsz);
            set(gca,'YDir','reverse');
            set(gca,'FontSize',fontsz, 'FontWeight',fontwg);
            dtext= strcat(['Initial temperatures, equi, props = ',props]);
            textloc(dtext,'northeast','FontSize',fontsz-4,'FontWeight',fontwg);
            
            file=strcat([site prepstr, '_Equi']);
            saveas(gcf,file,plotfmt);
        end
        
        
    case {'p' 'prior' 'periodic'}
        disp(strcat([ ' ... initial values: ', init_type]));
        if strcmp(init_form,'steps')
            % SETUP FORCING
            PGSTH =importdata(GSTH_file); 
%             PGSTH = flipud(PGSTH);
            tGSTH=-PGSTH(:,1)*y2s; 
            TGSTH=PGSTH(:,2);
            TGSTH=[TGSTH; TGSTH(end)];
            [Tgst] = set_stpgst(t,TGSTH,tGSTH,L,POM,0);
            
%             tGSTH/y2s
%             t/y2s
            
            Tit = [];
            for iter=1:initial_iter
                
                if iter==1
                    
                    Tin=Tgst(1)+POM;
                    T0=heat1dns(k, kA, kB,h,r,p,Qb,Tin,dz,ip,maxitnl,tolnl,freeze,out);
                    Tinit = T0;
%                     Tref=Tgst(length(Tgst));
%                     Tr=heat1dns(k, kA, kB,h,p,Qb,Tref,dz,ip,maxitnl,tolnl,freeze,out);
                end
                
                GSTinit=Tgst;
                
                [Tcalc,G,Q,K]=heat1dnt(k,kA,kB,h,r,c,rc,p,Qb,...
                    dz,ip,dt,it,GSTinit,T0,theta,maxitnl,tolnl,freeze,out);
                
                T0old=T0;T0=Tcalc(:,nt);
                Tit=[Tit T0(:)];
                disp(['iteration #',num2str(iter),': norm (T0-T0old)/T0)= ',...
                    num2str(norm((T0(:)-T0old(:))/T0(:),'inf'))]);
            end
            
             
        elseif strcmp(init_form,'points')
 
            DGSTH =load(GSTH_file);
            tx = DGSTH(:,1)*y2s; 
            Tavg =  DGSTH(:,2);

            [Tgst]=set_pntgst(t,tx,Tavg,method,debug);
            
            
%              plot(tx*s2y/1000,Tavg,'ob')
%              grid on
%              hold on
% 
%              plot(t*s2y/1000,Tgst,'-r')
            Tit = [];
            for iter=1:initial_iter
                
                if iter==1
                    Tin=Tgst(1)+POM;
                    T0=heat1dns(k, kA, kB,h,r,p,Qb,Tin,dz,ip,maxitnl,tolnl,freeze,out);
                    Tinit = T0;
%                     Tref=Tgst(length(Tgst));
%                     Tr=heat1dns(k, kA, kB,h,p,Qb,Tref,dz,ip,maxitnl,tolnl,freeze,out);
                end
                
                GSTinit=Tgst;
                
                [Tcalc,G,Q,K]=heat1dnt(k,kA,kB,h,r,c,rc,p,Qb,...
                    dz,ip,dt,it,GSTinit,T0,theta,maxitnl,tolnl,freeze,out);
                
                T0old=T0;T0=Tcalc(:,nt);
                Tit=[Tit T0(:)];
                disp(['iteration #',num2str(iter),': norm (T0-T0old)/T0)= ',...
                    num2str(norm((T0(:)-T0old(:))/T0(:),'inf'))]);
            end
  
            
        end
        
        
        if plotit
            figure
            ty= t*s2y;
            tscal = 1.;%%e-3;1
            plot(-ty(:)*tscal,[Tgst(:)] ,'-b','LineWidth',3);hold on
            grid on;
            xlim([10 120000]);
            ylim([-10 10]);
            TXT=strrep(strcat([name,'/',props,' Uniform']),'_',' ');
            textloc(TXT,'south','FontSize',0.5*fontsz,'FontWeight',fontwg);
            xlabel('Time BP/2000 (a)');ylabel('\Delta T (K)');
            
            set(gca,'xscale','lin','xdir','rev',...
                'FontSize',fontsz,'FontWeight',fontwg);
            S=strcat([name,'_GLinGSTH']);
            saveas(gcf,S,plotfmt)
            
            set(gca,'xscale','log','xdir','rev',...
                'xtick',[10 100 1000 10000 100000],...
                'FontSize',fontsz,'FontWeight',fontwg);
            S=strcat([name,'_GLogGSTH']);
            saveas(gcf,S,plotfmt);
            
            
            
            figure;
            plot(Tinit,z,':k','LineWidth',2);hold on
            %plot(Tit,z,'LineWidth',1);hold on
            plot(Tit(:,initial_iter),z,'-r','LineWidth',3);hold on
            ylim(zlimits);    grid on
            ylabel('z (m)','FontSize',fontsz);
            xlabel('T (C)','FontSize',fontsz);
            set(gca,'YDir','reverse');
            set(gca,'FontSize',fontsz, 'FontWeight',fontwg);
            dtext= strcat(['Initial temperatures, props = ',props,', iterations: ',num2str(initial_iter,'%i')]);
            textloc(dtext,'northeast','FontSize',fontsz-4,'FontWeight',fontwg);
            legend('equi',' final (it=30)')
            file=strcat([name, '_Iterations']);
            saveas(gcf,file,plotfmt);
            
            
            figure;
            plot(T0,z,'-r','LineWidth',3);hold on
            grid on
            ylim(zlimits);
            ylabel('z (m)','FontSize',fontsz);
            xlabel('T (C)','FontSize',fontsz);
            set(gca,'YDir','reverse');
            set(gca,'FontSize',fontsz, 'FontWeight',fontwg);
            dtext= strcat(['Initial temperatures, final, props = ',props]);
            textloc(dtext,'northeast','FontSize',fontsz-4,'FontWeight',fontwg);
            
            file=strcat([name, '_Final']);
            saveas(gcf,file,plotfmt);
            
        end
    case {'r'  'read'}
        
        
    otherwise
        
        error([mfilename,': option <',init_type,'> not defined. EXIT']);
end


zinit=z;
Tinit=T0;

F=strcat([name,'_Init']);
disp([' ']);
disp([ 'results to ',F]);
save(F,'zinit','Tinit','GSTinit');






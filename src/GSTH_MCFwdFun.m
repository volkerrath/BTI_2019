function [d,r]=GSTH_MCFwdFun(info,m)
% model function for the boxo example


load common

addpath([srcpath,'src']);
addpath([srcpath,'src/props/full']);


par=info.par;
obs=info.obs;


% LOAD MODEL PARAMETERS
[k,kA,kB,h,p,c,r,rc,ip,z,qb,gts,site]=get_sitepar(par);

% LOAD OBSERVATIONS
[Tobs,id,zd,cov,err,site]= get_siteobs(obs);

% MODIFY MODEL
nm=length(m);
GSTH=m(1:nm-1); QB=m(nm);
% CALCULATE SOLUTION
[Tcalc]=forward_solve(GSTH,...
        k,kA,kB,h,p,c,r,rc,ip,dz,QB,gts,...
        it,dt,theta,maxitnl,tolnl,freeze,0);

% CALCULATE RESIDUAL
%nd=length(Tobs);
%Wd=spdiags(1./err,0,nd,nd);
%res=Wd*(Tobs-Tcalc(id,nt));
d=Tcalc(id,nt);
r=(Tobs-Tcalc(id,nt));
% s=sum(r.^2);

rmpath([srcpath,'src']);
rmpath([srcpath,'src/props/full']);



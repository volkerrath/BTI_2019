%
%                             DISCLAIMER
%
%
% This file was generated by:
% ADiMat version 0.5.2 (*** DEBUG ***, beta, lcse, gcse(�), fwdmd, 2fwdmd, opt_ls, constfold, narg, vararg(�), Jun 27 2008) arch: i686-pc-linux-gnu
% compiled Jun 27 2008 with gcc 4.1.2 20070925 (Red Hat 4.1.2-33).
% Copyright 2001- 2007 Andre Vehreschild, Institute for
% Scientific Computing, Aachen University, D-52056 Aachen, Germany.
% http://www.sc.rwth-aachen.de/vehreschild/adimat/
% This file was augmented on Thu Oct 23 16:15:55 2008
%
% ADiMat was prepared as part of an employment at the Institute
% for Scientific Computing, RWTH Aachen University, Germany and is
% provided AS IS. NEITHER THE AUTHOR(S), THE GOVERNMENT OF THE FEDERAL
% REPUBLIC OF GERMANY NOR ANY AGENCY THEREOF, NOR THE RWTH AACHEN UNIVERSITY,
% INCLUDING ANY OF THEIR EMPLOYEES OR OFFICERS, MAKES ANY WARRANTY,
% EXPRESS OR IMPLIED, OR ASSUMES ANY LEGAL LIABILITY OR RESPONSIBILITY
% FOR THE ACCURACY, COMPLETENESS, OR USEFULNESS OF ANY INFORMATION OR
% PROCESS DISCLOSED, OR REPRESENTS THAT ITS USE WOULD NOT INFRINGE
% PRIVATELY OWNED RIGHTS.
%
% Global flags were:
% FORWARDMODE -- Apply the forward mode to the files.
% NOOPEROPTIM -- Do not use optimized operators. I.e.:
%		 g_a*b*g_c -/-> mtimes3(g_a, b, g_c)
% NOGLOBALCSE -- Prevents the application of global common subexpression
%		 elimination after canonicalizing the code.
% NOLOOPSAVING -- Do not insert ls_* functions to encapsulate the loops over
%		 directional derivatives.
% FUNCMODE    -- Inputfile is a function (This flag can not be set explicitly).
% VISITFWDMD  -- Use the visitor to generate the differentiated code.
% GRADFUNCPREFIX='sg_'
% AD_IVARS= GST
% AD_DVARS= T

function [g_T, T, z, t]= sg_heat1dnt(kl, kAl, kBl, hl, rcml, porl, qb, dz, ip, dt, it, g_GST, GST, T0, theta, maxiter, tol, freeze, out)
   narginmapper_00000= [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0, 12, 13, 14, 15, 16, 17, 18];
   %adimat-directive consumed: %ADiMat BMFUNC $$=spdiags($1, $#) DIFFTO spdiags( $@1, $#)
   %
   % HEAT1DNTP  solves nonlinear time-dependent heat equation
   % for general 1-D grid with permafrost.
   %
   % T = heat1dnt(par,nu,ip,dz,dt,T0,GST,methods) calculates
   % numerically (FD) temperatures for a given set of timesteps,
   % given a model for thermal conductivity, heat production and rho*c.
   % transient heat conduction with time-dependent source term is assumed.
   % thermal conductivity and heat capacity are assumed as nonlinear
   % functions of temperature;
   % Input :
   % k (1:nu)              = lambda matrix
   % kA, kB(1:nu)	 	= thermal conductivity coefficient A and B
   % hl(1:nu)		= volumetric heat production matrix
   % cml (1:nu)		= heat capacity c_p matrix
   % rhoml 		= density c_p matrix
   % porl			= porosity
   % qb			= basal heat flow
   % ip (1:nc)     	= pointer to assign parameters to cells
   %                 	   	(nc gridsize in cells)
   % dz(1:nc)      	= cell size (m)
   % dt(1:nt-1)    	= time step (s)
   % T0(1:nc+1)        	= initial temperatures
   % GST(1:nt+1)        	= time-dependent boundary temperatures
   %                     		at the top (e.g., paleoclimate)
   % theta(1:nt-1)      	= methods(1:nt) is time stepping control parameter,
   %                      		.5 =Crank-Nicholson, 1=Bacward Euler
   % maxiter,tol         	= maximal number of nonlinear Picard iterations and
   %                       	tolerance (max deviation from last iteration)
   %
   % Output:
   % T(1:nc+1,1:nt )  = temperatures at given time steps
   %
   %
   % V. R., July 20, 2005
   rref= 2650; 
   mean= 'g'; relax= 1.; 
   Lh= 333600; if narginmapper_00000(nargin)< 17, freeze= 'yes'; end
   if narginmapper_00000(nargin)< 18, out= 'no'; end
   
   
   [n1, n2]= size(ip); if n1== 1, tmp_heat1dnt_00072= ip' ; % Update detected: ip= some_expression(ip,...)
      ip= tmp_heat1dnt_00072;
   end
   [n1, n2]= size(dz); if n1== 1, tmp_heat1dnt_00073= dz' ; % Update detected: dz= some_expression(dz,...)
      dz= tmp_heat1dnt_00073;
   end
   [n1, n2]= size(dt); if n1== 1, tmp_heat1dnt_00074= dt' ; % Update detected: dt= some_expression(dt,...)
      dt= tmp_heat1dnt_00074;
   end
   
   nt= length(dt)+ 1; 
   nc= length(ip); nz= nc+ 1; 
   
   k= kl(ip(1: nc)); % thermal conductivity
   [n1, n2]= size(k); if n1== 1, tmp_heat1dnt_00075= k' ; % Update detected: k= some_expression(k,...)
      k= tmp_heat1dnt_00075;
   end
   kA= kAl(ip(1: nc)); % thermal conductivity coefficient A
   [n1, n2]= size(kA); if n1== 1, tmp_heat1dnt_00076= kA' ; % Update detected: kA= some_expression(kA,...)
      kA= tmp_heat1dnt_00076;
   end
   kB= kBl(ip(1: nc)); % thermal conductivity coefficient B
   [n1, n2]= size(kB); if n1== 1, tmp_heat1dnt_00077= kB' ; % Update detected: kB= some_expression(kB,...)
      kB= tmp_heat1dnt_00077;
   end
   h= hl(ip(1: nc)); % heat production
   [n1, n2]= size(h); if n1== 1, tmp_heat1dnt_00078= h' ; % Update detected: h= some_expression(h,...)
      h= tmp_heat1dnt_00078;
   end
   rhocm= rcml(ip(1: nc)); % density
   [n1, n2]= size(rhocm); if n1== 1, tmp_heat1dnt_00079= rhocm' ; % Update detected: rhocm= some_expression(rhocm,...)
      rhocm= tmp_heat1dnt_00079;
   end
   por= porl(ip(1: nc)); % pcorosity
   [n1, n2]= size(por); if n1== 1, tmp_heat1dnt_00080= por' ; % Update detected: por= some_expression(por,...)
      por= tmp_heat1dnt_00080;
   end
   %
   one= ones(size(ip)); 
   t= [0;
      cumsum(dt)]; 
   z= [0;
      cumsum(dz)]; zc= 0.5* (z(1: nz- 1)+ z(2: nz)); Pc= (998.* 9.81)* zc; 
   
   g_Pc= zeros(size(Pc));
   Tlast= T0; g_Tlast= zeros(size(Tlast));
   Titer= T0; g_Titer= zeros(size(Titer));
   g_Tlast(1)= g_GST(1);
   Tlast(1)= GST(1); g_Titer(1)= g_GST(1);
   Titer(1)= GST(1); 
   
   dc= 0.5* (dz(2: nc)+ dz(1: nc- 1)); 
   
   I= speye(nz, nz); 
   
   % START TIME STEPPING
   tmp_heat1dnt_00015= nt- 1;
   for i= 1: tmp_heat1dnt_00015
      
      %   start NONLINEAR ITERATION
      
      for iter= 1: maxiter%        build SYSTEM MATRIX
         %        initialize diagonals
         a(1: nz)= 0.; g_a(1: nz)= zeros(size(a(1: nz)));
         b(1: nz)= 0.; g_b(1: nz)= zeros(size(b(1: nz)));
         c(1: nz)= 0.; 
         %        define  coefficienGST for interior poinGST
         
         g_c(1: nz)= zeros(size(c(1: nz)));
         if iter== 1
            [g_tmp_n2c_00000, tmp_n2c_00000]= sg_n2c(g_Tlast, Tlast, dz);
            g_Tc= g_tmp_n2c_00000;
            Tc= tmp_n2c_00000; 
            clear tmp_n2c_00000 g_tmp_n2c_00000 ;
         else 
            tmp_heat1dnt_00017= 1- relax;
            g_Titer= relax* g_Titer+ tmp_heat1dnt_00017* g_Tlast;
            Titer= relax* Titer+ tmp_heat1dnt_00017* Tlast; 
            clear tmp_heat1dnt_00017 ;
            [g_Tc, Tc]= sg_n2c(g_Titer, Titer, dz); 
            
         end
         
         [g_tmp_rhofT_00000, tmp_rhofT_00000]= sg_rhofT(g_Tc, Tc, g_Pc, Pc);
         g_Pc= 9.81* g_tmp_rhofT_00000.* zc;
         Pc= 9.81* tmp_rhofT_00000.* zc; 
         clear tmp_rhofT_00000 g_tmp_rhofT_00000 ;
         [g_tmp_rhoiT_00000, tmp_rhoiT_00000]= sg_rhoiT(g_Tc, Tc);
         [g_tmp_cpiT_00000, tmp_cpiT_00000]= sg_cpiT(g_Tc, Tc);
         rci= tmp_rhoiT_00000.* tmp_cpiT_00000; 
         [g_ki, ki]= sg_kiT(g_Tc, Tc); 
         [g_rhof, rhof]= sg_rhofT(g_Tc, Tc, g_Pc, Pc); 
         [g_tmp_cpfT_00000, tmp_cpfT_00000]= sg_cpfT(g_Tc, Tc, g_Pc, Pc);
         rcf= rhof.* tmp_cpfT_00000; 
         [g_kf, kf]= sg_kfT(g_Tc, Tc); 
         km= kmT(k, Tc, kA, kB); 
         
         %  permafrost
         if strcmpi(freeze, 'yes')== 1, 
            [g_gf, gf, g_dgf, dgf]= sg_ftheta(g_Tc, Tc, 0, 1.); 
            %            gf=gf';dgf=dgf';
         else 
            gf= one; g_gf= zeros(size(gf));
            dgf= zeros(size(ip)); 
            g_dgf= zeros(size(dgf));
         end
         
         porm= one- por; 
         g_porf= por.* g_gf;
         porf= por.* gf; 
         g_pori= -g_porf;
         pori= por- porf; 
         
         switch lower(mean)
            case {'a', 'ari', 'arithmetic'}
               g_keff= (g_porf.* kf+ porf.* g_kf)+ (g_pori.* ki+ pori.* g_ki);
               keff= porf.* kf+ pori.* ki+ porm.* km; 
            case {'g', 'geo', 'geometric'}
               tmp_log_00000= log(kf);
               tmp_log_00001= log(ki);
               tmp_heat1dnt_00027= tmp_log_00000.* porf+ tmp_log_00001.* pori+ log(km).* porm;
               g_keff= (((g_kf./ kf).* porf+ tmp_log_00000.* g_porf)+ ((g_ki./ ki).* pori+ tmp_log_00001.* g_pori)).* exp(tmp_heat1dnt_00027);
               keff= exp(tmp_heat1dnt_00027); 
               clear tmp_log_00000 tmp_heat1dnt_00027 tmp_log_00001 ;
            case {'h', 'har', 'harmonic'}
               tmp_heat1dnt_00031= porf./ kf+ pori./ ki+ porm./ km;
               g_keff= (-((g_porf.* kf- porf.* g_kf)./ kf.^ 2+ (g_pori.* ki- pori.* g_ki)./ ki.^ 2))./ tmp_heat1dnt_00031.^ 2;
               keff= 1./ tmp_heat1dnt_00031; 
               clear tmp_heat1dnt_00031 ;
            case {'s', 'sqr', 'sqrmean'}
               tmp_sqrt_00000= sqrt(kf);
               tmp_sqrt_00001= sqrt(ki);
               tmp_heat1dnt_00035= porf.* tmp_sqrt_00000+ pori.* tmp_sqrt_00001+ porm.* sqrt(km);
               g_keff= 2.* tmp_heat1dnt_00035.* ((g_porf.* tmp_sqrt_00000+ porf.* (g_kf./ (2.* tmp_sqrt_00000)))+ (g_pori.* tmp_sqrt_00001+ pori.* (g_ki./ (2.* tmp_sqrt_00001))));
               keff= tmp_heat1dnt_00035.^ 2; 
               clear tmp_sqrt_00000 tmp_heat1dnt_00035 tmp_sqrt_00001 ;
            otherwise
               disp(['WMEAN: mode set to arithmetic, >', mean, '<  not defined'])
               g_keff= (g_porf.* kf+ porf.* g_kf)+ (g_pori.* ki+ pori.* g_ki);
               keff= porf.* kf+ pori.* ki+ porm.* km; 
         end
         g_rceff= (g_pori.* rci+ pori.* (g_tmp_rhoiT_00000.* tmp_cpiT_00000+ tmp_rhoiT_00000.* g_tmp_cpiT_00000))+ (g_porf.* rcf+ porf.* (g_rhof.* tmp_cpfT_00000+ rhof.* g_tmp_cpfT_00000))+ (por.* g_rhof.* Lh.* dgf+ por.* rhof.* Lh.* g_dgf);
         rceff= porm.* cpmT(rhocm/ rref, Tc)* rref+ pori.* rci+ porf.* rcf+ por.* rhof.* Lh.* dgf; 
         
         %         if nargout > 4 , k_eff(:,i)=keff'; end
         %         if nargout > 5 , rc_eff(:,i)=rceff'; end
         %         if nargout > 6 , ipor(:,i)=(pori./por)'; end
         %         if nargout > 7 , lheat(:,i)=(por.*rhof.*Lh.*dgf)'; end
         %         if nargout > 8 , rci(:,i)=(rhoi.*cpi)'; end
         
         
         g_dl= (g_keff.* dz)./ dz.^ 2;
         dl= keff./ dz; 
         tmp_heat1dnt_00044= keff* dt(i);
         tmp_heat1dnt_00045= dz.^ 2;
         tmp_heat1dnt_00046= rceff.* tmp_heat1dnt_00045;
         g_tmp_heat1dnt_00047= ((g_keff* dt(i)).* tmp_heat1dnt_00046- tmp_heat1dnt_00044.* (g_rceff.* tmp_heat1dnt_00045))./ tmp_heat1dnt_00046.^ 2;
         N(i)= max(tmp_heat1dnt_00044./ tmp_heat1dnt_00046); 
         
         %        define matrix coefficienGST for interior poinGST
         clear tmp_heat1dnt_00044 tmp_heat1dnt_00045 tmp_heat1dnt_00046 g_tmp_heat1dnt_00047 ;
         tmp_heat1dnt_00048= 2: nc;
         g_c(3: nz)= (g_dl(tmp_heat1dnt_00048).* dc)./ dc.^ 2;
         c(3: nz)= dl(tmp_heat1dnt_00048)./ dc; % upper
         clear tmp_heat1dnt_00048 ;
         tmp_heat1dnt_00050= 1: nc- 1;
         g_a(1: nz- 2)= (g_dl(tmp_heat1dnt_00050).* dc)./ dc.^ 2;
         a(1: nz- 2)= dl(tmp_heat1dnt_00050)./ dc; % lower
         clear tmp_heat1dnt_00050 ;
         tmp_heat1dnt_00052= 1: nz- 2;
         tmp_heat1dnt_00053= 3: nz;
         g_b(2: nz- 1)= -(g_a(tmp_heat1dnt_00052)+ g_c(tmp_heat1dnt_00053));
         b(2: nz- 1)= -(a(tmp_heat1dnt_00052)+ c(tmp_heat1dnt_00053)); % center
         %       modify for dirichlet bc at top node
         clear tmp_heat1dnt_00053 tmp_heat1dnt_00052 ;
         b(1)= 1.; 
         %       modify for neumann at bottom node
         g_b(1)= zeros(size(b(1)));
         tmp_heat1dnt_00055= dz(nc)* dz(nc);
         g_acn= ((tmp_heat1dnt_00055)' \ g_keff(nc)' )' ;
         acn= keff(nc)/ tmp_heat1dnt_00055; 
         clear tmp_heat1dnt_00055 ;
         g_a(nz- 1)= 2.* g_acn;
         a(nz- 1)= 2.* acn; 
         tmp_heat1dnt_00056= nz- 1;
         g_b(nz)= -g_a(tmp_heat1dnt_00056);
         b(nz)= -a(tmp_heat1dnt_00056); 
         %       generate sparse system matrix from diagonals a,b,and c
         clear tmp_heat1dnt_00056 ;
         tmp_heat1dnt_00058= -1: 1;
         g_A= spdiags( [g_a' , g_b' , g_c' ], tmp_heat1dnt_00058, nz, nz);
         A= spdiags([a' , b' , c' ], tmp_heat1dnt_00058, nz, nz); 
         %       build RIGHT HAND SIDE
         %       nodal heat sources
         clear tmp_heat1dnt_00058 ;
         [g_qd, qd]= sg_c2n(zeros(size(h)), h, dz); 
         [g_rc, rc]= sg_c2n(g_rceff, rceff, dz); 
         g_rhs= g_qd' ;
         rhs= qd' ; 
         %       modify for neumann at bottom node
         tmp_keff_00001= keff(nc);
         tmp_heat1dnt_00060= (2* acn* dz(nc)* qb)/ tmp_keff_00001;
         g_rhs(nz)= g_rhs(nz)+ ((tmp_keff_00001' \ (2* g_acn* dz(nc)* qb' - g_keff(nc)' * (tmp_heat1dnt_00060)' ))' );
         rhs(nz)= rhs(nz)+ tmp_heat1dnt_00060; 
         
         clear tmp_heat1dnt_00060 tmp_keff_00001 ;
         F= spdiags(1./ rc' , 0, nz, nz); 
         g_tmp_heat1dnt_00081= spdiags( (-g_rc' )./ rc' .^ 2, 0, nz, nz)* A+ F* g_A;
         tmp_heat1dnt_00081= F* A; % Update detected: A= some_expression(A,...)
         g_A= g_tmp_heat1dnt_00081;
         A= tmp_heat1dnt_00081;
         g_tmp_heat1dnt_00082= (g_rhs.* rc' - rhs.* g_rc' )./ rc' .^ 2;
         tmp_heat1dnt_00082= rhs./ rc' ; 
         % Update detected: rhs= some_expression(rhs,...)
         g_rhs= g_tmp_heat1dnt_00082;
         rhs= tmp_heat1dnt_00082;
         g_L= -dt(i)* theta(i)* g_A;
         L= I- dt(i)* theta(i)* A; 
         %       right hand side
         tmp_heat1dnt_00063= 1- theta(i);
         tmp_heat1dnt_00065= I+ dt(i)* tmp_heat1dnt_00063* A;
         g_r= ((dt(i)* tmp_heat1dnt_00063* g_A)* Tlast+ tmp_heat1dnt_00065* g_Tlast)+ dt(i)* g_rhs;
         r= tmp_heat1dnt_00065* Tlast+ dt(i)* rhs; 
         %       modify for top (dirichlet) bc:
         clear tmp_heat1dnt_00063 tmp_heat1dnt_00065 ;
         tmp_heat1dnt_00068= i+ 1;
         g_r(1)= g_GST(it(tmp_heat1dnt_00068));
         r(1)= GST(it(tmp_heat1dnt_00068)); clear tmp_heat1dnt_00068 ;
         L(1, 1)= 1.; 
         %       solve by LU
         g_L(1, 1)= zeros(size(L(1, 1)));
         tmp_heat1dnt_00069= L\ r;
         g_Tnew= (L\ (g_r- g_L* tmp_heat1dnt_00069));
         Tnew= tmp_heat1dnt_00069; 
         
         
         clear tmp_heat1dnt_00069 ;
         if iter> 1; 
            %hmb            checktol=norm(abs(Tnew-Titer),inf);
            g_tmp_heat1dnt_00070= g_Tnew- g_Titer;
            checktol= norm(Tnew- Titer, inf); 
            
            clear g_tmp_heat1dnt_00070 ;
            if out> 1, disp([' maximal deviation of FPI at timestep ', num2str(i), ' is ', num2str(checktol), ' K  (', num2str(iter), ')']); end
            if checktol<= tol, break; end
            if iter>= maxiter, break; end
         end
         g_Titer= g_Tnew;
         Titer= Tnew; 
         %    end NONLINEAR ITERATION
      end
      g_Tlast= g_Tnew;
      Tlast= Tnew; 
      % end TIME STEPPING
      if out~= 0, g_T(: , i+ 1)= g_Tnew;
         T(: , i+ 1)= Tnew; end
      % end TIME STEPPING
      tmp_heat1dnt_00015= nt- 1;
   end
   
   clear tmp_heat1dnt_00015 ;
   if out== 0; 
      g_T= g_Tnew;
      T= Tnew; 
   else 
      T(: , 1)= T0; 
      g_T(: , 1)= zeros(size(T(: , 1)));
   end
   %
   % if nargout > 4 , k_eff=keff'; end
   % if nargout > 5 , rc_eff=rceff'; end
   % if nargout > 6 , ipor=(pori./por)'; end
   % if nargout > 7 , lheat=(por.*rhof.*Lh.*dgf)'; end
   % if nargout > 8 , rci=(rhoi.*cpi)'; end
   
   
   
   
   
   
   
   

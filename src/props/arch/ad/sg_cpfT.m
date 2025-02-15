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

function [g_cpf, cpf, enthalp]= sg_cpfT(g_T, T, g_P, P)
   % calculates pure water heat capacity depending on
   % pressure (P,in Pa), and temperature (T, in C). 
   % 
   % derived from the Formulation given in:
   % Zylkovskij et al: Models and Methods Summary for the FEHMN Application,
   %       ECD 22, LA-UR-94-3787, Los Alamos NL, 1994.
   % 
   % Range of validity: Pressures   0.01-110 MPa, 
   %                    Temperature 15-350�C
   %
   % VR RWTH Aachen Univerity,   April 25, 2004
   narginmapper_00002= [0, 1, 0, 2];
   [n1, n2]= size(T); if n1== 1, g_tmp_cpfT_00039= g_T' ;
      tmp_cpfT_00039= T' ; % Update detected: T= some_expression(T,...)
      g_T= g_tmp_cpfT_00039;
      T= tmp_cpfT_00039;
   end
   if narginmapper_00002(nargin)< 2, % Identifier 'size' is ignored during differentiation.
      tmp_size_00003= size(T);
      g_tmp_size_00003= zeros(size(tmp_size_00003));
      g_P= 0.1* zeros(tmp_size_00003);
      P= 0.1* ones(tmp_size_00003); clear tmp_size_00003 g_tmp_size_00003 ;
   end
   [n1, n2]= size(P); if n1== 1, g_tmp_cpfT_00040= g_P' ;
      tmp_cpfT_00040= P' ; % Update detected: P= some_expression(P,...)
      g_P= g_tmp_cpfT_00040;
      P= tmp_cpfT_00040;
   end
   
   
   % Pressure in MPa 
   g_tmp_cpfT_00041= (1.e6' \ g_P' )' ;
   tmp_cpfT_00041= P/ 1.e6; % Update detected: P= some_expression(P,...)
   g_P= g_tmp_cpfT_00041;
   P= tmp_cpfT_00041;
   g_P2= g_P.* P+ P.* g_P;
   P2= P.* P; g_P3= g_P2.* P+ P2.* g_P;
   P3= P2.* P; P4= P3.* P; 
   g_T2= g_T.* T+ T.* g_T;
   T2= T.* T; g_T3= g_T2.* T+ T2.* g_T;
   T3= T2.* T; g_TP= g_P.* T+ P.* g_T;
   TP= P.* T; g_T2P= g_T2.* P+ T2.* g_P;
   T2P= T2.* P; g_TP2= g_T.* P2+ T.* g_P2;
   TP2= T.* P2; 
   
   pmin= 0.001; pmax= 110.; tmin= 15.; tmax= 360.; 
   % enthalpy of liquid ****
   % numerator coefficients 1:10; denominator coefficients 11:20
   ac= [0.25623465e-3, 0.10184405e-2, 0.22554970e-4, 0.34836663e-7, 0.41769866e-2, -0.21244879e-4, 0.25493516e-7, 0.89557885e-4, 0.10855046e-6, -0.21720560e-6, 0.10000000e+1, 0.23513278e-1, 0.48716386e-4, -0.19935046e-8, -0.50770309e-2, 0.57780287e-5, 0.90972916e-9, -0.58981537e-4, -0.12990752e-7, 0.45872518e-8]; 
   
   a= ac(1)+ ac(2)* P+ ac(3)* P2+ ac(4)* P3+ ac(5)* T+ ac(6)* T2+ ac(7)* T3+ ac(8)* TP+ ac(10)* T2P+ ac(9)* TP2; 
   g_b= ac(12)* g_P+ ac(13)* g_P2+ ac(14)* g_P3+ ac(15)* g_T+ ac(16)* g_T2+ ac(17)* g_T3+ ac(18)* g_TP+ ac(20)* g_T2P+ ac(19)* g_TP2;
   b= ac(11)+ ac(12)* P+ ac(13)* P2+ ac(14)* P3+ ac(15)* T+ ac(16)* T2+ ac(17)* T3+ ac(18)* TP+ ac(20)* T2P+ ac(19)* TP2; 
   da= ac(5)+ 2* ac(6)* T+ 3* ac(7)* T2+ ac(8)* P+ 2* ac(10)* TP+ ac(9)* P2; 
   db= ac(15)+ 2* ac(16)* T+ 3* ac(17)* T2+ ac(18)* P+ 2* ac(20)* TP+ ac(19)* P2; 
   b2= b.* b; tmp_cpfT_00030= a.* db;
   g_cpf= ((2* ac(6)* g_T+ 3* ac(7)* g_T2+ ac(8)* g_P+ 2* ac(10)* g_TP+ ac(9)* g_P2).* b- da.* g_b)./ b.^ 2- (((ac(2)* g_P+ ac(3)* g_P2+ ac(4)* g_P3+ ac(5)* g_T+ ac(6)* g_T2+ ac(7)* g_T3+ ac(8)* g_TP+ ac(10)* g_T2P+ ac(9)* g_TP2).* db+ a.* (2* ac(16)* g_T+ 3* ac(17)* g_T2+ ac(18)* g_P+ 2* ac(20)* g_TP+ ac(19)* g_P2)).* b2- tmp_cpfT_00030.* (g_b.* b+ b.* g_b))./ b2.^ 2;
   cpf= da./ b- tmp_cpfT_00030./ b2; 
   clear tmp_cpfT_00030 ;
   g_tmp_cpfT_00042= g_cpf* 1.e6;
   tmp_cpfT_00042= cpf* 1.e6; 
   % if nargout > 1; enthalp=a./b; end
   
   % after Speedy (1987) for T < 0 to -46 C
   %      Cx    B0     B1      B2      B3        B4
   % Update detected: cpf= some_expression(cpf,...)
   g_cpf= g_tmp_cpfT_00042;
   cpf= tmp_cpfT_00042;
   bc= [14.2, 25.952, 128.281, -221.405, 196.894, -64.812]; 
   ic= T< 0.; 
   T(T< -45.)= -45; 
   g_T(T< -45.)= zeros(size(T(T< -45.)));
   g_r= (227.15' \ ((g_T(ic)))' )' ;
   r= (T(ic)+ 46)/ 227.15; 
   g_r2= g_r.* r+ r.* g_r;
   r2= r.* r; g_r3= g_r2.* r+ r2.* g_r;
   r3= r2.* r; tmp_sqrt_00003= sqrt(r);
   g_cpf(ic)= (-bc(1).* (g_r./ (2.* tmp_sqrt_00003)))./ tmp_sqrt_00003.^ 2+ bc(3)* g_r+ bc(4)* g_r2+ bc(5)* g_r3+ bc(6)* (g_r3.* r+ r3.* g_r);
   cpf(ic)= bc(1)./ tmp_sqrt_00003+ bc(2)+ bc(3)* r+ bc(4)* r2+ bc(5)* r3+ bc(6)* (r3.* r); 
   clear tmp_sqrt_00003 ;
   g_cpf(ic)= (18.' \ g_cpf(ic)* 0.99048992406520* 1000' )' ;
   cpf(ic)= (cpf(ic)* 0.99048992406520* 1000)/ 18.; 
   
   

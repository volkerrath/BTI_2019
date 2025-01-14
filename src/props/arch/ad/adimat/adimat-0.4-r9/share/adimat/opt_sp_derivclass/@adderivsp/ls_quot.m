function res= ls_quot(g_s1, s1, g_s2, s2)
%ADDERIV/LS_QUOT Execute the quotient rule elementwise for two operands.
%
% Copyright 2001-2004 Andre Vehreschild, Institute for Scientific Computing   
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!

if g_s1.dims==1 && g_s2.dims==1
    res= adderivsp(g_s1);
    denom= 1./ (s2.^ 2);
    for i= 1: res.ndd
       res.deriv{i}= (g_s1.deriv{i}.* s2- s1.* g_s2.deriv{i}).* denom;
    end
elseif g_s1.dims==2 && g_s2.dims==1
   res= adderivsp(g_s1);
   % g_s1 = h_s1, s1= g_s1, g_s2= g_s2, s2= s2
   denom= 1./ (s2.^ 2);
   for i= 1: g_s1.ndd(1)
      for j= 1: g_s1.ndd(2)
         res.deriv{i,j}= (g_s1.deriv{i,j}.* s2- ...
               0.5.* (s1.deriv{i}.* g_s2.deriv{j}+ ...
                     s1.deriv{j}.* g_s2.deriv{i})).* denom;
      end
   end
elseif g_s1.dims==1 && g_s2.dims==2
   error('Malfunction: s2 has to be non-deriv object!');
   %res= g_s2;
   % g_s1 = g_s1, s1= s1, g_s2= h_s2, s2= g_s2
   %for i= 1: g_s2.ndd(1)
      %for j= 1: g_s2.ndd(2)
         %res.deriv{i,j}= s1.* g_s2.deriv{i,j}+ ...
               %0.5* (g_s1.deriv{i}.* s2.deriv{j}+ g_s1.deriv{j}.* s2.deriv{i});
      %end
   %end
else
   error('Internal error.');
end


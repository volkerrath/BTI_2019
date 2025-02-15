function res= mrdivide(s1, s2)
%ADDERIV/MRDIVIDE Divide a derivative by a matrix.
%
% Copyright 2001-2004 Andre Vehreschild, Institute for Scientific Computing   
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!


if isa(s2, 'adgradobj')
   error('Denominator is active. This is never to happen!');
else
   res= adderivsp(s1);

   if res.dims==1
      for i= 1: res.ndd 
         res.deriv{i}= cond_sparse(s1.deriv{i}/ s2);
      end
   else
      for i= 1: res.ndd(1)
         for j= 1: res.ndd(2)
            res.deriv{i,j}= cond_sparse(s1.deriv{i,j}/ s2);
         end
      end
   end
end


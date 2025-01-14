function res= mtimes(s1, s2)
%ADDERIV/MTIMES Multication operator
%
% Copyright 2001-2004 Andre Vehreschild, Institute for Scientific Computing   
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!


if isa(s1, 'adderiv')& isa(s2, 'adderiv')
   if s1.dims==1 & s2.dims==1
      res= adderiv([s1.ndd, s2.ndd], [], 'empty');
      for i= 1: s1.ndd
         for j= 1: s2.ndd
            res.deriv{i,j}= 0.5*(s1.deriv{i}* s2.deriv{j}+ ...
                                 s1.deriv{j}* s2.deriv{i});
         end
      end
   else
      error('Multiplication of two derivative objects is defined for one-dimensional objects only.');
   end
elseif isa(s1, 'adderiv')
   res= adderiv(s1);

   if res.dims==1
      for c= 1: res.ndd
         res.deriv{c}= s1.deriv{c}* s2;
      end
   else
      for i= 1: res.ndd(1)
         for j= 1: res.ndd(2)
            res.deriv{i,j}= s1.deriv{i,j}* s2;
         end
      end
   end
else
   res= adderiv(s2);

   if res.dims==1
      for c= 1: res.ndd
         res.deriv{c}= s1* s2.deriv{c};
      end
   else
      for i= 1: res.ndd(1)
         for j= 1: res.ndd(2)
            res.deriv{i,j}= s1* s2.deriv{i,j};
         end
      end
   end
end


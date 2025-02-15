function res= plus(s1, s2)
%ADDERIV/PLUS Addition-operator
%
% Copyright 2001-2004 Andre Vehreschild, Institute for Scientific Computing   
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!


if isa(s1, 'adderivsp')& isa(s2, 'adderivsp')
   res= adderivsp(s1);

   if res.dims==1
      for i= 1: res.ndd
         res.deriv{i}= s1.deriv{i}+ s2.deriv{i};
      end
   else
      for i= 1: res.ndd(1)
         for j= 1: res.ndd(2)
            res.deriv{i,j}= s1.deriv{i,j}+ s2.deriv{i,j};
         end
      end
   end
elseif isa(s1, 'adderivsp')
   res= adderivsp(s1);

   if res.dims==1
      for i= 1: res.ndd
         res.deriv{i}= s1.deriv{i}+ s2;
      end
   else
      for i= 1: res.ndd(1)
         for j= 1: res.ndd(2)
            res.deriv{i,j}= s1.deriv{i,j}+ s2;
         end
      end
   end
else 
   res= adderivsp(s2);

   if res.dims==1
      for i= 1: res.ndd
         res.deriv{i}= s1+ s2.deriv{i};
      end
   else
      for i= 1: res.ndd(1)
         for j= 1: res.ndd(2)
            res.deriv{i,j}= s1+ s2.deriv{i,j};
         end
      end
   end
end


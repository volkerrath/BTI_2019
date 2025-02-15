function varargout=subsref(g, i)
%ADDERIV/SUBSREF Index into to derivative object
%
% Copyright 2001-2004 Andre Vehreschild, Institute for Scientific Computing   
%                     RWTH Aachen University
% This code is under development! Use at your own risk! Duplication,
% modification and distribution FORBIDDEN!

switch i(1).type
case '{}'
   mr14= ~get(g, 'SubsRefBug');
   if g.dims==1
      ind= i(1).subs{1};
      if size(i(1).subs,2)>1
         i(1).subs= i(1).subs{2:end};
      else
         i(1)=[];
      end
      if (isa(ind, 'char') & (ind==':'))
         % Workaround for MATLAB-bug: Subsref returns data in reverse order.
         % http://www.mathworks.com/support/solutions/data/33496.shtml
         if mr14
            ind= 1:g.ndd;
         else
            ind= g.ndd:-1:1;
         end
         if size(i, 2)> 0
            varargout= {subsref([g.deriv{ind}], i)};
         else
            varargout= {g.deriv{ind}};
         end
      elseif ind<= g.ndd
         % Workaround for MATLAB-bug: Subsref returns data in reverse order.
         % http://www.mathworks.com/support/solutions/data/33496.shtml
         if ~mr14
            ind= ind(length(ind):-1:1);
         end
         if size(i, 2)> 0
            varargout= {subsref([g.deriv{ind}], i)};
         else
            varargout= {g.deriv{ind}};
         end
      else
         error(sprintf('Index %d out of range 1: %d', ind, g.ndd));
      end
   else
      if length(i(1).subs)<2
         error('Need two indices to adress twodimensional derivative.');
      end
      ind= {i(1).subs{1:2}};
      if size(i(1).subs,2)>2
         i(1).subs= i(1).subs{3:end};
      else
         i(1)=[];
      end
      if (isa(ind{1}, 'char') & (ind{1}==':'))
         % Workaround for MATLAB-bug: Subsref returns data in reverse order.
         % http://www.mathworks.com/support/solutions/data/33496.shtml
         if mr14
            ind{1}= 1:g.ndd(1);
         else
            ind{1}= g.ndd(1):-1:1;
         end
      elseif max(ind{1})<= g.ndd(1) 
         % Workaround for MATLAB-bug: Subsref returns data in reverse order.
         % http://www.mathworks.com/support/solutions/data/33496.shtml
         if ~ mr14
            ind{1}= ind{1}(length(ind{1}):-1:1);
         end
      else
         error(sprintf('First index %d out of range 1: %d', max(ind{1}), g.ndd(1)));
      end
      if (isa(ind{2}, 'char') & (ind{2}==':'))
         % Workaround for MATLAB-bug: Subsref returns data in reverse order.
         % http://www.mathworks.com/support/solutions/data/33496.shtml
         if mr14
            ind{2}= 1: g.ndd(2);
         else
            ind{2}= g.ndd(2):-1:1;
         end
      elseif max(ind{2})<=g.ndd(2)
         % Workaround for MATLAB-bug: Subsref returns data in reverse order.
         % http://www.mathworks.com/support/solutions/data/33496.shtml
         if ~ mr14
            ind{2}= ind{2}(length(ind{2}):-1:1);
         end
      else
         error(sprintf('Second index %d out of range 1: %d', max(ind{2}), g.ndd(2)));
      end
      if size(i, 2)> 0
         varargout= {subsref([g.deriv{ind{:}}], i)};
      else
         varargout= {g.deriv{ind{:}}};
      end
   end
case '()'
   res= adderiv(g);

   if g.dims==1
      for j= 1: g.ndd
         res.deriv{j}= subsref(g.deriv{j}, i);
      end
   else
      for c= 1: g.ndd(1)
         for j= 1: g.ndd(2)
            res.deriv{c,j}= subsref(g.deriv{c,j}, i);
         end
      end
   end
   varargout{1}= res;
case '.'
   res= adderiv(g);

   if g.dims==1
      for j= 1: g.ndd
         res.deriv{j}= subsref(g.deriv{j}, i);
      end
   else
      for c= 1: g.ndd(1)
         for j= 1: g.ndd(2)
            res.deriv{c,j}= subsref(g.deriv{c,j}, i);
         end
      end
   end
   varargout{1}= res;
otherwise
   error('Internal error.');
end


% kaiserbeta() - Estimate maximum passband deviation/ripple for Kaiser beta
%
% Usage:
%   >> dev = invkaiserbeta( beta );
%
% Input:
%   beta      - scalar Kaiser window beta
%
% Output:
%   dev       - scalar maximum passband deviation/ripple
%
% References:
%   [1] Proakis, J. G., & Manolakis, D. G. (1996). Digital Signal
%       Processing: Principles, Algorithms, and Applications (3rd ed.).
%       Englewood Cliffs, NJ: Prentice-Hall
%
% Author: Andreas Widmann, University of Leipzig, 2015

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) 2005-2015 Andreas Widmann, University of Leipzig, widmann@uni-leipzig.de
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% $Id$

function [ dev ] = invkaiserbeta( beta )

if beta > 0.1102 * (50 - 8.7)
    devdb = beta / 0.1102 + 8.7;
else
    devdb = fzero( @( x ) 0.5842 * ( x - 21 )^0.4 + 0.07886 * ( x - 21 ) - beta, [ 21 51 ] );
end

dev = 10 ^ ( -devdb / 20 );

end

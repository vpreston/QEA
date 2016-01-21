% Lower (-z) half of ellipsoid defined by (x/l)^2+(y/b)^2+(z/d)^2=1.
% l is half of the length of the boat.
% b is half of the width (beam) of the boat.
% d is the height of the boat hull.
% Operates elementwise on inputs. Sizes of all inputs must be identical or
% scalar.  x and y must be the same size.
function z = globalHull(x, y, l, b, d)
c = (x./l).^2 + (y./b).^2; % scaled, weighted distance from center of hull
z = -d.*sqrt(1-c);
z(c == 1) = 0; % on hull perimeter
z(c > 1) = NaN; % outside hull perimeter
end
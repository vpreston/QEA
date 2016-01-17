function [underwaterf, normal, point, coeffs] = getWaterlinef(tilt, heel, depth)
% Gets the elementwise boolean function of the waterline, which returns
% true if the point (x, y, z) lies on the opposite side of the plane from
% the normal vector (i.e. is underwater).  This function also returns the
% normal vector to the plane, the intersection between the normal vector
% (with origin at the origin) and the plane, and the coefficients of the
% plane function.  All outputs are row vectors.
%   
% The waterline is defined in the boat's coordinate system and is of the
% form a*x+b*y+c*z+d=0. These constants are found by defining the normal
% vector of the plane [a, b, c] using the tilt and heel angles. The normal
% vector is then normalized to be a unit vector, which puts the units of d
% into the same units as x, y, z, allowing us to simply set d = -depth
% (distance from plane to origin, with direction relative to the normal
% vector).
normal = [sind(tilt) sind(heel) cosd(tilt)*cosd(heel)]; % normal vector
normal = normal/norm(normal); % normalize normal vector
a = normal(1);
b = normal(2);
c = normal(3);
d = -depth;
coeffs = [a b c d];
point = depth*normal;

underwaterf = @(x, y, z) a*x + b*y + c*z + d < 0;
end

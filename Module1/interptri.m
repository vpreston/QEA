% INTERPTRI Interpolate Triangulation.
% QZ = INTERPTRI(TRI, DZ, QX, QY) linearly interpolates the value of a
% triangular mesh defined by triangulation object TRI and value column
% vector DZ. The number of elements in DZ should be the maximum value of
% the connectivity list in TRI. The query point locations given by QX and
% QY must be the same size. QZ(i,j) is the linear interpolation of the
% value of the mesh at the point (QX(i,j), QY(i,j)). For values outside the
% domain of the mesh, QZ returns NaN.

% http://www.mathworks.com/help/matlab/math/interpolation-using-a-specific-delaunay-triangulation.html
function qz = interptri(TR, dz, qx, qy)
% Find the triangle that encloses each query point using the pointLocation
% method. In the code below, ti contains the IDs of the enclosing triangles
% and bc contains the barycentric coordinates associated with each
% triangle.
qx = bsxfun(@plus, qx, zeros(size(qy)));
qy = bsxfun(@plus, qy, zeros(size(qx)));
[ti, bc] = TR.pointLocation(qx(:), qy(:));
tinan = isnan(ti); % logical vector where ti is NaN
ti(tinan) = 1; % set NaN elements to something non-NaN
bc(tinan, :) = zeros(size(bc(tinan, :))); % give 0 weight to NaN elements
% Find the values of V(x, y) at the vertices of each enclosing triangle.
% Also make sure that it's the same shape as bc (bc is always the right
% shape, but sometimes dz(...) isn't).
triVals = reshape(dz(TR.ConnectivityList(ti,:)), size(bc));
% Calculate the sum of the weighted values of V(x, y) using the dot product
% on each row.
qz = dot(bc, triVals, 2); % same as dot(bc', triVals')'
qz(tinan) = NaN;
qz = reshape(qz, size(qx));
end
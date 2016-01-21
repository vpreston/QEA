function A = triArea(P)
% Find the area of a triangle given the xyz locations of its three vertices
% as the three rows of P.
assert(all(size(P) == [3 3]), 'Must give three points in Cartesian coordinates');

P = P.'; % transpose so determinant math is prettier
o = ones(1,3);

A = sqrt(det([P(1:2,:);o])^2 + det([P(2:3,:);o])^2 + det([P([3 1],:);o])^2)/2;
end
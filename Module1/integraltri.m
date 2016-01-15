% INTEGRALTRI Integrate Triangulation.
% [V, A] = INTERPTRI(TRI, DZ) integrates the value under a
% triangular mesh defined by triangulation object TRI and value column
% vector DZ. The number of elements in DZ should be the maximum value of
% the connectivity list in TRI.
% A is the base area of TRI. If DZ == 1, then V = A.

function [V, A] = integraltri(TR, dz)
V = 0;
A = 0;
for i = 1:TR.size(1)
    vertices = TR.ConnectivityList(i,:); % indices of triangle vertices
    points = TR.Points(vertices,:); % locations of triangle vertices
    
    h = mean(dz(vertices)); % height of the barycenter (centroid)
    a = 1/2*abs(det([points ones(3,1)])); % area of base triangle
    A = A + a;
    V = V + a*h;
end
end
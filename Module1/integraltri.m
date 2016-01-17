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
    [v, a] = wedgeVolume(TR.Points(vertices,:), dz(vertices));
    
    A = A + a;
    V = V + v;
end
end

figure;
hold on;
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

% turn off warnings thrown in getCentroid if duplicate points aren't
% removed (which takes lots of time)
warning('off', 'MATLAB:delaunay:DupPtsDelaunayWarnId');

filename = 'Hull.STL';
[TRl, TRu, fl, fu, vl, vu, nl, nu, f, v, n] = stl2tri(filename);
for i = 1:size(f, 1)
    P = v(f(i,:)',1:2);
    H = v(f(i,:)',3);
    V = [P zeros(3,1); P(H~=0,:) H(H~=0)];
    [c(i,:), vol(i,1)] = getCentroid(V);
end

tilt = 0;
heel = 10;
func = @(depth) float(f, v, vol, c, tilt, heel, depth, 0, 0);
depth = fzero(func, [-0.1 -0.01]);

[~, dC, tC, dM, tM, dF, tF] = float(f, v, vol, c, tilt, heel, depth, 1, 0);
moment = cross(dC-tC, [0 0 -dF])

plotSTL();

plot3(dC(1), dC(2), dC(3), 'r*', 'markersize', 15, 'linewidth', 2);
plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2);

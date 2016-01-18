figure;
hold on;
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

[TRl, TRu, fl, fu, vl, vu, nl, nu] = stl2tri('Hull.STL');

tilt = 0;
heel = 10;
depth = fzero(@(depth) float(fl, fu, vl, vu, tilt, heel, depth, false), [-0.1 -0.01]);

[~, dC, tC, dM, tM, dF, tF] = float(fl, fu, vl, vu, tilt, heel, depth, true);
moment = cross(dC-tC, [0 0 -dF])

plotSTL();

plot3(dC(1), dC(2), dC(3), 'r*', 'markersize', 15, 'linewidth', 2);
plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2);

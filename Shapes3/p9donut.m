u = linspace(0, 2*pi, 10); % short direction
v = linspace(0, 2*pi, 30); % long direction
[U, V] = meshgrid(u, v);
a = 4;
r = 1;

rx = (a+r*cos(U)).*cos(V);
ry = (a+r*cos(U)).*sin(V);
rz = r*sin(U);

surf(rx, ry, rz);
xlabel('x');
ylabel('y');
zlabel('z');
axis equal

nx = cos(U).*cos(V);
ny = cos(U).*sin(V);
nz = sin(U);
hold on
quiver3(rx, ry, rz, nx, ny, nz, 0, 'LineWidth', 2, 'MaxHeadSize', 1);

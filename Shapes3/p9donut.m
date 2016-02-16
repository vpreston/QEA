u = linspace(0, 2*pi);
v = linspace(0, 2*pi);
[U, V] = meshgrid(u, v);
a = 3;
r = 1;

rx = (a+r*cos(U)).*cos(V);
ry = (a+r*cos(U)).*sin(V);
rz = r*sin(U);

surf(rx, ry, rz);
xlabel('x');
ylabel('y');
zlabel('z');
axis equal
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
title('Donut Normal Vectors');
axis equal

nx = cos(U).*cos(V);
ny = cos(U).*sin(V);
nz = sin(U);
hold on
quiver3(rx, ry, rz, nx, ny, nz, 0, 'LineWidth', 2, 'MaxHeadSize', 1);

% analytical surface area integration
A_analytical = 2*pi*integral(@(u) r*(a+r*cos(u)), 0, 2*pi);
disp(A_analytical);

% numerical surface area integration
[m, n] = size(rz);
A_numerical = 0;
for i = 1:m-1
    for j = 1:n-1
        % get four vertices of corners of each face
        v0 = [rx(i,j)     ry(i,j)     rz(i,j)    ];
        v1 = [rx(i,j+1)   ry(i,j+1)   rz(i,j+1)  ];
        v2 = [rx(i+1,j)   ry(i+1,j)   rz(i+1,j)  ];
        v3 = [rx(i+1,j+1) ry(i+1,j+1) rz(i+1,j+1)];
        % get vectors describing dimensions of three corners relative to
        % origin corner
        a = v1 - v0;
        b = v2 - v0;
        c = v3 - v0;
        % get area as half the magnitude of the cross produt
        area = 1/2*(norm(cross(a, c)) + norm(cross(b, c)));
        A_numerical = A_numerical + area;
    end
end
disp(A_numerical);

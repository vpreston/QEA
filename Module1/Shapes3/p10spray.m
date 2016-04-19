%% Defining our surface
W = 4; % width (y) of the Spray [m]
L = 12; % length (x) of the Spray [m]
H = 2; % height (z) of the Spray [m]
xmin = -L/2;
xmax = L/2;
zmin = @(x) H*((2*x/L).^4-1);
zmax = @(x) 0; % topsides of boat is flat
ymin = @(x,z) W/2*(2*x/L).^2 - W/2*sqrt((z+H)/H); % ymin(x,zmin)=0
ymax = @(x,z) -ymin(x,z); % ymax(x,zmin)=0


%% Let's plot this region using a typical xz mesh
subplot(1, 3, 1);
xvec = linspace(xmin, xmax, 20); % domain vectors for x and z
zvec = linspace(-H, 0, 20); % these numbers were found analytically
[Xmat, Zmat] = meshgrid(xvec, zvec); % create gridded representations of domain vectors

Ymatmin = ymin(Xmat, Zmat); % call our y functions with the gridded xz matrices
Ymatmax = ymax(Xmat, Zmat);
Ymatmin(real(Ymatmin) >= 0) = NaN; % NaN values don't show up in plots
Ymatmax(real(Ymatmax) <= 0) = NaN;

surf(Xmat, Ymatmin, Zmat); % 'EdgeColor', 'none'
hold on
surf(Xmat, Ymatmax, Zmat);
xlabel('x');
ylabel('y');
zlabel('z');
title('Cartesian Gridded Representation');
axis equal


%% Let's now parametrize the surface and plot it with a different mesh
subplot(1, 3, 2);
umin = -1; % x = L/2*u
umax = 1;
vmin = 0; % v scales the z axis between 0 (zmin) and 1 (zmax)
vmax = 1;

uvec = linspace(umin, umax, 20); % domain vectors for u and v
vvec = linspace(vmin, vmax, 20);
[Umat, Vmat] = meshgrid(uvec, vvec); % create gridded representations of domain vectors

z_uv = @(u,v) (1-v).*zmin(L/2*u) + v.*zmax(L/2*u); % finding z values from u and v
Xmat = L/2*Umat;
Zmat = z_uv(Umat, Vmat);
Ymatmin = real(ymin(Xmat, Zmat)); % call our z functions with the gridded xy matrices
Ymatmax = real(ymax(Xmat, Zmat));

surf(Xmat, Ymatmin, Zmat); % 'EdgeColor', 'none'
hold on
surf(Xmat, Ymatmax, Zmat);
xlabel('x');
ylabel('y');
zlabel('z');
title('Stretched Cartesian Parametric Representation');
axis equal

%% Now let's use a simplified mesh and find the surface area
subplot(1, 3, 3);
umin = -1; % x = L/2*u
umax = 1;
vmin = -1; % v scales the z axis between -1 (zmax) and 0 (zmin) and 1 (zmax)
vmax = 1;

uvec = linspace(umin, umax, 20); % domain vectors for u and v
vvec = linspace(vmin, vmax, 40);
[u,v] = meshgrid(uvec, vvec); % create gridded representations of domain vectors

sgn = @(x) (sign(x)+(x==0));
rx = L/2*u;
ry = sgn(v).*W/2.*(u.^2-sqrt((1-v.^2).*(u.^4-1)+1));
rz = (1-v.^2).*H.*(u.^4-1);

surf(rx, ry, rz); % 'EdgeColor', 'none'
xlabel('x');
ylabel('y');
zlabel('z');
title('Simplified Stretched Cartesian Parametric Representation');
axis equal

% analytical surface area integration
sz = size(u);
drdu = zeros([sz 3]); drdv = zeros([sz 3]);
drdu(:,:,1) = L/2*ones(sz); % drdu_x
drdu(:,:,2) = sgn(v)*W.*(u-(1-v.^2).*u.^3./sqrt((1-v.^2).*(u.^4-1)+1)); % drdu_y
drdu(:,:,3) = (1-v.^2)*H*4.*u.^3; % drdu_z
drdv(:,:,1) = zeros(sz); % drdv_x
drdv(:,:,2) = sgn(v)*W.*v.*(u.^4-1)/2./sqrt((1-v.^2).*(u.^4-1)+1); % drdv_y
drdv(:,:,3) = -2*v*H.*(u.^4-1); % drdv_z
integrand = sqrt(sum(cross(drdu, drdv, 3).^2, 3));
A_analytical = trapz(vvec, trapz(uvec, integrand, 2));
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

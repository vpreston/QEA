%% Defining our surface
% Let's define our 3D region as an xy paraboloid on the bottom and an
% ellipsoid on the top which intersects the z=0 plane in an ellipsoid.
% We create these shapes as unit shapes and then stretch the x-dimension by
% a factor of 2 (x' = x/2).
xmin = -2;
xmax = 2;
ymin = @(x) -sqrt(1-(x/2).^2);
ymax = @(x) -ymin(x); % surface is symmetric across x=0
zmin = @(x,y) (x/2).^2 + y.^2 - 1; % zmin(x,ymin)=0 and zmin(x,ymax)=0
zmax = @(x,y) sqrt(1-(x/2).^2-y.^2); % zmax(x,ymin)=0 and zmax(x,ymax)=0


%% Let's plot this region using a typical xy mesh
subplot(1, 3, 1);
xvec = linspace(xmin, xmax, 20); % domain vectors for x and y
yvec = linspace(-1, 1, 20); % these numbers were found analytically
[Xmat, Ymat] = meshgrid(xvec, yvec); % create gridded representations of domain vectors

Zmatmin = zmin(Xmat, Ymat); % call our z functions with the gridded xy matrices
Zmatmax = zmax(Xmat, Ymat);
Zmatmin(Zmatmin >= 0) = NaN; % NaN values don't show up in plots
Zmatmax(real(Zmatmax) <= 0) = NaN;

surf(Xmat, Ymat, Zmatmin); % 'EdgeColor', 'none'
hold on
surf(Xmat, Ymat, Zmatmax);
xlabel('x');
ylabel('y');
zlabel('z');
title('Cartesian Gridded Representation');
axis equal


%% Let's now parametrize the surface and plot it with a different mesh
subplot(1, 3, 2);
umin = xmin; % x = u
umax = xmax;
vmin = 0; % v scales the y axis between 0 (ymin) and 1 (ymax)
vmax = 1;

y_uv = @(u,v) (1-v).*ymin(u) + v.*ymax(u); % finding y values from u and v
uvec = linspace(umin, umax, 20); % domain vectors for u and v
vvec = linspace(vmin, vmax, 20);
[Umat, Vmat] = meshgrid(uvec, vvec); % create gridded representations of domain vectors

Xmat = Umat;
Ymat = y_uv(Umat, Vmat);
Zmatmin = zmin(Xmat, Ymat); % call our z functions with the gridded xy matrices
Zmatmax = real(zmax(Xmat, Ymat));

surf(Xmat, Ymat, Zmatmin); % 'EdgeColor', 'none'
hold on
surf(Xmat, Ymat, Zmatmax);
xlabel('x');
ylabel('y');
zlabel('z');
title('Stretched Cartesian Parametric Representation');
axis equal


%% Let's now define the surface in polar and plot it with a different mesh
subplot(1, 3, 3);
rmin = 0; % r will replace sqrt((x/2)^2+y^2)
rmax = 1;
tmin = 0; % theta (t) will be used to sweep around and x- and y- axes
tmax = 2*pi;

x_rt = @(r,t) 2*r.*cos(t);
y_rt = @(r,t) r.*sin(t);

% zmin_rt = @(r,t) r.^2 - 1; % alternate definition
% zmax_rt = @(r,t) sqrt(1-r.^2);

rvec = linspace(rmin, rmax, 20); % domain vectors for r and t
tvec = linspace(tmin, tmax, 20);
[Rmat, Tmat] = meshgrid(rvec, tvec); % create gridded representations of domain vectors

Xmat = x_rt(Rmat, Tmat);
Ymat = y_rt(Rmat, Tmat);
Zmatmin = zmin(Xmat, Ymat);
Zmatmax = real(zmax(Xmat, Ymat));
% Zmatmin = zmin_rt(Rmat, Tmat); % this works for the alternate definition
% Zmatmax = real(zmax_rt(Rmat, Tmat));

surf(Xmat, Ymat, Zmatmin); % 'EdgeColor', 'none'
hold on
surf(Xmat, Ymat, Zmatmax);
xlabel('x');
ylabel('y');
zlabel('z');
title('Polar Parametric Representation');
axis equal

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

% tic
% a = integral3(@(x,y,z) double(z<0.5), xmin, xmax, ymin, ymax, 0, zmax, ...
%     'method', 'iterated', 'abstol', 1e-8, 'reltol', 1e-4);
% b = integral3(@(x,y,z) double(z<0.5), xmin, xmax, ymin, ymax, zmin, 0, ...
%     'method', 'iterated', 'abstol', 1e-8, 'reltol', 1e-4);
% toc
% disp(a+b);

d = 0.5; % depth of water plane
belowness = @(x,y,z) d - z; % sign of result is z < d
trueness = @(x,n) 1/2 + 1/2*tanh(n*x); % similar to double(x > 0)

% To speed it up, we can get rid of the discontinuity caused by the boolean
% operation:
% double(z < 0) is numerically very close to 1/2-1/2*tanh(n*z) where n >> 1
figure; hold on
nVec = logspace(1.5, 2.5, 10);
for i=1:length(nVec)
    disp(100*i/length(nVec));
    n = nVec(i);
    tic
    c = integral3(@(x,y,z) trueness(belowness(x,y,z), n), xmin, xmax, ymin, ymax, 0, zmax);
    d = integral3(@(x,y,z) trueness(belowness(x,y,z), n), xmin, xmax, ymin, ymax, zmin, 0);
    timeTaken(i) = toc;
    % disp(c+d);
    vol(i) = c+d;
end
plot(timeTaken, vol);
xlabel('Computation Time [s]');
ylabel('Integration Result []');

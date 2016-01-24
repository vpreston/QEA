% turn off warnings thrown in getCentroid if duplicate points aren't
% removed (which takes lots of time)
warning('off', 'MATLAB:delaunay:DupPtsDelaunayWarnId');

% heelVec = 20;
heelVec = linspace(0, 180, 40);

filename = 'EllipsoidHull.STL';
% filename = 'SweptHull.STL';
% filename = 'SweptHullDeclustered.STL';
[TRl, TRu, fl, fu, vl, vu, nl, nu, f, v, n] = stl2tri(filename);

%% plot boat
subplot(1, 2, 1);
hold on;
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
view(3);
plotSTL(filename);

%% calculate centroid and volume for each element of boat
for i = 1:size(f, 1)
    P = v(f(i,:)',1:2);
    H = v(f(i,:)',3);
    V = [P zeros(3,1); P(H~=0,:) H(H~=0)];
    [c(i,:), vol(i,1)] = getCentroid(V);
end

%% sweep heel angle to find floating depths and righting moments
heelSz = length(heelVec);
momentVec = zeros(heelSz, 3);
depthVec = zeros(heelSz, 1);
for j=1:heelSz
    disp([num2str((j-1)/heelSz*100, 2) '%']);
    tilt = 0;
    heel = heelVec(j);
    func = @(depth) float(f, v, vol, c, tilt, heel, depth, [0 0]);
    depth = fzero(func, [-0.1 0.1]);
    depthVec(j) = depth;
    
    % get righting moment, get centroid information, and plot waterline
    [~, T, dC, tC, pN] = float(f, v, vol, c, tilt, heel, depth, [1 0]);
    
    % plot centroid location for submerged region of boat
    plot3(dC(1), dC(2), dC(3), 'r*', 'markersize', 15, 'linewidth', 2);
    plotLines(dC, dC+0.1*pN, 'r-', 2);
    
    % get righting moment without plotting anything
    %         [~, T] = float(f, v, vol, c, tilt, heel, depth, [0 0]);
    
    momentVec(j, :) = -T*sign(heel); % righting moment
end
disp('100%');

% plot centroid location for entire boat
plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2);

subplot(1, 2, 2);
% plot righting moment and depth over heel angle
[ax, h1, h2] = plotyy(heelVec, momentVec(:,1), heelVec, depthVec);
title('Boat Characteristics');
xlabel('Heel Angle [deg]');
ylabel(ax(1), 'Righting Moment [N-m]');
ylabel(ax(2), 'Boat Depth [m]');
set([h1;h2], 'Marker', 'o');

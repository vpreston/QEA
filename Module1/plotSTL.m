function plotSTL()
filename = 'Hull.STL';
[~, ~, fl, fu, vl, vu] = stl2tri(filename);
dxl = vl(:,1);
dyl = vl(:,2);

%% Plot raw STL data

% subplot(1,2,1);

% plot patch
% patch('Faces', fl, 'Vertices', vl, 'FaceColor', 'none');
% patch('Faces', fu, 'Vertices', vu, 'FaceColor', 'none');

% alternate plotting methods
% trimesh(fu, dxu, dyu, dzu);
TRl = triangulation(fl, vl);
trisurf(TRl, 'edgecolor', 'k', 'facecolor', 'none');
hold on;
TRu = triangulation(fu, vu);
trisurf(TRu, 'edgecolor', 'k', 'facecolor', 'none');

% format plot
axis equal
xlabel('x');
ylabel('y');
zlabel('z');


%% Plot interpolated mesh data

% subplot(1,2,2);
% qx = linspace(min(dxl), max(dxl), 100);
% qy = linspace(min(dyl), max(dyl), 100);
% [Qx, Qy] = meshgrid(qx, qy);

% scattered interpolation function (compare to griddata)
% fzl = scatteredInterpolant(dyl, dxl, dzl, 'linear', 'none'); % try 'natural'
% qzl = fzl({qy,qx});

% triangular interpolation function (uses interptri)
% [fzl, fzu] = localHull(filename);
% qzl = fzl(Qx, Qy);
% qzu = fzu(Qx, Qy);

% plot interpolated surface
% surf(qx, qy, qzl);
% hold on
% surf(qx, qy, qzu);

% format plot
% axis equal;
% xlabel('x');
% ylabel('y');
% zlabel('z');
end
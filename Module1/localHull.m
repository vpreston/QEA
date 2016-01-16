function [fzl, fzu, lims] = localHull(filename)
[TRl, TRu, ~, ~, vl, vu] = stl2tri(filename);
dxl = vl(:,1);
% dxu = vu(:,1);
dyl = vl(:,2);
% dyu = vu(:,2);
dzl = vl(:,3);
dzu = vu(:,3);

fzl = @(qx, qy) interptri(TRl, dzl, qx, qy);
fzu = @(qx, qy) interptri(TRu, dzu, qx, qy);

% Get indices of vertices in convex hull, counterclockwise from
% most-x-negative point. The convex hull is the same for the lower and
% upper meshes because their intersection is defined as the maximum extent
% of the domain. CH(1) = CH(end) because the convex hull is a full loop.
CH = convhull(dxl, dyl);

dxCH = dxl(CH);
dyCH = dyl(CH);

% Find x domain min and max values, along with indices of those points in
% the CH list (NOT the original dxl list).
ixmin = 1;
xmin = dxCH(ixmin);
[xmax, ixmax] = max(dxCH);
ixend = length(CH);

% Find index vectors of y min and max domains in CH list.
iymin = ixmin:ixmax;
iymax = ixmax:ixend;
ymin = @(x) interp1(dxCH(iymin), dyCH(iymin), x, 'linear');
ymax = @(x) interp1(dxCH(iymax), dyCH(iymax), x, 'linear');

% We already know the min and max functions for z (which have domain
% of xmin to xmax and ymin to ymax)
zmin = fzl;
zmax = fzu;

% Combine limits into cell array ready to be used by integral3.
lims = {xmin, xmax, ymin, ymax, zmin, zmax};

% figure;
% hold on
% plot(dxCH(iymin), dyCH(iymin), 'r*-');
% plot(dxCH(iymax), dyCH(iymax), 'b*-');
% plot(dxl, dyl, 'g.');
% plot(dxCH(ixmin), dyCH(ixmin), 'ko');
% plot(dxCH(ixmax), dyCH(ixmax), 'ko');
% plot(dxCH(ixend), dyCH(ixend), 'ko');
end
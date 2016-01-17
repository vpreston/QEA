function [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP)
% Calculates the volume under a plane and inside a wedge.
%
% points is the 3x2 row-wise list of 3 xy points that define the vertices
% of the base triangle of the wedge which lies in the xy plane.  heights is
% the 3x1 row-wise list of z values of the three vertices of the wedge
% which are not in the xy plane.  underplanef is a boolean function which
% determines whether a point is under the plane.  n is the normal vector of
% the plane.  p is a point in the plane.

%% assemble all wedge informations
% build full points list from base triangle and height information
v = [P zeros(3,1); P H];
% get centroid and volume of entire wedge (compare to wedgeVolume)
[tC, tVol] = getCentroid(v);
% connectivity and adjacency lists of wedge vertices
f = [1 2 3 NaN; 4 5 6 NaN; 1 2 5 4; 2 3 6 5; 1 3 6 4];
adjacencies = [2 3 4; 1 3 5; 1 2 6; 1 5 6; 2 4 6; 3 4 5];

%% plot wedge edges and underwater region
% patch('faces', f, 'vertices', v, 'edgecolor', 'k', 'linewidth', 2, 'facecolor', 'none');
% view(3);
% hold on;
% [X, Y, Z] = meshgrid(linspace(min(v(:,1)), max(v(:,1)), 10), ...
%     linspace(min(v(:,2)), max(v(:,2)), 10), ...
%     linspace(min(v(:,3)), max(v(:,3)), 15));
% b = underPlanef(X, Y, Z);
% s(b) = 10; % circles of size 10 for underwater points
% s(~b) = NaN; % do not plot above water points
% scatter3(X(:), Y(:), Z(:), s(:), 'b');
% axis equal
% xlabel('x');
% ylabel('y');
% zlabel('z');

%% find which of the wedge's vertices are under the plane
underPlane = planef(v(:,1), v(:,2), v(:,3));
pointsUnder = v(underPlane, :);
numUnder = sum(pointsUnder);
if numUnder == 0 % wedge is entirely above plane
    vol = 0;
    C = tC;
    return
elseif numUnder == 6; % wedge is entirely below plane
    vol = tVol;
    C = tC;
    return
end

%% find index pairs of vertices describing edges intersecting the plane
inds = find(underPlane); % indices of points under the plane
adjs = adjacencies(underPlane, :); % indices of points adjacent to pointsUnder
edgesAll = [repmat(inds, 3, 1) adjs(:)]; % adjacent edge pairs [underwater all]
edgesInds = any(bsxfun(@eq, find(~underPlane)', edgesAll(:,2)), 2);
edges = unique(sort(edgesAll(edgesInds, :), 2), 'rows');

%% find edge-plane intersections to fully define region of wedge under plane
P0 = v(edges(:,1), :);
P1 = v(edges(:,2), :);
[intPoints, check] = planeLineIntersection(pN, pP, P0, P1);
% plotLines(P0, intPoints, 'ro-', 3); % plot lines and intersection points
assert(all(check == 1), 'intersections borken');
pCH = [pointsUnder; intPoints]; % convex hull points

%% plot region of wedge under the plane (comment all if not plotting)
% get convex hull indices and volume of wedge under plane
% [triCH, vol] = convhull(pCH(:,1), pCH(:,2), pCH(:,3));
% % check that all points in pCH are used in the convex hull
% assert(length(unique(triCH(:))) == size(pCH, 1), 'pCH isn"t complex');
% % plot convex hull indicating volume under water and within wedge
% plot3(pCH(:,1), pCH(:,2), pCH(:,3), 'ro', 'markersize', 7, 'markerfacecolor', 'r');
% trimesh(triCH, pCH(:,1), pCH(:,2), pCH(:,3), 'edgecolor', 'none', ...
%     'facecolor', 'r', 'facealpha', 0.3);

%% find centroid by adding weighted centroid of all simplices
[C, vol] = getCentroid(pCH);
% plot3(C(1), C(2), C(3), 'r*', 'markersize', 15, 'linewidth', 2);
end

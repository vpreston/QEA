function volume = partialWedgeVolume(points, heights, underPlanef, n, p)
% Calculates the volume under a plane and inside a wedge.
%
% points is the 3x2 row-wise list of 3 xy points that define the vertices
% of the base triangle of the wedge which lies in the xy plane.  heights is
% the 3x1 row-wise list of z values of the three vertices of the wedge
% which are not in the xy plane.  underplanef is a boolean function which
% determines whether a point is under the plane.  n is the normal vector of
% the plane.  p is a point in the plane.

volume = 0;

% build full points list from base triangle and height information
v = [points zeros(3,1); points heights];

% connectivity and adjacency lists of wedge vertices
f = [1 2 3 NaN; 4 5 6 NaN; 1 2 5 4; 2 3 6 5; 1 3 6 4];
adjacencies = [2 3 4; 1 3 5; 1 2 6; 1 5 6; 2 4 6; 3 4 5];

% patch('faces', f, 'vertices', v, 'facecolor', 'blue', 'facealpha', 0.3);
patch('faces', f, 'vertices', v, 'edgecolor', 'k', 'linewidth', 2, 'facecolor', 'none');
view(3);
hold on;
[X, Y, Z] = meshgrid(linspace(min(v(:,1)), max(v(:,1)), 15), ...
    linspace(min(v(:,2)), max(v(:,2)), 15), ...
    linspace(min(v(:,3)), max(v(:,3)), 15));
b = underPlanef(X, Y, Z);
s(b) = 10; % circles of size 10 for underwater points
s(~b) = NaN; % do not plot above water points
scatter3(X(:), Y(:), Z(:), s(:), 'b');
axis equal
xlabel('x');
ylabel('y');
zlabel('z');

% find which of the wedge's vertices are under the plane
underPlane = underPlanef(v(:,1), v(:,2), v(:,3));
pointsUnder = v(underPlane, :);
% numUnder = sum(underPlane);

inds = find(underPlane); % indices of points under the plane
adjs = adjacencies(underPlane, :); % indices of points adjacent to pointsUnder
edgesAll = [repmat(inds, 3, 1) adjs(:)]; % adjacent edge pairs [underwater all]
edgesInds = any(bsxfun(@eq, find(~underPlane)', edgesAll(:,2)), 2);
edges = unique(sort(edgesAll(edgesInds, :), 2), 'rows');

P0 = v(edges(:,1), :);
P1 = v(edges(:,2), :);
[intPoints, check] = planeLineIntersection(n, p, P0, P1);
% plotLines(P0, intPoints, 'ro-', 3);
assert(all(check == 1), 'case 1 borken');

pCH = [pointsUnder; intPoints]; % convex hull points
plot3(pCH(:,1), pCH(:,2), pCH(:,3), 'ro', 'markersize', 10, 'markerfacecolor', 'r');
[triCH, volume] = convhull(pCH(:,1), pCH(:,2), pCH(:,3)); % convex hull indices
trimesh(triCH, pCH(:,1), pCH(:,2), pCH(:,3), 'edgecolor', 'none', ...
    'facecolor', 'r', 'facealpha', 0.3);
end

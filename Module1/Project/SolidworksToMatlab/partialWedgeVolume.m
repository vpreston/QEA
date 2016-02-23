function [vol, C, wA, wP] = partialWedgeVolume(P, H, tVol, tC, planef, pN, pP, opts)
% Calculates the volume under a plane and inside a wedge.
%
% P is the 3x2 row-wise list of 3 xy points that define the vertices of the
% base triangle of the wedge which lies in the xy plane.  H is the 3x1
% row-wise list of z values of the three vertices of the wedge which are
% not in the xy plane, which must all have the same sign.  planef is a
% boolean function which determines whether a point is under the plane.  nP
% is the normal vector of the plane.  pP is a point in the plane.

if nargin < 8
    plot = false;
    main = true;
else
    plot = opts(1);
    main = opts(2);
end

plotWedge = false;
plotWater = false;
plotIntersect = plot;
plotOverlap = false;
plotCOM = false;
plotCOB = false;
plotLbl = false;
if main
    plotWedge = true;
    plotWater = true;
    plotIntersect = true;
    plotOverlap = true;
    plotCOM = true;
    plotCOB = true;
    plotLbl = true;
    hold on;
    axis equal;
    xlabel('x');
    ylabel('y');
    zlabel('z');
end

%% initialize values which are seldom changed
wP = zeros(0,3);

%% assemble all wedge informations
% build full points list from base triangle and height information
v = [P zeros(3,1); P H];
% define connectivity and adjacency lists of wedge vertices
f = [1 2 3 NaN; 4 5 6 NaN; 1 2 5 4; 2 3 6 5; 1 3 6 4];
a = [2 3 4; 1 3 5; 1 2 6; 1 5 6; 2 4 6; 3 4 5];

%% plot wedge edges and underwater region
if plotWedge
    patch('faces', f, 'vertices', v, 'edgecolor', 'k', 'linewidth', 2, ...
        'facecolor', 'none');
    view(3);
end
if plotWater
    [X, Y, Z] = meshgrid(linspace(min(v(:,1)), max(v(:,1)), 6), ...
        linspace(min(v(:,2)), max(v(:,2)), 6), ...
        linspace(min(v(:,3)), max(v(:,3)), 15));
    b = planef(X, Y, Z);
    s(b) = 10; % circles of size 10 for underwater points
    s(~b) = NaN; % do not plot above water points
    scatter3(X(:), Y(:), Z(:), s(:), 'b');
end
if plotLbl
    strs = num2cell(num2str((1:6)'),2);
    text(v(:,1), v(:,2), v(:,3), strs, 'fontsize', 14, 'color', 'm');
end
if plotCOM; plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2); end

%% check for 0-height vertices on top of wedge
% ik = [H ~= 0; true(3,1)]; % index vector of vertices to be kept
% ir = [H == 0; false(3,1)]; % index vector of vertices to be removed
% id = [false(3,1); H == 0]; % index vector of replacements for ir
% % get unique vertices and their v indices
% % [vq, iv] = unique(v, 'rows', 'stable');
% % get v indices of unique points in the base of the wedge
% ivq = (1:6)' + 3*ir;
% % replace references to removed vertices with their replacements
% a = ivq(a);
% % add references from removed vertices to their replacements
% a(id,4:6) = a(ir,:);
% % replace nonsensical values with NaN, and remove all NaN columns
% a(a == 0) = NaN; % remove zeroes
% a(bsxfun(@eq, a, (1:6)')) = NaN; % remove row index from values in row
% a = sort(a, 2); % sort within rows
% a(a == circshift(a, 1, 2)) = NaN; % remove duplicates
% % remove all NaN columns
% a(:, all(isnan(a), 1)) = [];

%% find which of the wedge's vertices are under the plane
underPlane = planef(v(:,1), v(:,2), v(:,3));
pointsUnder = v(underPlane, :);
numUnder = sum(underPlane);
% prune simple cases
if numUnder == 0 % wedge is entirely above plane
    vol = 0;
    wA = 0;
    C = tC;
    return
end
if numUnder == 6 % wedge is entirely under plane
    vol = tVol;
    wA = triArea(v(4:6,:));
    C = tC;
    return
end

%% find index pairs of vertices describing edges intersecting the plane
inds = find(underPlane); % indices of points under the plane
adjs = a(underPlane, :); % indices of points adjacent to pointsUnder
edgesAll = [repmat(inds, 3, 1) adjs(:)]; % adjacent edge pairs [under all]
edgesInds = any(bsxfun(@eq, find(~underPlane)', edgesAll(:,2)), 2);
% edges = unique(sort(edgesAll(edgesInds, :), 2), 'rows');
edges = sort(edgesAll(edgesInds, :), 2);

%% find edge-plane intersections to fully define region of wedge under plane
P0 = v(edges(:,1), :);
P1 = v(edges(:,2), :);
[intPoints, check] = planeLineIntersection(pN, pP, P0, P1);
% plotLines(P0, intPoints, 'ro-', 3); % plot lines and intersection points
assert(all(check == 1), 'intersections borken');
pCH = [pointsUnder; intPoints]; % convex hull points

%% find surface area of top face of wedge that's under the plane (wetted)
indsTop = inds(inds > 3); % wetted vertices of top face of wedge
if any(length(indsTop) == [1 2]) % plane passes through top face of wedge
    edgesTop = all(edges > 3, 2); % edges on top of wedge intersecting the plane
    wP = intPoints(edgesTop,:);
    if plotIntersect; plotLines(wP(1,:), wP(2,:), 'b-', 3); end
    numTop = sum(edgesTop)+length(indsTop); % number of vertices defining wetted area
    if numTop == 3
        wA = triArea([v(indsTop, :); wP]);
    else
        assert(numTop == 4, 'wetted area broke');
        wA = triArea(v(4:6,:)) - triArea([v(15-sum(indsTop), :); wP]);
    end
elseif length(indsTop) == 3 % top face of wedge is entirely below water
    wA = triArea(v(4:6,:));
elseif isempty(indsTop) % top face of wedge is entirely above water
    wA = 0;
end

%% plot region of wedge under the plane
% get convex hull indices and volume of wedge under plane
if plotOverlap; [triCH, ~] = convhull(pCH(:,1), pCH(:,2), pCH(:,3)); end
% check that all points in pCH are used in the convex hull (also triggers
% if there's a duplicate point... :/ )
% assert(length(unique(triCH(:))) == size(pCH, 1), 'pCH isn''t convex');
% plot convex hull indicating volume under water and within wedge
% plot3(pCH(:,1), pCH(:,2), pCH(:,3), 'ro', 'markersize', 7, 'markerfacecolor', 'r');
if plotOverlap; trimesh(triCH, pCH(:,1), pCH(:,2), pCH(:,3), ...
        'edgecolor', 'none', 'facecolor', 'r', 'facealpha', 0.2); end

%% find centroid by adding weighted centroid of all simplices
[C, vol] = getCentroid(pCH);
if plotCOB; plot3(C(1), C(2), C(3), 'r*', 'markersize', 15, 'linewidth', 2); end
end

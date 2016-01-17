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
adjacencies = [2 3 4; 1 3 5; 1 2 6; 1 5 6; 2 4 6; 3 4 6];

% find which of the wedge's vertices are under the plane
underPlane = underPlanef(v(:,1), v(:,2), v(:,3));
numUnder = sum(underPlane);

patch('faces', f, 'vertices', v, 'facecolor', 'blue', 'facealpha', 0.3);
view(3);
hold on;
[X, Y, Z] = meshgrid(linspace(min(v(:,1)), max(v(:,1)), 20), ...
    linspace(min(v(:,2)), max(v(:,2)), 20), ...
    linspace(min(v(:,3)), max(v(:,3)), 20));
b = underPlanef(X, Y, Z);
s(b) = 10; % circles of size 10 for underwater points
s(~b) = NaN; % do not plot above water points
scatter3(X(:), Y(:), Z(:), s(:), 'b');
axis equal
xlabel('x');
ylabel('y');
zlabel('z');

% list of points under the plane, offset
% switch numUnder
%     case {1, 2, 3}
%         pointsUnder = v(underPlane, :);
%     case {4, 5, 6}
%         pointsUnder = v(~underPlane, :);
%         volume = -wedgeVolume(points, heights); % total wedge volume
% end
% 
% switch numUnder
%     case {1, 5}
%         P0 = repmat(pointsUnder, 3, 1);
%         P1 = v(adjacencies(underPlane, :)', :);
%         [intPoints, check] = planeLineIntersection(n, p, P0, P1);
%         plotLines(P0, intPoints, 'ro-', 3);
%         assert(all(check == 1), 'case 1 borken');
%         volume = abs(volume + tetraVolume([pointsUnder; intPoints]));
%     case {2, 4}
%         
%     case 3
%         
%     case 6
%         volume = abs(volume);
% end
% 
% % if we actually need the inverse of the calculated value
% if any(numUnder == [4 5])
%     volume = totVolume - volume;
% end
end
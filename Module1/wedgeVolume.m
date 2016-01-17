function [volume, area] = wedgeVolume(points, heights)
% Find the volume of a vertical (+z direction) wedge from the xy locations
% of its base triangle's vertices and heights of the projections of these
% vertices in the +z direction.  Each row of points and heights corresponds
% to a vertex of the base triangle, in counterclockwise order. If heights
% == 1, then volume = area.
% Example: [v, a] = wedgeVolume([1 0; 0 1; 0 0], [5; 3; 4])

height = mean(heights); % height of the barycenter (centroid)
area = 1/2*abs(det([points ones(3,1)])); % area of base triangle
volume = height*area;

% points = num2cell([points zeros(3,1); points heights], 1);
% [~, volume] = convhull(points{:});

% f = [1 2 3 NaN; 4 5 6 NaN; 1 2 5 4; 2 3 6 5; 1 3 6 4];
% v = [points zeros(3,1); points heights];
% patch('faces', f, 'vertices', v, 'facecolor', 'blue', 'facealpha', 0.3);
% view(3);
% axis equal
% xlabel('x');
% ylabel('y');
% zlabel('z');
end

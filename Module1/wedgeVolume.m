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
end

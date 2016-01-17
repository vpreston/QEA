function volume = tetraVolume(points)
% Find the volume of a tetrahedron wedge from the xyz locations of its
% vertices.  Each row of points corresponds to a vertex of the tetrahedron.

volume = abs(det(diff(points, 1, 1)))/6;
end

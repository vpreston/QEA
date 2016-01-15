function [vnewer, fnewer] = patchslim(v, f)
% PATCHSLIM removes duplicate or unused vertices in surface meshes.
%
% This function finds and removes duplicate or unused vertices.
%
% USAGE: [v, f] = patchslim(v, f)
%
% Where v is the vertex list and f is the face list specifying vertex
% connectivity.
%
% v contains the vertices for all triangles [3*n x 3].
% f contains the vertex lists defining each triangle face [n x 3].
%
% This will reduce the size of typical v matrix by about a factor of 6 by
% removing duplicate vertices.  Removal of unused vertices further reduces
% the size of the v matrix.
%
% Adapted from:
% Francis Esmonde-White, May 2010
% http://www.esmonde-white.com/home/diversions/matlab-program-for-loading-stl-files

if ~exist('v','var')
    error('The vertex list (v) must be specified.');
end
if ~exist('f','var')
    error('The vertex connectivity of the triangle faces (f) must be specified.');
end

[vnew, ~, indexn] = unique(v, 'rows');
% unused output is a list of v indices that maps v to vnew.
% indexn is a list of vnew indices that maps vnew rows back to v rows.  It
% tells you where to find each row in v when looking for it in vnew.
% The following line makes a new face list which references the new indices
% of the rows of each v.
fnew = indexn(f);

[fused, ~, indexn] = unique(fnew);
% fused is a list of vnew rows which are used as vertices.
vnewer = vnew(fused, :);
frangenew = 1:length(fused);
fnewer = reshape(frangenew(indexn), size(fnew));
end

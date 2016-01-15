function [TRl, TRu, vl, vu, fl, fu, nl, nu] = parseSTL(filename)
% Load file, parse into upper and lower data sets, remove duplicate
% vertices, and unpack point cloud data.
% http://www.mathworks.com/matlabcentral/fileexchange/29906-binary-stl-file-reader
% http://www.mathworks.com/matlabcentral/fileexchange/29986-patch-slim--patchslim-m-
[v, f, n] = stlread(filename);
if any(n(:,3) == 0) % any vertical faces?
    error('STL contains a vertical face. Cannot convert surface to functions.');
end
[v, f] = patchslim(v, f);

lower = n(:,3) < 0;
[vl, fl] = patchslim(v, f(lower, :));
nl = n(lower, :);
[vu, fu] = patchslim(v, f(~lower, :));
nu = n(~lower, :);

% dxl = vl(:,1);
% dyl = vl(:,2);
% dxu = vu(:,1);
% dyu = vu(:,2);

% create 2D triangulation objects
TRl = triangulation(fl, vl(:,1:2));
TRu = triangulation(fu, vu(:,1:2));
end
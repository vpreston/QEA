function tri2stl(filename, fl, vl, fu, vu)
% Combine lower and upper triangulation data and save to STL file.
% http://www.mathworks.com/matlabcentral/fileexchange/20922-stlwrite-filename--varargin-
% http://www.mathworks.com/matlabcentral/fileexchange/29986-patch-slim--patchslim-m-

f = [fl; fu];
v = [vl; vu];
[f, v] = patchslim(f, v); % remove duplicate vertices

stlwrite(filename, f, v);
end
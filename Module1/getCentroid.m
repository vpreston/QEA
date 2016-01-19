function [C, totalVolume] = getCentroid(P)
% not including the following line throws lots of warnings, but it makes
% the function 30 percent faster
% P = unique(P, 'rows', 'stable');
% if size(Pold,1) ~= size(P,1)
%     5;
% end
% if size(P, 1) < 4 % not a 3D solid
%    C = mean(P, 1);
%    totalVolume = 0;
%    return
% end
DT = delaunay(P); % 3D triangulation
C = [0 0 0];
simplexVolume = zeros(size(DT, 1), 1);
for i=1:size(DT, 1)
    simplexPoints = P(DT(i,:),:);
    [~, simplexVolume(i)] = convhull(simplexPoints);
    C = C + simplexVolume(i) * mean(simplexPoints);
end
totalVolume = sum(simplexVolume);
C = C/totalVolume;
end
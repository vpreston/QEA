function [C, totalVolume] = getCentroid(V)
DT = delaunay(V); % 3D triangulation
C = [0 0 0];
simplexVolume = zeros(size(DT, 1), 1);
for i=1:size(DT, 1)
    simplexPoints = V(DT(i,:),:);
    [~, simplexVolume(i)] = convhull(simplexPoints);
    C = C + simplexVolume(i) * mean(simplexPoints);
end
totalVolume = sum(simplexVolume);
C = C/totalVolume;
end
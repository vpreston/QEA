function plotLines(points1, points2, style, linewidth, markersize)
% plot each row of points2 versus each row of points1
psz = size(points1);
if nargin == 1
    points2 = points1;
    points1 = zeros(psz);
end
if nargin <= 2
    style = '-'; % line default
end
if nargin <= 3
    linewidth = 1; % default
end
if nargin <= 4
    markersize = 6; % default
end

for i=1:psz(1)
    p = num2cell([points1(i,:); points2(i,:)], 1);
    if psz(2) == 2
        plot(p{:}, style, 'linewidth', linewidth, 'markersize', markersize);
    else
        plot3(p{:}, style, 'linewidth', linewidth, 'markersize', markersize);
    end
end
end

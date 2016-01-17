function plotLines(points1, points2, style, linewidth)
if nargin == 2
    style = '-';
    linewidth = 1;
elseif nargin == 3
    linewidth = 1;
end
for i=1:size(points1, 1)
    p = num2cell([points1(i,:); points2(i,:)], 1);
    if size(points1, 2) == 2
        plot(p{:}, style, 'linewidth', linewidth);
    else
        plot3(p{:}, style, 'linewidth', linewidth);
    end
end
end

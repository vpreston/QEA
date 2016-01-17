function coeffs = plotWaterline(tilt, heel, depth)
[underwaterf, ~, point, coeffs] = getWaterlinef(tilt, heel, depth);

[X, Y, Z] = meshgrid(linspace(-10, 10, 20));
v = underwaterf(X, Y, Z);
s(v) = 10; % circles of size 10 for underwater points
s(~v) = NaN; % do not plot above water points

scatter3(X(:), Y(:), Z(:), s(:), 'b');
hold on
p = num2cell([0 0 0; point], 1);
plot3(p{:}, 'ro-');

% format plot
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
end

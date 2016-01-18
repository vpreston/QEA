function [planef, pN, pP, coeffs] = plotWaterline(tilt, heel, depth, v)

[planef, pN, pP, coeffs] = getWaterline(tilt, heel, depth);

[X, Y, Z] = meshgrid(linspace(min(v(:,1)), max(v(:,1)), 10), ...
    linspace(min(v(:,2)), max(v(:,2)), 10), ...
    linspace(min(v(:,3)), max(v(:,3)), 15));

% [X, Y, Z] = meshgrid(linspace(-0.2, 0.2, 20));
v = planef(X, Y, Z);
s(v) = 10; % circles of size 10 for underwater points
s(~v) = NaN; % do not plot above water points

scatter3(X(:), Y(:), Z(:), s(:), 'b');
hold on
p = num2cell([0 0 0; pP], 1);
plot3(p{:}, 'ro-');

% format plot
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
end

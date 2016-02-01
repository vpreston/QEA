
R1 = 31;
C1 = 1;
R2 = 9486;
C2 = 3;
M = csvread('Ellipsoid23.sbp', R1, C1, [R1 C1 R2 C2]);
% M = csvread('Ellipsoid23Fudged.sbp', 2, 1);
x = M(:,1);
y = M(:,2);
z = M(:,3);
plot3(x, y, z);
axis equal
axis tight

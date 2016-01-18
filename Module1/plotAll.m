figure;
hold on;
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');
view(3);

rho = 32; % boat material density; from datasheet [kg/m^3]
tVol = 0; % total volume [m^3]
dVol = 0; % displaced volume [m^3]
tC = 0; % total volume centroid (center of mass) [m]
dC = 0; % displaced volume centroid [m]
[TRl, TRu, fl, fu, vl, vu, nl, nu] = stl2tri('Hull.STL');

plotSTL();

% [planef, pN, pP, coeffs] = plotWaterline(0, 30, 0.01, [vl; vu]);
[planef, pN, pP, coeffs] = getWaterline(0, 0, 0.01); % tilt, heel, deptj

for i = 1:size(fl, 1) % lower
    P = vl(fl(i,:)',1:2);
    H = vl(fl(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
%     drawnow
end

for i = 1:size(fu, 1) % upper
    P = vu(fu(i,:)',1:2);
    H = vu(fu(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
%     drawnow
end
dC = dC/dVol;
tC = tC/tVol;
tM = rho*tVol; % total mass [kg]

plot3(dC(1), dC(2), dC(3), 'r*', 'markersize', 15, 'linewidth', 2);
plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2);

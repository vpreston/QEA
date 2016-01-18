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
[planef, pN, pP, coeffs] = getWaterline(0, 0, 0.01); % tilt, heel, depth

% density = 32; %from datsheet, kg/m^3
% lower_vol = 0;
% lower_volw = 0;
% upper_vol = 0;
% upper_volw = 0;
% mass_lc = 0;
% mass_lcw = 0;
% mass_tc = 0;
% mass_tcw = 0;
% lower_centroid = 0;
% lower_centroidw = 0;
% upper_centroid = 0;
% upper_centroidw = 0;

for i = 1:size(fl, 1) % lower
    P = vl(fl(i,:)',1:2);
    H = vl(fl(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
    %     drawnow
%     [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
%     [mass_lc,lower_vol,lower_centroid] = getCOM(density,tVol,tC,lower_vol,lower_centroid,mass_lc);
%     [mass_lcw,lower_volw,lower_centroidw] = getCOM(density,vol,C,lower_volw,lower_centroidw,mass_lcw);
end
% plot3(lower_centroid(1),lower_centroid(2),lower_centroid(3),'go')
% plot3(lower_centroidw(1),lower_centroidw(2),lower_centroidw(3),'g*')

for i = 1:size(fu, 1) % upper
    P = vu(fu(i,:)',1:2);
    H = vu(fu(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
%     drawnow
%     [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
%     [mass_tc,upper_vol,upper_centroid] = getCOM(density,tVol,tC,upper_vol,upper_centroid,mass_tc);
%     [mass_tcw,upper_volw,upper_centroidw] = getCOM(density,vol,C,upper_volw,upper_centroidw,mass_tcw);
end
% plot3(upper_centroid(1),upper_centroid(2),upper_centroid(3),'bo')
% plot3(upper_centroidw(1),upper_centroidw(2),upper_centroidw(3),'b*')

dC = dC/dVol;
tC = tC/tVol;
tM = rho*tVol; % total mass [kg]

plot3(dC(1), dC(2), dC(3), 'r*', 'markersize', 15, 'linewidth', 2);
plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2);


% mass = mass_lc+mass_tc;
% com = 1/(mass_tc + mass_lc).*(mass_tc.*upper_centroid + mass_lc.*lower_centroid);
% cob = 1/(mass_tcw + mass_lcw).*(mass_tcw.*upper_centroidw + mass_lcw.*lower_centroidw);
% 
% plot3(com(1),com(2),com(3),'ro')
% plot3(cob(1),cob(2),cob(3),'r*')

%cob should just be center of what is under the water...we'll see

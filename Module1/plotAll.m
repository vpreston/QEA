figure;

density = 32; %from datsheet, kg/m^3
lower_vol = 0;
upper_vol = 0;
sum_lc = 0;
sum_tc = 0;
mass_lc = 0;
mass_tc = 0;
lower_centroid = 0;
upper_centroid = 0;
[TRl, TRu, fl, fu, vl, vu, nl, nu] = stl2tri('Hull.STL');

plotSTL();

% [planef, pN, pP, coeffs] = plotWaterline(0, 30, 0.01, [vl; vu]);
[planef, pN, pP, coeffs] = getWaterline(0, 0, 0.01); %(tilt, heel, depth)


for i = 1:size(fl, 1) %lower boat
    P = vl(fl(i,:)',1:2);
    H = vl(fl(i,:)',3);
    [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
    lower_vol = lower_vol + tVol;
    lower_centroid = 1/(mass_lc + tVol*density).*(mass_lc.*lower_centroid + tVol*density.*tC);
    mass_lc = mass_lc + tVol*density;
end
plot3(lower_centroid(1),lower_centroid(2),lower_centroid(3),'go')

for i = 1:size(fu, 1) %upper boat
    P = vu(fu(i,:)',1:2);
    H = vu(fu(i,:)',3);
    [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
    upper_vol = upper_vol + tVol;
    upper_centroid = 1/(mass_tc + tVol*density).*(mass_tc.*upper_centroid + tVol*density.*tC);
    mass_tc = mass_tc + tVol*density;
end
plot3(upper_centroid(1),upper_centroid(2),upper_centroid(3),'bo')


mass = density * (upper_vol + lower_vol);
mass_upper = density * upper_vol;
mass_lower = density * lower_vol;
com = 1/(mass_upper + mass_lower).*(mass_upper.*upper_centroid + mass_lower.*lower_centroid);
plot3(com(1),com(2),com(3),'r*')

%cob should just be center of what is under the water...we'll see

axis equal;
xlabel('x');
ylabel('y');
zlabel('z');

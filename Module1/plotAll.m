figure;

[TRl, TRu, fl, fu, vl, vu, nl, nu] = stl2tri('Hull.STL');

plotSTL();

% [planef, pN, pP, coeffs] = plotWaterline(0, 30, 0.01, [vl; vu]);
[planef, pN, pP, coeffs] = getWaterline(0, 120, 0.01);


for i = 1:size(fl, 1)
    P = vl(fl(i,:)',1:2);
    H = vl(fl(i,:)',3);
    [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
end
for i = 1:size(fu, 1)
    P = vu(fu(i,:)',1:2);
    H = vu(fu(i,:)',3);
    [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
end

axis equal;
xlabel('x');
ylabel('y');
zlabel('z');

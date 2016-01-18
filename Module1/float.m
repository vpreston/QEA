function difference = float(fl, fu, vl, vu, tilt, heel, depth)
%float this function takes in an orientation of a boat and calculates the
%difference between the submerged volume and the necessary volume for
%equilibrium
%   to be used on fzero in order to find the waterline
rho = 32; % boat material density; from datasheet [kg/m^3]
tVol = 0; % total volume [m^3]
dVol = 0; % displaced volume [m^3]
tC = 0; % total volume centroid (center of mass) [m]
dC = 0; % displaced volume centroid [m]

[planef, pN, pP, coeffs] = getWaterline(tilt, heel, depth); % tilt, heel, depth

for i = 1:size(fl, 1) % lower
    P = vl(fl(i,:)',1:2);
    H = vl(fl(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
end

for i = 1:size(fu, 1) % upper
    P = vu(fu(i,:)',1:2);
    H = vu(fu(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
end

dC = dC/dVol;
tC = tC/tVol;
tM = rho*tVol + 0.35*2; % total mass of boat [kg]
needed_vol = tM/1000;

difference = dVol - needed_vol;

end


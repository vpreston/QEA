function [netForce, dC, tC, dM, tM, dF, tF] = ... 
    float(fl, fu, vl, vu, tilt, heel, depth, plot)
%float this function takes in an orientation of a boat and calculates the
%difference between the submerged volume and the necessary volume for
%equilibrium
%   to be used on fzero in order to find the waterline

g = 9.8; % acceleration due to gravity [m/s^2]
rhoW = 998; % water density [kg/m^3]
rhoF = 32; % boat material density; from datasheet [kg/m^3]
rhoA = 2700; % aluminum (mast) density [kg/m^3]

cargoC = [0 0 convlength(-0.4, 'in', 'm')]; % centroid of cargo [m]
cargoM = 0.720 - rhoF*10*2.8^2*convlength(1, 'in', 'm')^3; % mass of cargo [kg]

mastC = [0 0 0.25-convlength(3, 'in', 'm')]; % centroid of cargo [m]
mastM = rhoA*0.5*pi*(3/8/2)^2*convlength(1, 'in', 'm')^2; % mass of cargo [kg]

ballastC = [0 0 -0.06];
ballastM = 0.1;

tVol = 0; % total volume [m^3]
dVol = 0; % displaced volume [m^3]
tC = 0; % total volume centroid (center of mass) [m]
dC = 0; % displaced volume centroid [m]

[planef, pN, pP, ~] = getWaterline(tilt, heel, depth);

for i = 1:size(fl, 1) % lower
    P = vl(fl(i,:)',1:2);
    H = vl(fl(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP, plot);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
end

for i = 1:size(fu, 1) % upper
    P = vu(fu(i,:)',1:2);
    H = vu(fu(i,:)',3);
    [vol, c, tvol, tc, wa, wp] = partialWedgeVolume(P, H, planef, pN, pP, plot);
    dVol = dVol + vol;
    dC = dC + vol*c;
    tVol = tVol + tvol;
    tC = tC + tvol*tc;
end

% calculate centroid locations
dC = dC/dVol;
tC = tC/tVol;

% calculate masses
dM = rhoW*dVol; % displacement [kg]
tM = rhoF*tVol; % total mass [kg]

% add cargo and mast to total centroid and mass
tC = (tC*tM + mastC*mastM + cargoC*cargoM + ballastC*ballastM)/(tM + mastM + cargoM + ballastM);
tM = tM + mastM + cargoM + ballastM;

% calculate forces
dF = dM*g; % buoyant force [N]
tF = tM*g; % gravitational force [N]

netForce = dF-tF;
depth
netForce
end


function plotAll()
% figure;
% hold on;
% axis equal;
% xlabel('x');
% ylabel('y');
% zlabel('z');
% view(3);

g = 9.8; % acceleration due to gravity [m/s^2]
rhoW = 998; % water density [kg/m^3]
rhoF = 32; % boat material density; from datasheet [kg/m^3]
rhoA = 2700; % aluminum (mast) density [kg/m^3]

cargoC = [0 0 convlength(-0.4, 'in', 'm')]; % centroid of cargo [m]
cargoM = 0.720 - rhoF*10*2.8^2*convlength(1, 'in', 'm')^3; % mass of cargo [kg]

mastC = [0 0 0.25-convlength(3, 'in', 'm')]; % centroid of cargo [m]
mastM = rhoA*0.5*pi*(3/8/2)^2*convlength(1, 'in', 'm')^2; % mass of cargo [kg]

[TRl, TRu, fl, fu, vl, vu, nl, nu] = stl2tri('Hull.STL');
% plotSTL();

fzero(@getNetForce, [-0.1 -0.01])
    function netForce = getNetForce(depth)
        tVol = 0; % total volume [m^3]
        dVol = 0; % displaced volume [m^3]
        tC = 0; % total volume centroid (center of mass) [m]
        dC = 0; % displaced volume centroid [m]

        % [planef, pN, pP, coeffs] = plotWaterline(0, 30, 0.01, [vl; vu]);
%         [planef, pN, pP, coeffs] = getWaterline(0, 1, -0.05); % tilt, heel, depth
        [planef, pN, pP, coeffs] = getWaterline(0, 1, depth); % tilt, heel, depth
        
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
        
        tic
        for i = 1:size(fl, 1) % lower
            P = vl(fl(i,:)',1:2);
            H = vl(fl(i,:)',3);
            [vol, c, tvol, tc, ~, ~] = partialWedgeVolume(P, H, planef, pN, pP);
            dVol = dVol + vol;
            dC = dC + vol*c;
            tVol = tVol + tvol;
            tC = tC + tvol*tc;
            %         drawnow
            %     [vol, C, tVol, tC, wA, wP] = partialWedgeVolume(P, H, planef, pN, pP);
            %     [mass_lc,lower_vol,lower_centroid] = getCOM(density,tVol,tC,lower_vol,lower_centroid,mass_lc);
            %     [mass_lcw,lower_volw,lower_centroidw] = getCOM(density,vol,C,lower_volw,lower_centroidw,mass_lcw);
        end
        % plot3(lower_centroid(1),lower_centroid(2),lower_centroid(3),'go')
        % plot3(lower_centroidw(1),lower_centroidw(2),lower_centroidw(3),'g*')
        
        for i = 1:size(fu, 1) % upper
            P = vu(fu(i,:)',1:2);
            H = vu(fu(i,:)',3);
            [vol, c, tvol, tc, ~, ~] = partialWedgeVolume(P, H, planef, pN, pP);
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
        toc
        
        dC = dC/dVol;
        tC = tC/tVol;
        dM = rhoW*dVol; % displacement [kg]
        tM = rhoF*tVol; % total mass [kg]
        
        tC = (tC*tM + mastC*mastM + cargoC*cargoM)/(tM + mastM + cargoM);
        tM = tM + mastM + cargoM;
        
        dF = dM*g; % buoyant force [N]
        tF = tM*g; % gravitational force [N]
        
        netForce = dF-tF;
        depth
        netForce
    end

moment = cross(dC-tC, [0 0 -dF]);

% plot3(dC(1), dC(2), dC(3), 'r*', 'markersize', 15, 'linewidth', 2);
% plot3(tC(1), tC(2), tC(3), 'k*', 'markersize', 15, 'linewidth', 2);


% mass = mass_lc+mass_tc;
% com = 1/(mass_tc + mass_lc).*(mass_tc.*upper_centroid + mass_lc.*lower_centroid);
% cob = 1/(mass_tcw + mass_lcw).*(mass_tcw.*upper_centroidw + mass_lcw.*lower_centroidw);
%
% plot3(com(1),com(2),com(3),'ro')
% plot3(cob(1),cob(2),cob(3),'r*')

%cob should just be center of what is under the water...we'll see
end

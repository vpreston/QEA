%QEA Module 1 - Boat Calculations
%Victoria Preston - January 14, 2016

function module1_boat()

    function d = displacement(upper, lower, lims, heel, tilt, depth)
        % Calculates the displacement in volume of the boat for a given
        % heel angle (rotation about +x; roll), a given location of the
        % waterline, and a given trim angle (rotation about -y; pitch). Use
        % this function to create plots of displacement versus depth for
        % different waterline locations and for different heel angles.
        % The waterline is defined in the boat's coordinate system and is
        % of the form a*x+b*y+c*z+d=0. These constants were found using the
        % following constraints on the general form:
        % 
        c = 1/sqrt(tand(tilt)^2+tand(heel)^2+1);
        a = -c*tand(tilt);
        b = -c*tand(heel);
        water_fun = @(x,y,z) (-a.*x - b.*y - c.*z).*((-a.*x - b.*y - c.*z) < depth); %parameterized for z
        boat_fun_upp = upper;
        boat_fun_low = lower;
        
        d = integral3(water_fun,lims{:});
        
        %subtract the water function and the boat functions
        %integrate over the intersection area
        
        
        %visualizing the stuff happening
        xw = -0.4:0.05:0.4;
        yw = -0.4:0.05:0.4;
        [XW,YW] = meshgrid(xw,yw);
        ZW = tand(tilt).*XW + tand(heel).*YW - depth;
        figure;
        hold on;
        surf(XW,YW,ZW);
        
        [~, ~, vl, vu, fl, fu] = parseSTL('Hull.STL');
        dxl = vl(:,1);
        dyl = vl(:,2);
        qx = linspace(min(dxl), max(dxl), 100);
        qy = linspace(min(dyl), max(dyl), 100);
        [Qx, Qy] = meshgrid(qx, qy);
        qzl = lower(Qx, Qy);
        qzu = upper(Qx, Qy);
        surf(qx, qy, qzl);
        surf(qx, qy, qzu);

        xlabel('x');
        ylabel('y');
        zlabel('z');
        
        
        %volume under the curve will be at the bounds of the intersection,
        %and then the difference between the uppermost bound and the
        %lowerost bounds. Thinking about it this way should help prevent
        %the tipping issue. Having heel angle limits related to the inner
        %geometry may help out with the sinking scenario
  
    end

    function wettedsurfacearea(upper,lower,heel,tilt,depth)
        %calculates the total wetted surface area of the boat for a given
        %heel angle, a given location of the waterline, and trim angle
        %(optional)
        
        water_fun = @(x,y) tand(tilt).*x + tand(heel).*y - depth; %parameterized for z
        boat_fun_upp = upper;
        boat_fun_low = lower;
        
        %should be the distance formula over the area, relatively
        %straightforward. If parmetric, some fun math to do. Should look
        %at the numerical methods shapes thing to determine how effective
        %it is at setting up for this problem.
    end

    function waterline(mass,heel,trim)
        %claculate where the waterline will fall given the mass, and heel
        %angle (trim optional). Will use fzero or some other root finding
        %function to do this. Create plot that shows waterline location as
        %a function of boat mass. Also create visualizations of the boat's
        %waterline for different heel angles.
        
        %domain big concern. flagging for definitely figuring out before
        %school starts
    end

    function COM(upper,lower,heel,trim)
        %calculate the center of mass for a given design. Create
        %visulization for normal, and heel/trim angle
        %can check this against solidworks
        
        %1/mass * sum of each point * their mass * their location
        %continuous function is 1/M * integration of density*position over
        %the volume of the thing
        
        density = 32; %kg/m^3
        mass = 1; %kg, get this from Solidworks or real world
        
        %either iterate through each point and create a collective sum, or
        %integrate over the two functions. unclear which is better option
        %at the moment.
        
    end

    function COB(boat_design,heel,trim)
        %clauclation the center of buoyancy for a given design. Create
        %visualization for normal and provided heel/trim angles
        
        %some simple checks based on real world data to determine accuracy
        
        %find the center of area on the xy plane first by finding the
        %moments of area for y and x values. Diving the moments by total
        %area will give the buoyancy point.
        
        %also consider if the center of the underwaer part of the hull, so
        %if we pull in where the waterline is, then the volume under that
        %water line, and then do the COG thing but only for underwater,
        %that might also work
        
        
    end

    function stabilitycurve(boat_design, heel)
        %plots the righting moment as a function of heel angle for the
        %design. Make sure consistent with other centroid visualizations
        
        %need to check in with Mark/Chris on this one
        
        %righting moment is the displacement of vessel times the righting
        %arm (which is the horizontal distance between the COG and the line
        %of the COB
    end

    function drag(boat_design)
        %calculate the coefficient of drag on the boat as a metric for
        %potential "speed"
    end
    
    [upp,low, lims] = localHull();
    %plotSTL();
    displacement(upp, low, lims, 0, 0, 0)
    
end


%QEA Module 1 - Boat Calculations
%Victoria Preston - January 14, 2016

function module1_boat()

    function z = globalHull(x, y, l, b, d)
        % Lower (-z) half of ellipsoid defined by (x/l)^2+(y/b)^2+(z/d)^2=1.
        % l is half of the length of the boat.
        % b is half of the width (beam) of the boat.
        % d is the height of the boat hull.
        % Operates elementwise on inputs. Sizes of all inputs must be identical or
        % scalar.  x and y must be the same size.
        c = (x./l).^2 + (y./b).^2; % scaled, weighted distance from center of hull
        z = -d.*sqrt(1-c);
        z(c == 1) = 0; % on hull perimeter
        z(c > 1) = NaN; % outside hull perimeter
    end

    function [fzl, fzu, lims] = localHull()
        [TRl, TRu, vl, vu] = parseSTL('Hull.STL');
        dxl = vl(:,1);
        % dxu = vu(:,1);
        dyl = vl(:,2);
        % dyu = vu(:,2);
        dzl = vl(:,3);
        dzu = vu(:,3);

        fzl = @(qx, qy) interptri(TRl, dzl, qx, qy);
        fzu = @(qx, qy) interptri(TRu, dzu, qx, qy);

        % Only available for Delaunay Triangulation
        % CH = TRl.convexHull();

        % Get indices of vertices in convex hull, counterclockwise from
        % most-x-negative point. The convex hull is the same for the lower and
        % upper meshes because their intersection is defined as the maximum extent
        % of the domain. CH(1) = CH(end) because the convex hull is a full loop.
        CH = convhull(dxl, dyl);

        dxCH = dxl(CH);
        dyCH = dyl(CH);

        % Find x domain min and max values, along with indices of those points in
        % the CH list (NOT the original dxl list).
        ixmin = 1;
        xmin = dxCH(ixmin);
        [xmax, ixmax] = max(dxCH);
        ixend = length(CH);

        % Find index vectors of y min and max domains in CH list.
        iymin = ixmin:ixmax;
        iymax = ixmax:ixend;
        ymin = @(x) interp1(dxCH(iymin), dyCH(iymin), x, 'linear');
        ymax = @(x) interp1(dxCH(iymax), dyCH(iymax), x, 'linear');

        % We already know the min and max functions for z (which have domain
        % of xmin to xmax and ymin to ymax)
        zmin = fzl;
        zmax = fzu;

        % Combine limits into cell array ready to be used by integral3.
        lims = {xmin, xmax, ymin, ymax, zmin, zmax};

        % figure;
        % hold on
        % plot(dxCH(iymin), dyCH(iymin), 'r*-');
        % plot(dxCH(iymax), dyCH(iymax), 'b*-');
        % plot(dxl, dyl, 'g.');
        % plot(dxCH(ixmin), dyCH(ixmin), 'ko');
        % plot(dxCH(ixmax), dyCH(ixmax), 'ko');
        % plot(dxCH(ixend), dyCH(ixend), 'ko');
    end

    function plotSTL()
        [~, ~, vl, vu, fl, fu] = parseSTL('Hull.STL');
        dxl = vl(:,1);
        dyl = vl(:,2);

        % Plot raw STL data

        subplot(1,2,1);

        % plot patch
        % patch('Faces', fl, 'Vertices', vl, 'FaceColor', 'none');
        % patch('Faces', fu, 'Vertices', vu, 'FaceColor', 'none');

        % alternate plotting methods
        % trimesh(fu, dxu, dyu, dzu);
        TRl = triangulation(fl, vl);
        trisurf(TRl);
        hold on;
        TRu = triangulation(fu, vu);
        trisurf(TRu);

        % format plot
        axis equal
        xlabel('x');
        ylabel('y');
        zlabel('z');


        % Plot interpolated mesh data

        subplot(1,2,2);
        qx = linspace(min(dxl), max(dxl), 100);
        qy = linspace(min(dyl), max(dyl), 100);
        [Qx, Qy] = meshgrid(qx, qy);

        % scattered interpolation function (compare to griddata)
        % fzl = scatteredInterpolant(dyl, dxl, dzl, 'linear', 'none'); % try 'natural'
        % qzl = fzl({qy,qx});

        % triangular interpolation function (uses interptri)
        [fzl, fzu] = localHull();
        qzl = fzl(Qx, Qy);
        qzu = fzu(Qx, Qy);

        % plot interpolated surface
        surf(qx, qy, qzl);
        hold on
        surf(qx, qy, qzu);

        % format plot
        axis equal;
        xlabel('x');
        ylabel('y');
        zlabel('z');
    end

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


function res = myboat
clf
% define the shape parameter
n = 2;

% Plot the hull
y = linspace(-1,1,100);
z = hull(y,n);
figure(1), plot(y,z,'b'), hold on
axis([-1 1 -1.5 0.5])

% define the angle
for theta = 0:5:45
    
    % compute the waterline
    d = fzero(@(d) bouyancy(n,d,theta), -0.5)
    
    % compute the cob
    [ycob,zcob] = cob(n,d,theta)
    
    % plot the cob
    figure(1), plot(ycob,zcob,'r*')
    
    % plot the waterline
    z = waterline(y,theta,d);
    figure(1), plot(y,z,'k')
    drawnow
    
    water_vec = [cosd(theta),sind(theta)];
    cob_vec = [ycob,zcob];
    com_vec = [0,-0.5];
    arm = (cob_vec-com_vec)*water_vec';
    
    figure(2), plot(theta,arm,'*k'), hold on
    
end

    function res = hull(y,n)
        res = abs(y).^n - 1;
    end

    function res = waterline(y,theta,d)
        res = tand(theta).*y + d;
    end

    function res = unit_int(y,z)
        res = y./y;
    end

    function res = y_int(y,z)
        res = y;
    end

    function res = z_int(y,z)
        res = z;
    end

    function res = boat_area(n)
        ymin = -1;
        ymax = 1;
        zmin = @(y) hull(y,n);
        zmax = 0;
        res = integral2(@unit_int,ymin,ymax,zmin,zmax)
    end

    function res = intersection(y,n,theta,d)
        res = abs(y).^n - 1 - (tand(theta).*y + d);
    end

    function res = sub_area(n,d,theta)
        ymin = fzero(@(y) intersection(y,n,theta,d),-1);
        ymax = fzero(@(y) intersection(y,n,theta,d),+1);
        zmin = @(y) hull(y,n);
        zmax = @(y) waterline(y,theta,d);
        res = integral2(@unit_int,ymin,ymax,zmin,zmax);
    end

    function [ycob,zcob] = cob(n,d,theta)
        ymin = fzero(@(y) intersection(y,n,theta,d),-1);
        ymax = fzero(@(y) intersection(y,n,theta,d),+1);
        zmin = @(y) hull(y,n);
        zmax = @(y) waterline(y,theta,d);
        ycob = integral2(@y_int,ymin,ymax,zmin,zmax)./sub_area(n,d,theta);
        zcob = integral2(@z_int,ymin,ymax,zmin,zmax)./sub_area(n,d,theta);
    end

    function res = bouyancy(n,d,theta)
        res = 0.1 - sub_area(n,d,theta)./boat_area(n);
    end

end










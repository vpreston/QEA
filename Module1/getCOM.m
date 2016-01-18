function [tmass,Vol,COM] = getCOM(density,wVol,wC,bVol,bC,bmass)
%COM calculates the center of mass of a given volume and adds a wedeg to a
%given volume
%   density is the material density property, wVol is the volume of a wedge
%   in m^3, and wC is the 3x1 row-wise location of the centroid of the
%   volume. bVol is the total volume of a shape that has been clculated
%   (for example, most of the boat hull) and bC is the 3x1 row-wise
%   location of the centroid of that volume. This function calculates the
%   mass of the volumes and the location of the COM

Vol = bVol + wVol; %sum the volumes
wmass = density * wVol; %dins wedge mass
COM = 1/(bmass + wmass).*(bmass.*bC + wmass.*wC); %barycentric COM calculation
tmass = bmass + wmass; %update total mass 

end 


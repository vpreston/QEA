function [I, check] = planeLineIntersection(n, V0, P0, P1)
% Computes the row-wise intersections of a plane and multiple line
% segments.  The columns in each array correspond to [x, y, z] values.
%
% Inputs:
%       n: normal vector of the plane (1x3)
%       V0: any point on the plane (1x3)
%       P0: end point 1 of the segments P0P1 (nx3)
%       P1: end point 2 of the segments P0P1 (nx3)
%
% Outputs:
%      I are the points of interection (nx3)
%     check (nx1) is an indicator:
%      0 => disjoint (no intersection)
%      1 => the plane intersects P0P1 in the unique point I
%      2 => the segment lies in the plane
%      3 => the intersection lies outside the segment P0P1
%
% From:
% http://www.mathworks.com/matlabcentral/fileexchange/17751-straight-line-and-plane-intersection

P0size = size(P0);
I = NaN*zeros(P0size);
num = P0size(1);
check = zeros(num, 1);

n = repmat(n, num, 1);
u = P1 - P0; % direction and length of line segment
w = bsxfun(@minus, V0, P0); % direction and distance of P0 to plane
D = dot(n, u, 2); % how perpendicular is segment to plane
N = dot(n, w, 2); % how far is segment P0 to plane

% check(and(abs(D) < 1e-7, N==0)) = 2;

for i = 1:num
    if abs(D(i)) < 1e-10 % segment is parallel to plane
        if N(i) == 0
            check(i) = 2;
            break
        else
            check(i) = 0;
            break
        end
    end
    
    % intersection parameter (how far is intersection toward P1 from P0)
    sI = N(i) / D(i);
    I(i,:) = P0(i,:) + sI*u(i,:);
    
    if (sI < 0 || sI > 1)
        check(i) = 3;
    else
        check(i) = 1;
    end
end
end

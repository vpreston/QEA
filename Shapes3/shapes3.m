% Surfaces
%assign the u vector
u=0:0.05:1;
for i=1:21
    U(i,1)=u(i)^3;
    U(i,2)=u(i)^2;
    U(i,3)=u(i);
    U(i,4)=1;
end

%assign the v vector
v=0:0.05:1;
for i=1:21
    V(i,1)=v(i)^3;
    V(i,2)=v(i)^2;
    V(i,3)=v(i);
    V(i,4)=1;
end

%transform matrix
M = [-4 3 -3 1; 3 -6 3 0; -3 3 0 0; 1 0 0 0];

%let's make a patch
p1 = [-3 -4 5 -6 -7 8 -7 -6 5 -4 3 2 -1 2 3 4;
    1 2 3 4 5 6 7 8 7 6 5 4 3 2 1 2;
    2 -3 4 5 6 -7 8 7 -6 5 -4 3 2 1 2 3;
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

%let's assign control vertices for this patch
cv_x=[p1(1,1) p1(1,5) p1(1,9) p1(1,13);
    p1(1,2) p1(1,6) p1(1,10) p1(1,14);
    p1(1,3) p1(1,7) p1(1,11) p1(1,15);
    p1(1,4) p1(1,8) p1(1,12) p1(1,16)];

cv_y = [p1(2,1) p1(2,5) p1(2,9) p1(2,13);
    p1(2,2) p1(2,6) p1(2,10) p1(2,14);
    p1(2,3) p1(2,7) p1(2,11) p1(2,15);
    p1(2,4) p1(2,8) p1(2,12) p1(2,16)];

cv_z = [p1(3,1) p1(3,5) p1(3,9) p1(3,13);
    p1(3,2) p1(3,6) p1(3,10) p1(3,14);
    p1(3,3) p1(3,7) p1(3,11) p1(3,15);
    p1(3,4) p1(3,8) p1(3,12) p1(3,16)];

%let's create the surface now
for i=1:21
    for j=1:21
        p_x(i,j)=U(i,:)*M*cv_x*M'*V(j,:)';
        p_y(i,j)=U(i,:)*M*cv_y*M'*V(j,:)';
        p_z(i,j)=U(i,:)*M*cv_z*M'*V(j,:)';
    end
end

%let's see what this looks like
hold on
axis([-8,8,-8,8,-8,8])
for i=1:21
    plot3(p_x(:,i),p_y(:,i),p_z(:,i), 'k');
    plot3(p_x(i,:),p_y(i,:),p_z(i,:), 'k');
end
for i=1:4
    plot3(p_x(:,i),p_y(:,i),p_z(:,i),':');
    plot3(p_x(i,:),p_y(i,:),p_z(i,:),':');
end

for i=1:4
    for j=1:4
        plot3(cv_x(j,i),cv_y(j,i),cv_z(j,i),'ro');
    end
end

load('train_human_genki.mat');

X = reshape(images,[size(images,1)*size(images,2) size(images,3)])';
y = expressions';
% the first element of theta is the y-intercept, that is
% y = theta(1) + x'*theat(2:end)
theta = zeros(size(X,2)+1,1);
theta = gradientDescentSmile(X,y,theta,10^-5,1000);
% a simple threshold at 0.5 is used to convert the continuous output
% to a decision as to smile versus not smile
accuracy = mean((X*theta(2:end)+theta(1))>0.5 == y)

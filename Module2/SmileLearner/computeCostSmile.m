function J = computeCostSmile(X, y, theta)
%COMPUTECOST Compute cost for linear regression
%   J = COMPUTECOST(X, y, theta) computes the cost of using theta as the
%   parameter for linear regression to fit the data points in X and y

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;

J = sum((X*theta(2:end)+theta(1)-y).^2);

%for i = 1:length(y)
%    prediction = theta(1)+X(i,:)*theta(2:end);
%    J = J + (prediction - y(i))^2;
%end
% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta
%               You should set J to the cost.

% =========================================================================

end

function [theta, J_history, thetas] = gradientDescentSmile(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %
    partial_J_theta_1 = 0;
    partial_J_theta_1_alt = 2*length(y)*theta(1)-2*sum(y)+2*sum(X*theta(2:end));
    partial_J_w = zeros(size(X,2),1);
    v = 2*theta(1)*ones(length(y),1)-2*y+2*X*theta(2:end);
    partial_J_w_alt = (v'*X)';
    grad = [partial_J_theta_1_alt; partial_J_w_alt];

    theta_tmp = theta - grad*alpha;
    if computeCostSmile(X, y, theta_tmp) > computeCostSmile(X,y,theta)
       alpha = alpha/2;
    else
       alpha = alpha*3;
       theta = theta_tmp;
    end

    % Save the cost J in every iteration    
    J_history(iter) = computeCostSmile(X, y, theta);
    subplot(2,1,1);
    imagesc(reshape(theta(2:end),[24 24]));
    colormap('gray');
    subplot(2,1,2);
    plot(J_history);
    drawnow;
end

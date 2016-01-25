function visual_argument()
    step_size = 0.01;
    X = -pi:step_size:pi;
    F = -3 * X;
    G = 4 * sin(X);
    
    h(1) = subplot(1, 3, 1);
    plot(X, F, X, G);
    axis equal
    legend('f', 'g');
    
    h(2) = subplot(1, 3, 2);
    F_prime = diff(F)/step_size;
    G_prime = diff(G)/step_size;
    plot(X(:, 1:length(F_prime)), F_prime, X(:, 1:length(G_prime)), G_prime, X(:, 1:length(F_prime)), F_prime + G_prime, 'g');
    axis equal
    legend('f''', 'g''', 'f'' + g''');
    
    h(3) = subplot(1, 3, 3);
    sum = diff(F + G) / step_size;
    plot(X, F + G, X(:, 1:length(sum)), sum, 'g');
    axis equal
    legend('f + g', '(f + g)''');
    
    

end


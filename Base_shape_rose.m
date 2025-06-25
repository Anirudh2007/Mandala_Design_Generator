function Base_shape_rose()
    figure;
    axis equal;
    hold on;
    axis off;

    k = 4;  % You can change this to any number of petals or petal frequency

    t = linspace(0, 2*pi/k, 1000);       % Parameter theta
    r = cos(k * t);                   % Rose curve equation: r = cos(kθ)
    x = r .* cos(t);                  % Convert to Cartesian: x = r*cos(θ)
    y = r .* sin(t);                  % Convert to Cartesian: y = r*sin(θ)

    plot(x, y, 'm', 'LineWidth', 2);  % Plot the base shape
    axis equal;
    title(sprintf('Rose Curve (k = %d)', k));
    grid on;
    hold off;
end
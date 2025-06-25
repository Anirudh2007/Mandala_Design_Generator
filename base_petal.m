function base_petal()
    figure;
    axis equal;
    hold on;
    axis off;

    % BASE PETAL SHAPE
    t = linspace(0, pi, 100);
    base_x = sin(t);
    base_y = cos(t) .* sin(t);  % smooth petal shape

    base_shape = [base_x; base_y];

    % plot the base shape
    plot(base_shape(1, :), base_shape(2, :), 'r', 'LineWidth', 2);

    title('Base Petal Shape');
end
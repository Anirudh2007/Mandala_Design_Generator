function mandala()
    % Create GUI Figure
    f = figure('Name', 'Mandala Design Generator', 'Position', [300 200 550 550]);

    % ================= Input Fields ===================

    % Base Shape Dropdown
    uicontrol(f, 'Style', 'text', 'Position', [30 480 140 20], 'String', 'Base Shape:', ...
              'FontWeight', 'bold');
    shapeDropdown = uicontrol(f, 'Style', 'popupmenu', ...
        'Position', [180 480 120 25], ...
        'String', {'Petal', 'Polygon', 'Rose Curve'}, ...
        'Callback', @updateShapeInputs);

    % Number of Sectors or Polygon Sides
    label1 = uicontrol(f, 'Style', 'text', 'Position', [30 440 140 20], 'String', 'Number of Sectors:', ...
              'FontWeight', 'bold');
    inputBox1 = uicontrol(f, 'Style', 'edit', 'Position', [180 440 80 25], 'String', '8');

    % For Rose Curve – k value
    labelK = uicontrol(f, 'Style', 'text', 'Position', [30 400 140 20], 'String', 'Rose Petal k:', ...
              'FontWeight', 'bold', 'Visible', 'off');
    kBox = uicontrol(f, 'Style', 'edit', 'Position', [180 400 80 25], 'String', '4', 'Visible', 'off');

    % Number of Layers
    uicontrol(f, 'Style', 'text', 'Position', [30 360 140 20], 'String', 'Number of Layers:', ...
              'FontWeight', 'bold');
    layerBox = uicontrol(f, 'Style', 'edit', 'Position', [180 360 80 25], 'String', '3');

    % Background color dropdown with preview
    uicontrol(f, 'Style', 'text', 'Position', [30 320 140 20], 'String', 'Background Color:', ...
              'FontWeight', 'bold');
    bgColors = {'Black', 'Red', 'Green', 'Blue', 'Yellow', 'Cyan', 'Magenta', 'White'};
    bgColorMap = containers.Map(bgColors, {'k','r','g','b','y','c','m','w'});

    bgDropdown = uicontrol(f, 'Style', 'popupmenu', ...
        'Position', [180 320 120 25], ...
        'String', bgColors, ...
        'Callback', @updatePreview);

    bgPreview = uicontrol(f, 'Style', 'text', ...
        'Position', [310 320 30 25], ...
        'BackgroundColor', 'k');

    function updatePreview(src, ~)
        colorName = bgColors{src.Value};
        set(bgPreview, 'BackgroundColor', bgColorMap(colorName));
    end

    % Shear
    shearCheckbox = uicontrol(f, 'Style', 'checkbox', ...
        'String', 'Apply Shear Transformation', ...
        'Position', [30 280 200 20]);

    uicontrol(f, 'Style', 'text', 'Position', [30 250 120 20], 'String', 'Shear in X (kx):');
    kxBox = uicontrol(f, 'Style', 'edit', 'Position', [180 250 80 25], 'String', '0.3');

    uicontrol(f, 'Style', 'text', 'Position', [30 220 120 20], 'String', 'Shear in Y (ky):');
    kyBox = uicontrol(f, 'Style', 'edit', 'Position', [180 220 80 25], 'String', '0.0');

    % Scaling Slider
    uicontrol(f, 'Style', 'text', 'Position', [30 190 140 20], 'String', 'Base Scaling Factor:', ...
              'FontWeight', 'bold');
    scaleSlider = uicontrol(f, 'Style', 'slider', ...
        'Min', 0.1, 'Max', 1.0, 'Value', 0.8, ...
        'Position', [180 190 200 20]);
    scaleText = uicontrol(f, 'Style', 'text', ...
        'Position', [390 190 50 20], 'String', '0.80');
    scaleSlider.Callback = @(src, ~) set(scaleText, 'String', num2str(get(src, 'Value'), '%.2f'));

    % Show Eigenvectors Checkbox
    eigenCheckbox = uicontrol(f, 'Style', 'checkbox', ...
        'String', 'Show Shear Eigenvectors (in 2nd figure)', ...
        'Position', [30 160 300 20]);

    % Generate Button
    uicontrol(f, 'Style', 'pushbutton', 'String', 'Generate Mandala', ...
        'FontWeight', 'bold', 'FontSize', 12, ...
        'Position', [150 100 220 40], ...
        'Callback', @generateMandala);

    % Save Button
    uicontrol(f, 'Style', 'pushbutton', 'String', 'Save Image', ...
        'FontWeight', 'bold', ...
        'Position', [390 100 100 40], ...
        'Callback', @(~,~) saveas(gcf, 'mandala.png'));

    % === Callback to adjust input fields based on shape ===
    function updateShapeInputs(src, ~)
        val = src.Value;
        if val == 1  % Petal
            label1.String = 'Number of Sectors:';
            label1.Visible = 'on';
            inputBox1.Visible = 'on';
            labelK.Visible = 'off';
            kBox.Visible = 'off';
        elseif val == 2  % Polygon
            label1.String = 'Number of Sides:';
            label1.Visible = 'on';
            inputBox1.Visible = 'on';
            labelK.Visible = 'off';
            kBox.Visible = 'off';
        elseif val == 3  % Rose Curve
            label1.Visible = 'off';
            inputBox1.Visible = 'off';
            labelK.Visible = 'on';
            kBox.Visible = 'on';
        end
    end

    % ============== Callback to Generate Mandala ===============
    function generateMandala(~, ~)
        shapeType = shapeDropdown.Value;
        num_layers = str2double(get(layerBox, 'String'));
        bg_color = bgColorMap(bgColors{get(bgDropdown, 'Value')});
        apply_shear = get(shearCheckbox, 'Value');
        kx = str2double(get(kxBox, 'String'));
        ky = str2double(get(kyBox, 'String'));
        base_scale = get(scaleSlider, 'Value');
        show_eigen = get(eigenCheckbox, 'Value');

        % Shear Matrix
        if apply_shear
            S = [1 kx; ky 1];
        else
            S = eye(2);
        end

        % Setup Mandala Plot
        figure;
        axis equal; hold on; axis off;
        set(gcf, 'Color', bg_color);
        title('Mandala Design Generator', 'Color', 'w');

        colors = lines(num_layers);

        switch shapeType
            case 1 % Petal
                num_sectors = str2double(get(inputBox1, 'String'));
                t = linspace(0, pi, 100);
                base_x = sin(t);
                base_y = cos(t) .* sin(t);
                base_shape = [base_x; base_y];

                theta_step = 2 * pi / num_sectors;
                for layer = 1:num_layers
                    scale = base_scale * (1 - (layer - 1) * 0.2);
                    shape = S * (base_shape * scale);
                    for i = 0:num_sectors - 1
                        theta = i * theta_step;
                        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
                        rotated = R * shape;
                        plot(rotated(1, :), rotated(2, :), 'Color', colors(layer, :), 'LineWidth', 1.5);

                        Ref = [-1 0; 0 1];
                        reflected = R * Ref * shape;
                        plot(reflected(1, :), reflected(2, :), 'Color', colors(layer, :), 'LineWidth', 1.5);
                    end
                end

            case 2 % Polygon
                n_sides = str2double(get(inputBox1, 'String'));
                theta = linspace(0, 2*pi, n_sides+1);
                base_shape = [cos(theta); sin(theta)];
                for layer = 1:num_layers
                    scale = base_scale * (1 - (layer - 1) * 0.2);
                    shape = S * (base_shape * scale);
                    fill(shape(1,:), shape(2,:), colors(layer,:), 'FaceAlpha', 0.1, 'EdgeColor', colors(layer,:), 'LineWidth', 1.5);

                    % Draw diagonals
                    for i = 1:n_sides
                        for j = i+2:n_sides
                            if j ~= mod(i-2, n_sides)+1
                                plot([shape(1,i), shape(1,j)], [shape(2,i), shape(2,j)], ...
                                     'Color', colors(layer,:), 'LineStyle', '-', 'LineWidth', 1.0);
                            end
                        end
                    end
                end

            case 3 % Rose Curve - Single Petal Repeated
                k = str2double(get(kBox, 'String'));
                % Single petal range
                t = linspace(0, 2*pi/k, 300);
                r = cos(k * t);
                base_x = r .* cos(t);
                base_y = r .* sin(t);
                base_shape = [base_x; base_y];

                theta_step = 2 * pi / k;
                for layer = 1:num_layers
                    scale = base_scale * (1 - (layer - 1) * 0.2);
                    shape = S * (base_shape * scale);

                    for i = 0:k-1
                        theta = i * theta_step;
                        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
                        rotated = R * shape;
                        plot(rotated(1, :), rotated(2, :), 'Color', colors(layer, :), 'LineWidth', 1.5);
                    end
                end
        end

        % Show shear eigenvectors in separate figure
        if show_eigen && apply_shear
            figure('Name', 'Shear Eigenvectors');
            axis equal; hold on; grid on;
            set(gcf, 'Color', 'w');
            title('Eigenvectors and Eigenvalues of Shear Matrix');

            [V, D] = eig(S);
            for i = 1:2
                vec = V(:,i);
                lambda = D(i,i);
                quiver(0, 0, vec(1), vec(2), 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5);
                text(vec(1)*1.1, vec(2)*1.1, sprintf('%.2f', lambda), 'FontSize', 12, 'Color', 'b');
            end
            xlim([-2 2]); ylim([-2 2]);
        end
    end
    updateShapeInputs(shapeDropdown, []);
end
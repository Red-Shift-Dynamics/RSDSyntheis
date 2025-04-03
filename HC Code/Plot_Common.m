%% Common Plotting Stuff
function Plot_Common(x, y, C1, C2, VehicleNo, P)
    
    % Data Inputs
    Data = [x, y, C1, C2];

    % Get distinct colors
    Colors = lines(VehicleNo);
    
    % Saved Converged C1
    Saved_C1 = unique(C1);

    % Saved Converged C2
    if isnan(C2) == 0
        Saved_C2 = unique(C2);
    end
    
    % Create Figure
    figure( ...
        'Color', 'w', ...
        'Name',  P.Title, ...
        'NumberTitle', 'Off');
    
    % Axis Properties
    P.x_Domain = [floor(min(x) / P.x_Tick_I) * P.x_Tick_I, ceil(max(x) / P.x_Tick_I) * P.x_Tick_I];
    P.y_Domain = [floor(min(y) / P.y_Tick_I) * P.y_Tick_I, ceil(max(y) / P.y_Tick_I) * P.y_Tick_I];
    
    % Plot Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Iterate and Plot C1 Data with Lines
    for i = 1: 1: length(Saved_C1)

        % Plot Color
        P.Color = Colors(i, :);

        % Current C1 Data
        Tempdat = Data(Data(:, 3) == Saved_C1(i), :);

        % [kg, m^2] Plot Data
        Plot_Function(Tempdat(:, 1), Tempdat(:, 2), P);
        hold on;

    end

    % Saves Inputed Marker
    PMarker = P.Marker;
    
    % Plots Black Lines in Needed
    if P.Black_Lines == true
    
        % Plot Black Lines
        P.Marker    = 'none';
        P.LineStyle = '--';
        P.Color     = 'black';
        for i = 1: 1: length(Saved_C2)   
    
            % Current C1 Data
            Tempdat = Data(Data(:, 4) == Saved_C2(i), :);
    
            % [kg, m^2] Plot Data
            Plot_Function(Tempdat(:, 1), Tempdat(:, 2), P);
            hold on;
    
        end

    end

    % Plot Target Value if True
    if P.Plot_TV == true

        % Plot Data Point
        P.Marker    = '*';
        P.LineStyle = 'none';
        P.Color     = 'r';
        Plot_Function(P.Target_x, P.Target_y, P);
        hold on;

        P.Marker = 'o';
        Plot_Function(P.Target_x, P.Target_y, P);
        hold on;

    end

    % Legend ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Determines if Legend is Necessary
    if length(Saved_C1) ~= VehicleNo
    
        % Legend Properties
        for i = 1: 1: length(Saved_C1)
        
            % Saves Market Handles
            Handles(i) = line(0, 0, ...
                            'Color',      Colors(i, :), ...
                            'LineStyle',  'none', ...
                            'MarkerSize', P.MarkerSize, ...
                            'Marker',     PMarker);
            
            % Creats Legend Label
            legend_Entries(i, :) = sprintf('tau %0.2f', Saved_C1(i));
                    
        end
    
        % Displays Legend
        legend(Handles, legend_Entries, ...
                'Location', 'best');

    end

end
%% ~~~
%}
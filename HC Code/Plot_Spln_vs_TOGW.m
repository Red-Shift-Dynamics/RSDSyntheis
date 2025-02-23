%% Plot OEW vs Planform Area
function Plot_Spln_vs_TOGW(Spln, TOGW, tau, VehicleNo, P)
    
    % Axis Parameters
    x = Spln;
    y = TOGW;
    
    % Get distinct colors
    Colors = lines(VehicleNo);
    
    % Determines Number of Converged tau's
    Saved_tau = unique(tau);
    
    % Create Figure
    figure( ...
        'Color', 'w', ...
        'Name',  P.Title, ...
        'NumberTitle', 'Off');
    
    % Axis Properties
    P.x_Label  = 'Planform Area, Spln (m^2)';
    P.y_Label  = 'Take Off Gross Weight, TOGW (kg)';
    P.x_Domain = [floor(min(x) / P.x_Tick_I) * P.x_Tick_I, ceil(max(x) / P.x_Tick_I) * P.x_Tick_I];
    P.y_Domain = [floor(min(y) / P.y_Tick_I) * P.y_Tick_I, ceil(max(y) / P.y_Tick_I) * P.y_Tick_I];

    % Iterate Through Converged Data and Plot
    for i = 1: 1: VehicleNo
        
        % Find the tau Increment
        tau_i = find(tau(i) == Saved_tau);
        
        % Plot Color
        P.Color = Colors(tau_i, :);
        
        % [kg, m^2] Plot Data
        Plot_Function(x(i), y(i), P)
        hold on;
        
    end
    
    % Creates Legend
    for i = 1: 1: length(Saved_tau)
    
        % Saves Market Handles
        Handles(i) = line(0, 0, ...
                        'Color',      Colors(i, :), ...
                        'LineStyle',  'none', ...
                        'MarkerSize', P.MarkerSize, ...
                        'Marker',     '.');
        
        % Creats Legend Label
        legend_Entries(i, :) = sprintf('tau %0.2f', Saved_tau(i));
                
    end

    % Displays Legend
    legend(Handles, legend_Entries, ...
            'Location', 'best');

end
%% ~~~
%}
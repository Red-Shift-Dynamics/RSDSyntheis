%% Plot OEW vs Planform Area
function Plot_Spln_vs_OEW(Spln, OEW, P);

    % Axis Parameters
    x = Spln;
    y = OEW;

    % Create Figure
    figure( ...
        'Color', 'w', ...
        'Name',  'CHANGE', ...
        'NumberTitle', 'Off');

    % Title Properties
    P.Title = 'CHANGE';

    % Axis Properties
    P.x_Label  = 'Planform Area, Spln (m^2)';
    P.y_Label  = 'Operating Empty Weight, OEW (kg)';
    P.x_Tick_I = 2;
    P.y_Tick_I = 2;
    P.x_Domain = [floor(min(x) / P.x_Tick_I) * P.x_Tick_I, ceil(max(x) / P.x_Tick_I) * P.x_Tick_I];
    P.y_Domain = [floor(min(y) / P.y_Tick_I) * P.y_Tick_I, ceil(max(y) / P.y_Tick_I) * P.y_Tick_I];
    
    % [s, mm] Plot Data
    Plot_Function(x, y, P)

end

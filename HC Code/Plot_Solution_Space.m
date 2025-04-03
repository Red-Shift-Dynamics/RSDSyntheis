%% 3D Solution Space Function
function Plot_Solution_Space(Spln, TOGW, Wpay, tau, VehicleNo, P)

    % Axis Parameters
    x  = Spln;       % [m^2]
    y  = TOGW;       % [Ton]
    z  = Wpay;       % [Ton]
    C2 = tau;
    Data = [x, y, z, tau];

    % Get distinct colors
    Colors = lines(VehicleNo);

    % Saved Converged C1
    Saved_C1 = unique(z);

    % Create Figure
    figure( ...
        'Color', 'w', ...
        'Name',  P.Title, ...
        'NumberTitle', 'Off');
    
    % Axis Properties
    P.x_Domain = [floor(min(x) / P.x_Tick_I) * P.x_Tick_I, ceil(max(x) / P.x_Tick_I) * P.x_Tick_I];
    P.y_Domain = [floor(min(y) / P.y_Tick_I) * P.y_Tick_I, ceil(max(y) / P.y_Tick_I) * P.y_Tick_I];
    P.z_Domain = [floor(min(z) / P.z_Tick_I) * P.z_Tick_I, ceil(max(z) / P.z_Tick_I) * P.z_Tick_I];

    if P.z_Domain(1) == P.z_Domain(2)

        P.z_Domain = [floor(min(z - 10) / P.z_Tick_I) * P.z_Tick_I, ceil(max(z + 10) / P.z_Tick_I) * P.z_Tick_I];

    end
    
    % Iterate and Plot C1 Data with Lines
    for i = 1: 1: length(Saved_C1)

        % Plot Color
        P.Color = Colors(i, :);

        % Current C1 Data
        Tempdat = Data(Data(:, 3) == Saved_C1(i), :);

        % [kg, m^2] Plot Data
        Plot_3D_Function(Tempdat(:, 1), Tempdat(:, 2), Tempdat(:, 3), P);
        hold on;

    end
   
    % Plot Target Value if True
    if P.Plot_TV == true

        % Plot Data Point
        P.Marker    = '*';
        P.LineStyle = 'none';
        P.Color     = 'm';
        Plot_3D_Function(P.Target_x, P.Target_y, P.Target_z, P);
        hold on;

        P.Marker = 'o';
        Plot_3D_Function(P.Target_x, P.Target_y, P.Target_z, P);
        hold on;

    end
    
end
%% ~~~
%}
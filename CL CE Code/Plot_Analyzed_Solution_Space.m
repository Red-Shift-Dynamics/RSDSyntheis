%% 3D Analyzed Solution Space Function
function Plot_Analyzed_Solution_Space(Spln, TOGW, TW0, VehicleResults, ChosenVehicle, GLoadingExceedVehicle, P)

    % Axis Parameters
    x  = Spln;       % [m^2]
    y  = TOGW;       % [Ton]
    z  = TW0;        % [~]
    Data = [x, y, z];
    
    % Convert Table to Array
    VehicleResults = table2array(VehicleResults);

    % Number of Conditions
    NumConditions = width(VehicleResults);
    
    % Generate Graph Colors
    Colors = lines(NumConditions);

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
    
    % Table Column Names
    columnNames = {'Pass', 'Geo_Fail', 'Struc_Fail', 'Struc_Mars_Fail', 'Mars_G_Fail', 'Pitch_Fail', ...
                   'Yaw_Fail', 'Earth_Capture_Fail'};
    
    % ~~~

    % Temperary Plot
    TempMarkerSize = P.MarkerSize;
    TempMarker     = P.Marker;

    % % Set Different Marker
    % P.Marker = 'o';
    % P.Color = 'Black';
    % 
    % % Current C1 Data
    % Tempdat = Data(ChosenVehicle, :);
    % 
    % % [kg, m^2] Plot Data
    % Plot_3D_Function(Tempdat(:, 1), Tempdat(:, 2), Tempdat(:, 3), P);
    % hold on;
    
    % ~~~

    % Set Different Marker
    P.Marker = '.';
    P.Color = [255,69,0] / 255;

    % Current C1 Data
    Tempdat = Data(GLoadingExceedVehicle, :);

    % [kg, m^2] Plot Data
    Plot_3D_Function(Tempdat(:, 1), Tempdat(:, 2), Tempdat(:, 3), P);
    hold on;

    % ~~~

    % Iterate and Plot C1 Data with Lines
    for i = 1: 1: NumConditions

        % Plot Color
        if i == 1
            P.Color = 'Black';
        elseif i == 2
            P.MarkerSize = 5;
        elseif strcmp(columnNames(i), 'Struc_Fail');
            P.MarkerSize = TempMarkerSize;
            P.Color = [255,165,0] / 255;
            'Struc_Fail - Orange';
        elseif strcmp(columnNames(i), 'Mars_G_Fail');
            P.Color = [255,69,0] / 255;
            'Mars_G_Fail - Red';
        elseif strcmp(columnNames(i), 'Earth_Capture_Fail');
            P.Color = [50,205,50] / 255;
            'Earth_Capture_Fail - Orange';
        end

        % Group Vehicle Conditions
        Condition = VehicleResults(isnan(VehicleResults(:, i)) == 0, i);

        if isempty(Condition) ~= 1

            % Rest to Default Marker
            P.Marker = TempMarker;

            % Current C1 Data
            Tempdat = Data(Condition, :);

            % [kg, m^2] Plot Data
            Plot_3D_Function(Tempdat(:, 1), Tempdat(:, 2), Tempdat(:, 3), P);
            hold on;

        end

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
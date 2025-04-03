clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Constant Parameters
[C, SS, SH] = Constant_Parameters();

% Imported Data File
load('Data.mat');
% load('Data - Copy.mat');        Reduce_Data = true;

%% Plots ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Checks for Converged Vehicle
if VehicleNo == 0;
    
    % Print No Convergence
    error('No Converged Vehicles')
    
end
    
% Print # of Converged Vehicles
fprintf('Vehicles Converged:\t%d \n', VehicleNo);

% Common Plot Properties
P.MarkerSize = 15;
P.Marker     = '.';
% P.MarkerSize = 5;
% P.Marker     = 'o';
P.LineStyle = '-';
P.Black_Lines = true;

% Determine Constant Parameter
if length(Wpay) ~= 1 && length(v_sep) == 1
    C2 = VehicleData.Wpay;
elseif length(v_sep) ~= 1 && length(Wpay) == 1
    C2 = VehicleData.v_sep;
else
    C2 = NaN([VehicleNo, 1]);
    P.Black_Lines = false;
    P.LineStyle   = 'none';
end

% Solution Space ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if Plot_3D == true && Converge_SH == true

    % Plot SS_OEW Target Value
    if P.Plot_TV == true;

        % Set Target Point
        P.Target_z = [110];                            % [Ton]
        P.Target_x = TV.FS.Spln * ones(length(P.Target_z), 1);   % [m^2]
        P.Target_y = TV.FS.TOGW * ones(length(P.Target_z), 1);   % [Ton]

    end

    % Axis Labels
    P.x_Label = 'Planform Area, Spln (m^2)';
    P.y_Label = 'Takeoff Gross Weight, TOGW (Tons)';
    P.z_Label = 'Payload Weight, Wpay (Tons)';

    % Plot Properties
    P.Title = 'Full Stack Solution Space';
    P.x_Tick_I = 50;                        % [m^2]
    P.y_Tick_I = 200;                       % [kg -> Ton]
    P.z_Tick_I = 10;                        % [Ton]

    % [m^2, kg -> Ton, kg -> Ton] Plot Solution Space
    Plot_Solution_Space(VehicleData.FS_Spln, VehicleData.FS_TOGW/1000, VehicleData.Wpay/1000, VehicleData.FS_tau, VehicleNo, P);
    
    % % Dry Weight Solution Space ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % 
    % % Plot SS_OEW Target Value
    % if P.Plot_TV == true;
    % 
    %     % Set Target Point
    %     P.Target_y = TV.FS.OEW;    % [Ton]
    % 
    % end
    % 
    % % Axis Labels
    % P.y_Label = 'Operating Empty Weight, OEW (Tons)';
    % 
    % % Plot Properties
    % P.Title = 'Full Stack Solution Space';
    % P.y_Tick_I = 50;                        % [kg -> Ton]
    % 
    % % [m^2, kg -> Ton, kg -> Ton] Plot Solution Space
    % Plot_Solution_Space(VehicleData.FS_Spln, VehicleData.FS_OEW/1000, VehicleData.Wpay/1000, VehicleNo, P);

end

% OEW vs Planform Area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Plot SS_OEW Target Value
if P.Plot_TV == true
    
    % Set Target Point
    P.Target_x = TV.SS.Spln;    % [m^2]
    P.Target_y = TV.SS.OEW;     % [Ton]

end

% Axis Labels
P.x_Label  = 'Planform Area, Spln (m^2)';
P.y_Label  = 'Operating Empty Weight, OEW (Tons)';

% Plot Properties - Starship
P.Title    = 'Starship OEW vs Planform Area';
P.x_Tick_I = 50;                % [m^2]
P.y_Tick_I = 10000 / 1000;      % [kg -> Ton]

% [m^2, kg -> Ton] Plot OEW vs Planform Area - Starship
Plot_Spln_vs_OEW(VehicleData.SS_Spln, VehicleData.SS_OEW/1000, VehicleData.SS_tau, C2, VehicleNo, P);

% Plot SH Spln if True
if Converge_SH == true

    % Plot SS_OEW Target Value
    if P.Plot_TV == true
        
        % Set Target Point
        P.Target_x = TV.SH.Spln;    % [m^2]
        P.Target_y = TV.SH.OEW;     % [Ton]

    end

    % Plot Properties - Superheavy
    P.Title    = 'Superheavy OEW vs Planform Area';
    P.x_Tick_I = 100;
    P.y_Tick_I = 50000 / 1000;      % [kg -> Ton]

    % [m^2, kg -> Ton] Plot OEW vs Planform Area - Superheavy
    Plot_Spln_vs_OEW(VehicleData.SH_Spln, VehicleData.SH_OEW/1000, VehicleData.SH_tau, C2, VehicleNo, P);

end

% TOGW vs Planform Area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Plot SS_TOGW Target Value
if P.Plot_TV == true
    
    % Set Target Point
    P.Target_x = TV.SS.Spln;        % [m^2]
    P.Target_y = TV.SS.TOGW;        % [kg -> Ton]

end

% Axis Labels
P.x_Label  = 'Planform Area, Spln (m^2)';
P.y_Label  = 'Take Off Gross Weight, TOGW (Tons)';
P.x_Tick_I = 50;                    % [m^2]
P.y_Tick_I = 100000 / 1000;         % [kg -> Ton]

% Plot Properties - Starship
P.Title = 'Starship TOGW vs Planform Area';

% [m^2, kg -> Ton] Plot TOGW vs Planform Area - Starship
Plot_Spln_vs_TOGW(VehicleData.SS_Spln, VehicleData.SS_TOGW/1000, VehicleData.SS_tau, C2, VehicleNo, P)

% Plot SH TOGW if True
if Converge_SH == true

    % Plot SS_TOGW Target Value
    if P.Plot_TV == true
        
        % Set Target Point
        P.Target_x = TV.SH.Spln;    % [m^2]
        P.Target_y = TV.SH.TOGW;    % [kg -> Ton]

    end

    % Plot Properties - Superheavy
    P.Title = 'Superheavy TOGW vs Planform Area';

    % [m^2, kg -> Ton] Plot TOGW vs Planform Area - Superheavy
    Plot_Spln_vs_TOGW(VehicleData.SH_Spln, VehicleData.SH_TOGW/1000, VehicleData.SH_tau, C2, VehicleNo, P)

end
%}
%% Data Reduction ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if Reduce_Data == true && Converge_SH == true

    % Calculate Errors
    DATA_Error(:, 1) = abs(VehicleData.SS_TOGW/1000 - TV.SS.TOGW)/TV.SS.TOGW * 100;
    DATA_Error(:, 2) = abs(VehicleData.SH_TOGW/1000 - TV.SH.TOGW)/TV.SH.TOGW * 100;
    DATA_Error(:, 3) = abs(VehicleData.FS_TOGW/1000 - TV.FS.TOGW)/TV.FS.TOGW * 100;
    
    DATA_Error(:, 4) = abs(VehicleData.SS_Spln - TV.SS.Spln)/TV.SS.Spln * 100;
    DATA_Error(:, 5) = abs(VehicleData.SH_Spln - TV.SH.Spln)/TV.SH.Spln * 100;
    DATA_Error(:, 6) = abs(VehicleData.FS_Spln - TV.FS.Spln)/TV.FS.Spln * 100;
    
    DATA_Error(:, 7) = abs(VehicleData.SS_OEW/1000 - TV.SS.OEW)/TV.SS.OEW * 100;
    DATA_Error(:, 8) = abs(VehicleData.SH_OEW/1000 - TV.SH.OEW)/TV.SH.OEW * 100;
    DATA_Error(:, 9) = abs(VehicleData.FS_OEW/1000 - TV.FS.OEW)/TV.FS.OEW * 100;
    
    % [%] Minimum Error
    ERROR = 7.6;
    ERROR0 = 14;
    ERROR1 = 25;
    
    % Reduce Data
    DATA1_Error  = DATA_Error(       DATA_Error(:, 1) <= ERROR, :);
    Reduce_Data  = VehicleData(      DATA_Error(:, 1) <= ERROR, :);
    Reduce_Chart = VehicleChartTable(DATA_Error(:, 1) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 2) <= ERROR, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 2) <= ERROR, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 2) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 3) <= ERROR, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 3) <= ERROR, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 3) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 4) <= ERROR0, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 4) <= ERROR0, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 4) <= ERROR0, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 5) <= ERROR, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 5) <= ERROR, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 5) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 6) <= ERROR, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 6) <= ERROR, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 6) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 7) <= ERROR1, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 7) <= ERROR1, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 7) <= ERROR1, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 8) <= ERROR, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 8) <= ERROR, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 8) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    DATA1_Error  = DATA_Error(  DATA_Error(:, 9) <= ERROR, :);
    Reduce_Data  = Reduce_Data( DATA_Error(:, 9) <= ERROR, :);
    Reduce_Chart = Reduce_Chart(DATA_Error(:, 9) <= ERROR, :);
    DATA_Error   = DATA1_Error;
    
    % Define the table column names
    columnNames = {'SS_TOGW (%)', 'SH_TOGW (%)', 'FS_TOGW (%)', ...
                   'SS_Spln (%)', 'SH_Spln (%)', 'FS_Spln (%)', ...
                   'SS_OEW (%) ', 'SH_OEW (%) ', 'FS_OEW (%) '};
    
    % Convert the numeric array to a table
    DATA_Error = array2table(DATA_Error, 'VariableNames', columnNames);
    
    % Save Reduced Data
    save('Reduced Data.mat', ...
         'Reduce_Data', 'Reduce_Chart', 'DATA_Error');
    
    % Generate Reduced Data Solution Space
    if Plot_3D == true && Converge_SH == true
    
        % Plot SS_OEW Target Value
        if P.Plot_TV == true;
    
            % Set Target Point
            P.Target_x = TV.FS.Spln * ones(1, 1);   % [m^2]
            P.Target_y = TV.FS.TOGW * ones(1, 1);   % [Ton]
            P.Target_z = [115];          % [Ton]
    
        end
    
        % Axis Labels
        P.x_Label = 'Planform Area, Spln (m^2)';
        P.y_Label = 'Takeoff Gross Weight, TOGW (Tons)';
        P.z_Label = 'Payload Weight, Wpay (Tons)';
    
        % Plot Properties
        P.Title = 'Full Stack Solution Space';
        P.x_Tick_I = 50;                        % [m^2]
        P.y_Tick_I = 200;                       % [kg -> Ton]
        P.z_Tick_I = 10;                        % [Ton]
    
        % [m^2, kg -> Ton, kg -> Ton] Plot Solution Space
        Plot_Solution_Space(Reduce_Data.FS_Spln, Reduce_Data.FS_TOGW/1000, Reduce_Data.Wpay/1000, Reduce_Data.FS_tau, VehicleNo, P);
    
    end

end

%% ~~~
%}
%{

% Payload Weight Reduction
Reduce1 = 110 * 1000;           % [Ton -> kg]
Reduce2 = 120 * 1000;           % [Ton -> kg]

% Reduce Data
Tempdat1 = VehicleData(VehicleData.Wpay(:, 1) == Reduce1, :);
Tempdat2 = VehicleData(VehicleData.Wpay(:, 1) == Reduce2, :);
Tempdat  = [Tempdat1; Tempdat2];

% TOGW Reduction
Reduce1 = TV.FS.TOGW * 1000;    % [Ton -> kg]
tol     = 10 * 1000;            % [Ton -> kg]

% Reduce Data
Tempdat1 = Tempdat( Tempdat.FS_TOGW(:, 1)  <= Reduce1 + tol, :);
Tempdat  = Tempdat1(Tempdat1.FS_TOGW(:, 1) >= Reduce1 - tol, :);

% Spln Reduction
Reduce1 = TV.FS.Spln;           % [m^2]
tol     = 150;                  % [Ton -> kg]

% Reduce Data
Tempdat1 = Tempdat( Tempdat.FS_Spln(:, 1)  <= Reduce1 + tol, :);
Tempdat  = Tempdat1(Tempdat1.FS_Spln(:, 1) >= Reduce1 - tol, :);

% Save Data
Reduced_Dat = Tempdat;

%}
clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Imported Data File
% load('Data.mat');
load('Data VA.mat');

%% Data Reduction Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [int#] Save Data Points of Interest
% I_Save = 8;       % Cost
I_Save = 14;

L_Wpay  = length(unique(VehicleData.Wpay ));
L_v_sep = length(unique(VehicleData.v_sep));

TV.SS.OEW = 130;

%% Reduce Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [%] Calculate TOGW Error
DATA_Error(:, 1) = abs(VehicleData.SS_TOGW/1000 - TV.SS.TOGW)/TV.SS.TOGW * 100;
DATA_Error(:, 2) = abs(VehicleData.SH_TOGW/1000 - TV.SH.TOGW)/TV.SH.TOGW * 100;
DATA_Error(:, 3) = abs(VehicleData.FS_TOGW/1000 - TV.FS.TOGW)/TV.FS.TOGW * 100;

% [%] Calculate Planform Area Error
DATA_Error(:, 4) = abs(VehicleData.SS_Spln - TV.SS.Spln)/TV.SS.Spln * 100;
DATA_Error(:, 5) = abs(VehicleData.SH_Spln - TV.SH.Spln)/TV.SH.Spln * 100;
DATA_Error(:, 6) = abs(VehicleData.FS_Spln - TV.FS.Spln)/TV.FS.Spln * 100;

% % Calculate Slenderness Parameter Error
% DATA_Error(:, 4) = abs(VehicleData.SS_tau - 0.22)/0.22 * 100;
% DATA_Error(:, 5) = abs(VehicleData.SH_tau - 0.27)/0.27 * 100;

% [%] Calculate Dry Weight Error
DATA_Error(:, 7) = abs(VehicleData.SS_OEW/1000 - TV.SS.OEW)/TV.SS.OEW * 100;
DATA_Error(:, 8) = abs(VehicleData.SH_OEW/1000 - TV.SH.OEW)/TV.SH.OEW * 100;
DATA_Error(:, 9) = abs(VehicleData.FS_OEW/1000 - TV.FS.OEW)/TV.FS.OEW * 100;

% Calculate Slenderness Parameter Error
DATA_Error(:, 10) = abs(VehicleData.SS_tau - 0.22)/0.22 * 100;
DATA_Error(:, 11) = abs(VehicleData.SH_tau - 0.27)/0.27 * 100;

% [%] Root Mean Square Error
SetL = length(DATA_Error(1, :)) + 1;
for i = 1: 1: VehicleNo
    DATA_Error(i, SetL) = norm(DATA_Error(i, :));
end

% Format Data Error Table
% columnNames = {'SS_TOGW', 'SH_TOGW', 'FS_TOGW', ...
%                'SS_Spln', 'SH_Spln', 'FS_Spln', ...
%                'SS_OEW ', 'SH_OEW ', 'FS_OEW ', 'Total_Error'};
% columnNames = {'SS_TOGW', 'SH_TOGW', 'FS_TOGW', ...
%                'SS_tau ', 'SH_tau ', 'Total_Error'};
columnNames = {'SS_TOGW', 'SH_TOGW', 'FS_TOGW', ...
               'SS_Spln', 'SH_Spln', 'FS_Spln', ...
               'SS_OEW ', 'SH_OEW ', 'FS_OEW ', ...
               'SS_tau ', 'SH_tau ', 'Total_Error'};

% Convert the numeric array to a table
DATA_Error = array2table(DATA_Error, 'VariableNames', columnNames);

% Sort Tables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Sort Tables by Payload Weight
for i = 1: 1: L_Wpay

    % Create Tables from Payload Weights
    TStore(i).SWpay  = VehicleData(VehicleData.Wpay == Wpay(i), :);
    TStore(i).SWpayE = DATA_Error (VehicleData.Wpay == Wpay(i), :);
    
    % Sort Table by Error
    TStore(i).SWpayESort = sortrows(TStore(i).SWpayE, SetL, 'ascend');
    [~, sortIndex]       = ismember(TStore(i).SWpayESort, TStore(i).SWpayE, 'rows');
    TStore(i).SWpaySort  = TStore(i).SWpay(sortIndex, :);
    
    % Save Data Points and Error
    ReVehicleData(i).Wpay  = TStore(i).SWpaySort (1: I_Save, :);
    ReVehicleData(i).WpayE = TStore(i).SWpayESort(1: I_Save, :);

end

% Sort Tables by Separation Velocity
for i = 1: 1: L_v_sep

    % Create Tables from Separation Velocity
    TStore(i).Sv_sep  = VehicleData(VehicleData.v_sep == v_sep(i), :);
    TStore(i).Sv_sepE = DATA_Error (VehicleData.v_sep == v_sep(i), :);
    
    % Sort Table by Error
    TStore(i).Sv_sepESort = sortrows(TStore(i).Sv_sepE, SetL, 'ascend');
    [~, sortIndex]        = ismember(TStore(i).Sv_sepESort, TStore(i).Sv_sepE, 'rows');
    TStore(i).Sv_sepSort  = TStore(i).Sv_sep(sortIndex, :);

    % Save Data Points and Error
    ReVehicleData(i).v_sep  = TStore(i).Sv_sepSort (1: I_Save, :);
    ReVehicleData(i).v_sepE = TStore(i).Sv_sepESort(1: I_Save, :);

end

% Combine and Output ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Combine Payload Weight Table
for i = 1: 1: L_Wpay
    if i ~= 1
        CombTable.Wpay  = [CombTable.Wpay;  ReVehicleData(i).Wpay ];
        CombTable.WpayE = [CombTable.WpayE; ReVehicleData(i).WpayE];
    else
        CombTable.Wpay  = ReVehicleData(i).Wpay;
        CombTable.WpayE = ReVehicleData(i).WpayE;
    end
end

% Combine Separation Velocity Table
for i = 1: 1: L_v_sep
    if i ~= 1
        CombTable.v_sep  = [CombTable.v_sep;  ReVehicleData(i).v_sep ];
        CombTable.v_sepE = [CombTable.v_sepE; ReVehicleData(i).v_sepE];
    else
        CombTable.v_sep  = ReVehicleData(i).v_sep;
        CombTable.v_sepE = ReVehicleData(i).v_sepE;
    end
end

% Save Reduced Data
save('Reduced Vehicle Data.mat', ...
     'ReVehicleData', 'CombTable');

% Output txt File of Tables
writetable(CombTable.Wpay, 'Reduced Vehicle Data Wpay.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);
writetable(CombTable.v_sep, 'Reduced Vehicle Data v_sep.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);

%% Create New Solution Space from Reduced Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Common Plot Properties
P.MarkerSize = 15;
P.Marker     = '.';
P.LineStyle  = 'none';

% Plot SS_OEW Target Value
if P.Plot_TV == true;

    % Set Target Point
    P.Target_x = TV.FS.Spln * ones(1, 1);   % [m^2]
    P.Target_y = TV.FS.TOGW * ones(1, 1);   % [Ton]
    P.Target_z = [125];                     % [Ton]

end

% Axis Labels
P.x_Label = 'Planform Area, Spln (m^2)';
P.y_Label = 'Takeoff Gross Weight, TOGW (Tons)';
P.z_Label = 'Payload Weight, Wpay (Tons)';

% Plot Properties
P.x_Tick_I = 50;                        % [m^2]
P.y_Tick_I = 200;                       % [kg -> Ton]
P.z_Tick_I = 10;                        % [Ton]

% % [m^2, kg -> Ton, kg -> Ton] Plot Solution Space
% P.Title = 'Full Stack Solution Space Wpay';
% Plot_Solution_Space(CombTable.Wpay.FS_Spln, CombTable.Wpay.FS_TOGW/1000, CombTable.Wpay.Wpay/1000, CombTable.Wpay.FS_tau, length(CombTable.Wpay.Wpay), P);
% 
% % [m^2, kg -> Ton, kg -> Ton] Plot Solution Space
% P.Title = 'Full Stack Solution Space for v_{sep}';
% Plot_Solution_Space(CombTable.v_sep.FS_Spln, CombTable.v_sep.FS_TOGW/1000, CombTable.v_sep.Wpay/1000, CombTable.v_sep.FS_tau, length(CombTable.v_sep.Wpay), P);

% Clean Workspace
clear columnNames C TStore Converge_SH I_Save Plot_3D Reduce_Data Save_Data sortIndex i P MTV

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}
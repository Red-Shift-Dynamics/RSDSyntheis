clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Import Plotting Funcitons
addpath('C:\Users\Taquito-Mini\Documents\GitHub\Synthesis\HC Code');

% Import Data Files
addpath('C:\Users\Taquito-Mini\Documents\GitHub\Synthesis\CL CE Code\703 Vehicles 28 Raptor 3 FINAL DESIGN\8.5 m 12.5 Area 3.3 FINAL DESIGN');
load('Data VA', 'VehicleData', 'SS', 'SH', 'TV', 'VehicleNo');
load('Calculated Data VA', 'CalculatedData');

% Full Annnotated Solution Space
load('Vehicle Results', 'VehicleResults', 'VehiclePerformance');

% % Only Passed Vehicles
% load('Vehicle Results Simplified', 'VehicleResults', 'VehiclePerformance');

% % Only Passed Vehicle
% load('Vehicle Results FINAL VEHICLE', 'VehicleResults', 'VehiclePerformance');

rmpath('C:\Users\Taquito-Mini\Documents\GitHub\Synthesis\CL CE Code\703 Vehicles 28 Raptor 3 FINAL DESIGN\8.5 m 12.5 Area 3.3 FINAL DESIGN');

%% Plots ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% CHOSEN VEHICLE
% ChosenVehicle = 158;
% ChosenVehicle = [81; 158; 167; 227; 445];
ChosenVehicle = [167];

% Create New Solution Space from Reduced Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Common Plot Properties
P.MarkerSize = 15;
P.Marker     = '.';
P.LineStyle  = 'none';
P.Plot_TV    = true;

% Plot Starship OEW Target Value
if P.Plot_TV == true;

    % Set Target Point
    P.Target_x = TV.FS.Spln;                                    % [m^2] Planform Area        - Full Stack
    P.Target_y = TV.FS.TOGW;                                    % [Ton] Takeoff Gross Weight - Full Stack
    P.Target_z = [(SH.N_eng * SH.ET0) / (TV.FS.TOGW * 1000)];   % [~]   Thrust to Weight     - Full Stack
    P.Target_z = 0.22;
    % P.Target_z = 1400;
end

% Axis Labels
P.x_Label = 'Planform Area, Spln (m^2)';
P.y_Label = 'Takeoff Gross Weight, TOGW (Tons)';
P.View    = [-340, 10];

% Plot Properties
P.Title = 'CE Solution Space';
P.x_Tick_I = 50;                        % [m^2]
P.y_Tick_I = 100;                       % [kg -> Ton]
P.z_Tick_I = 0.02;                      % [~]
% P.z_Tick_I = 100;

% Passed Vehicle Numbers
NumVehiclePass = VehicleResults.Pass(isnan(VehicleResults.Pass) == 0);

% [int#] Number of Vehicles
IntPass = length(VehicleResults.Pass(isnan(VehicleResults.Pass) == 0));

% Put Vehicles into Table
for i = 1: 1: IntPass
    PassedVehicles(i, :) = VehicleData(NumVehiclePass(i), :);
end

% Max G Loading
% GMax = 6.05;
% GLoadingExceedVehicle = NumVehiclePass(VehiclePerformance.dvRemian > GMax);
dvMax = 1;
dvRemianVehicle = NumVehiclePass(VehiclePerformance.dvRemain < dvMax);

%% Plots ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% % [m^2, kg -> Ton, ~] Plot Solution Space
% P.z_Label = 'Thrust to Weight, T/W';
% Plot_Solution_Space(VehicleData.FS_Spln, VehicleData.FS_TOGW/1000, ...
%                     (SH.N_eng * SH.ET0) ./ VehicleData.FS_TOGW, VehicleData.v_sep, VehicleNo, P);

% % [m^2, kg -> Ton, ~] Plot Solution Space
% Plot_Solution_Space(VehicleData.FS_Spln, VehicleData.FS_TOGW/1000, ...
%                     VehicleData.SS_tau, VehicleData.v_sep, VehicleNo, P);

% % [m^2, kg -> Ton, ~] Plot Analyzed Solution Space
% P.z_Label = 'Thrust to Weight, T/W';
% Plot_Analyzed_Solution_Space(VehicleData.FS_Spln, VehicleData.FS_TOGW/1000, ...
%     (SH.N_eng * SH.ET0) ./ VehicleData.FS_TOGW, VehicleResults, NumVehiclePass, ChosenVehicle, dvRemianVehicle, P);
% P.z_Label = 'Starship Slenderness, tau_SS';
% Plot_Analyzed_Solution_Space(VehicleData.FS_Spln, VehicleData.FS_TOGW/1000, ...
%              VehicleData.SS_tau, VehicleResults, NumVehiclePass, ChosenVehicle, dvRemianVehicle, P);

% 3D Print ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Surf Plot
P.z_Label = 'Thrust to Weight, T/W';
Plot_3D_Print(VehicleData.FS_Spln, VehicleData.FS_TOGW/1000, ...
    (SH.N_eng * SH.ET0) ./ VehicleData.FS_TOGW, NumVehiclePass, ChosenVehicle, P)

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}
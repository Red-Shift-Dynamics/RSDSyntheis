clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Data File Inputs
load('Data VA', 'VehicleData', 'SS', 'SH', 'TV', 'VehicleNo');
load('Calculated Data VA', 'CalculatedData');

% Chosen Vehicle
ChosenVehicle = [167];

%% Data File

% Output txt File of Tables
SaveVD = VehicleData(ChosenVehicle, :);
writetable(SaveVD, 'VehicleDataTable.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);

SaveCD = CalculatedData(ChosenVehicle, :);
writetable(SaveCD, 'CalculatedDataTable.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);

%% ~~~
%}
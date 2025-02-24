clear all, clc, close all, format compact, format longG, tic;
%% Import
load('Data.mat')

%%
Spln = VehicleData.SS_Spln;
TOGW = VehicleData.SS_TOGW;
tau  = VehicleData.SS_tau;

% Axis Parameters
x = Spln;
y = TOGW;
Data = [tau, x, y];

% Get distinct colors
Colors = lines(VehicleNo);

% Determines Number of Converged tau's
Saved_tau = unique(VehicleData.SS_tau);

% % Sort Data Table Baised off Tau Values in Ascending Order
% STORE = sortrows(VehicleData, 'SS_tau', 'ascend');

% % Iterate Through Converged Data and Plot
% for i = 1: 1: VehicleNo
% 
%     % Find the tau Increment
%     tau_i = find(tau(i) == Saved_tau);
% 
%     % Plot Color
%     P.Color = Colors(tau_i, :);
% 
% 
% end

for i = 1: 1: length(Saved_tau)
    
    % Current tau Data
    Tempdat = Data(Data(:, 1) == Saved_tau(i), :);

    % % Save Data
    % tau_Data.(sprintf('tau_%d', i)) = VehicleData(VehicleData.SS_tau == Saved_tau(i), :);
    
    % Plot Data
    plot(Tempdat(2, :), Tempdat(3, :))
    hold on;

end

%% ~~~
%}
clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Constant Parameters
[C, SS, SH] = Constant_Parameters();

%% Input Paramters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Create New Incriment Structure for Starship and Superheavy
SSi = SS;   SHi = SH;   VehicleNo = 0;

% Converge SH
Converge_SH = true;

% Created 3D FS Solution Space
Plot_3D = true;         % Only Works When Converge_SH == true

% Save Data Statement
Save_Data = true;

% Plot Target Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Target Values
P.Plot_TV = true;

% [Ton] Dry Weight
TV.SS.OEW = 180;                        % Starship
TV.SH.OEW = 320;                        % Superheavy
TV.FS.OEW = TV.SS.OEW + TV.SH.OEW;      % Superheavy

% [Ton] Takeoff Gross Weight
TV.SS.TOGW = 1680 + 100;                % Starship
TV.SH.TOGW = 3720;                      % Superheavy
TV.FS.TOGW = TV.SS.TOGW + TV.SH.TOGW;   % Full Stack

% [m^2] Planform Area
TV.SS.Spln = 550;                       % Starship
TV.SH.Spln = 630;                       % Superheavy
TV.FS.Spln = TV.SS.Spln + TV.SH.Spln;   % Full Stack

% Mission Trade Variables (MTV) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Payload Weight
% Wpay = [100: 10: 150] * 1000;               % Trade Values
Wpay = 125 * 1000;                          % Best Value
% Wpay = [100: 10: 140] * 1000;               % 4 Point Vehicles Raptor 2

% [m/s] Separation Velocity
% v_sep = [1300: 200: 2200];                  % Trade Values
v_sep = [1300: 50: 2200];                  % Trade Values
% v_sep = 1400;                               % Best Value
% v_sep = [1300: 100: 1500];                  % 4 Point Vehicles Raptor 2

% Iterated Geometric Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Slenderness Parameter - Starship
SS.tau = transpose([0.15: 0.02: 0.32]);     % Trade Values
% SS.tau = transpose([0.15: 0.005: 0.32]);     % Trade Values
% SS.tau = 0.16;                              % Best Value    
% SS.tau = 0.22;                              % Actual Value
% SS.tau = transpose([0.15: 0.01: 0.18]);     % 4 Point Vehicles Raptor 2

% Slenderness Parameter - Superheavy
SH.tau = transpose([0.20: 0.02: 0.38]);     % Trade Values - 4 Point Vehicles Raptor 2
% SH.tau = transpose([0.20: 0.005: 0.38]);     % Trade Values - 4 Point Vehicles Raptor 2
% SH.tau = 0.28;                              % Best Value 
% SH.tau = 0.27;                              % Actual Value

% Inital Guessed Values or Target Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [Ton -> kg] Takeoff Gross Weight - Starship
SS_TOGWi = TV.SS.TOGW * 1000;

% [m^2] Planform Area - Starship
SS_Splni = TV.SS.Spln;

% [Ton -> kg] Takeoff Gross Weight - Superheavy
SH_TOGWi = TV.SH.TOGW * 1000;

% [m^2] Planform Area - Superheavy
SH_Splni = TV.SH.Spln;

%% The Meat and the Bones ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Initial Conditions
x0_SS = [SS_TOGWi; SS_Splni];
x0_SH = [SH_TOGWi; SH_Splni];

% Set Optimization Options
tol   = 1e-10;                                      % Solver Tolerance  
I_Max = 10000;                                      % Max Iterations
options = optimoptions('fsolve', ...
                'display','off', ...                % Disable Text Displayed in Console
                  'TolX', tol, ...                  % Solution Tolerance
                'TolFun', tol, ...                  % Function Tolerance
                'MaxIterations', I_Max, ...         % Max Number of Iterations
                'MaxFunctionEvaluations', 2*I_Max); % Max Function Evaluations

% Iterate Through Payload Weight
for a = 1: 1: length(Wpay)

    % Iterate Through Separation Velocity
    for e = 1: 1: length(v_sep)

        % Iterate Through Starship tau Values
        for i = 1: 1: length(SS.tau)
            
            % Mission Parameters
            MTV.Wpay  = Wpay(a);
            MTV.v_sep = v_sep(e);
            
            % Starship ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

            % Starship Slenderness Parameter
            SSi.tau = SS.tau(i);

            % [kg, m^2] Solve Starship TOGW and Planform Area
            [x] = fsolve(@(x) Solve_SS_OWE(C, MTV, SSi, x), x0_SS, options);
            
            % [kg, m^2] Deal Solved Output Vector
            [SSi.TOGW, SSi.Spln] = deal(x(1), x(2));
            
            % Calculate Starship Converged Parameters
            [SSi] = Calculate_Starship_Budget(C, MTV, SSi);
            
            % Check SS ERROR
            [ERROR_SS] = Solve_SS_OWE(C, MTV, SSi, x);
            if ERROR_SS(1) > 0.001 || ERROR_SS(2) > 0.001

                % ERROR_SS
                % disp('SS FAIL')

            elseif SSi.OEW < 10
                
                % disp('Bad SS Converge')
                % SSi_OEW = SSi.OEW

            elseif Converge_SH == false
        
                % [int#] Creates Vehicle Counter
                clc
                
		        VehicleNo = VehicleNo + 1
    
                % Viewing Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
                % Save Converged Starship Data
                Vehicle.Chart(VehicleNo, :) = [Wpay(a)  / 1000, v_sep(e), SSi.tau, ...
                                               SSi.TOGW / 1000, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW / 1000, SSi.mppl / 1000, SSi.WR];
                
		        % Puts data in to table thats easier to read
		        % Define the table column names
		        columnNames = {   'Wpay (Ton)',         'v_sep',        'SS_tau', ...
						       'SS_TOGW (Ton)', 'SS_Spln (m^2)', 'SS_Swet (m^2)', 'SS_OWEw (kg)', 'SS_OWEv (kg)', 'SS_OEW (Ton)', 'SS_mppl (Ton)', 'SS_WR'};
		        
		        % Convert the numeric array to a table
		        VehicleChartTable = array2table(Vehicle.Chart, 'VariableNames', columnNames);
                
                % Data Saved ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
                % Save Converged Starship Data
                Vehicle.Data(VehicleNo, :) = [Wpay(a),  v_sep(e), SSi.tau, ...
                                              SSi.TOGW, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW, SSi.mppl];
                Vehicle.SS(VehicleNo) = SSi;
    
		        % Define the table column names
		        columnNames = {   'Wpay',   'v_sep',  'SS_tau', ...
						       'SS_TOGW', 'SS_Spln', 'SS_Swet', 'SS_OWEw', 'SS_OWEv', 'SS_OEW', 'SS_mppl'};
    
		        % Convert the numeric array to a table
		        VehicleData = array2table(Vehicle.Data, 'VariableNames', columnNames);

            else

                % Iterate Through Superheavy tau Values
                for f = 1: 1: length(SH.tau)

                    % Superheavy Slenderness Parameter
                    SHi.tau = SH.tau(f);

                    % [kg, m^2] Solve Superheavy TOGW and Planform Area
                    [y] = fsolve(@(x) Solve_SH_OWE(C, MTV, SHi, SSi, x), x0_SH, options);

                    % [kg, m^2] Deal Solved Output Vector
                    [SHi.TOGW, SHi.Spln] = deal(y(1), y(2));

                    % Calculate Superheavy Converged Parameters
                    [SHi] = Calculate_Superheavy_Budget(C, MTV, SHi, SSi);

                    % Save Converged Data ~~~~~~~~~~~~~~~~~~~~~~~~~~

                    % Check SH ERROR
                    [ERROR_SH] = Solve_SH_OWE(C, MTV, SHi, SSi, y);
                    if ERROR_SH(1) > 0.001 || ERROR_SH(2) > 0.001

                        % ERROR_SH
                        % disp('SH FAIL')

                    elseif SHi.OEW < 10

                        % SHi_OEW = SHi.OEW
                        % disp('Bad SH Converge')

                    else
                        
                        % [int#] Creates Vehicle Counter
                        clc, VehicleNo = VehicleNo + 1

                        % Full Stack Calculations ~~~~~~~~~~~~~~~~~~~~~~~~~~
                        
                        % Needed Calculations for FS_tau
                        SSi.Vtot = SSi.tau * SSi.Spln^1.5;      % [m^3] Total Volume  - Full Stack
                        SHi.Vtot = SHi.tau * SHi.Spln^1.5;      % [m^3] Total Volume  - Full Stack
                        FSi.Vtot = SSi.Vtot + SHi.Vtot;         % [m^3] Total Volume  - Full Stack
                        FSi.Spln = SSi.Spln + SHi.Spln;         % [m^2] Planform Area - Full Stack

                        FSi.tau  = FSi.Vtot / FSi.Spln^1.5;     %       Slenderness   - Full Stack
                        FSi.TOGW = SSi.TOGW + SHi.TOGW;         % [kg]  Takeoff Gross - Full Stack
                        FSi.Swet = SSi.Swet + SHi.Swet;         % [m^2] Wetted Area   - Full Stack
                        FSi.OWEw = SSi.OWEw + SHi.OWEw;         % [kg]  Weight Budget - Full Stack
                        FSi.OWEv = SSi.OWEv + SHi.OWEv;         % [kg]  Volume Budget - Full Stack
                        FSi.OEW  = SSi.OEW  + SHi.OEW;          % [kg]  Dry Weight    - Full Stack
                        FSi.mppl = SSi.mppl + SHi.mppl;         % [kg]  Propellant    - Full Stack
                        FSi.WR   = SSi.WR   + SHi.WR;           %       Weight Ratio  - Full Stack

                        % Viewing Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        % Save Converged Starship and Superheavy Data
                        Vehicle.Chart(VehicleNo, :) = [Wpay(a)  / 1000, v_sep(e), SSi.tau,  SHi.tau,  FSi.tau, ...
                                                       SSi.TOGW / 1000, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW / 1000, SSi.mppl / 1000, SSi.WR, ... 
                                                       SHi.TOGW / 1000, SHi.Spln, SHi.Swet, SHi.OWEw, SHi.OWEv, SHi.OEW / 1000, SHi.mppl / 1000, SHi.WR, ...
                                                       FSi.TOGW / 1000, FSi.Spln, FSi.Swet, FSi.OWEw, FSi.OWEv, FSi.OEW / 1000, FSi.mppl/ 1000,  FSi.WR];
                        
						% Puts data in to table thats easier to read
						% Define the table column names
						columnNames = {'Wpay (Ton)',    'v_sep (m/s)',   'SS_tau',        'SH_tau',       'FS_tau', ...
           							   'SS_TOGW (Ton)', 'SS_Spln (m^2)', 'SS_Swet (m^2)', 'SS_OWEw (kg)', 'SS_OWEv (kg)', 'SS_OEW (Ton)', 'SS_mppl (Ton)', 'SS_WR', ...
           							   'SH_TOGW (Ton)', 'SH_Spln (m^2)', 'SH_Swet (m^2)', 'SH_OWEw (kg)', 'SH_OWEv (kg)', 'SH_OEW (Ton)', 'SH_mppl (Ton)', 'SH_WR', ...
                                       'FS_TOGW (Ton)', 'FS_Spln (m^2)', 'FS_Swet (m^2)', 'FS_OWEw (kg)', 'FS_OWEv (kg)', 'FS_OEW (Ton)', 'FS_mppl (Ton)', 'FS_WR'};
						
						% Convert the numeric array to a table
						VehicleChartTable = array2table(Vehicle.Chart, 'VariableNames', columnNames);
                        
                        % Data Saved ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        % Save Converged Starship and Superheavy Data
                        Vehicle.Data(VehicleNo, :) = [Wpay(a),  v_sep(e), SSi.tau,  SHi.tau,  FSi.tau, ...
                                                      SSi.TOGW, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW, SSi.mppl, SSi.WR, ...
                                                      SHi.TOGW, SHi.Spln, SHi.Swet, SHi.OWEw, SHi.OWEv, SHi.OEW, SHi.mppl, SHi.WR, ...
                                                      FSi.TOGW, FSi.Spln, FSi.Swet, FSi.OWEw, FSi.OWEv, FSi.OEW, FSi.mppl, FSi.WR];
                        Vehicle.SS(VehicleNo) = SSi;
						Vehicle.SH(VehicleNo) = SHi;
                        Vehicle.FS(VehicleNo) = FSi;

						% Define the table column names
						columnNames = {'Wpay',    'v_sep',   'SS_tau',  'SH_tau',  'FS_tau', ...
           							   'SS_TOGW', 'SS_Spln', 'SS_Swet', 'SS_OWEw', 'SS_OWEv', 'SS_OEW', 'SS_mppl', 'SS_WR', ...
           							   'SH_TOGW', 'SH_Spln', 'SH_Swet', 'SH_OWEw', 'SH_OWEv', 'SH_OEW', 'SH_mppl', 'SH_WR', ...
                                       'FS_TOGW', 'FS_Spln', 'FS_Swet', 'FS_OWEw', 'FS_OWEv', 'FS_OEW', 'FS_mppl', 'FS_WR'};

						% Convert the numeric array to a table
						VehicleData = array2table(Vehicle.Data, 'VariableNames', columnNames);

                    end
                end
            end
        end
    end
end

% Save To Data File
clear a columnNames e ERROR_SH ERROR_SS f i I_Max MTV options SH_Splni SH_TOGWi SHi SS_Splni SS_TOGWi SSi FS FSi tol x x0_SH x0_SS y
clc

% Create Data File
if Save_Data == true
    save('Data.mat');
end

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Checks for Converged Vehicle
if VehicleNo == 0;
    
    % Print No Convergence
    error('No Converged Vehicles')

end

% Vehicle Calculations
Converged_Solutions_Calculations();

% Create Plots
Plot_Generation();

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}
% Prints the simulation time on the command window.
fprintf('Program Complete! (%0.3f seconds)\n', toc);
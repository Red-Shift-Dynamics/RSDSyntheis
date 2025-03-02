clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Constant Parameters
[C, SS, SH] = Constant_Parameters();

%% Input Paramters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Create New Incriment Structure for Starship and Superheavy
SSi = SS;   SHi = SH;   VehicleNo = 0;

% Converge SH
Converge_SH = true;

% Mission Trade Variables (MTV) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Payload Weight
Wpay = [100: 10: 150] * 1000;
% Wpay = 100 * 1000;

% [m/s] Separation Velocity
% v_sep = [1400: 200: 2200];       % PROVIDE RANGE
v_sep = 1500;

% Iterated Geometric Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Slenderness Parameter - Starship
SS.tau = transpose([0.18: 0.02: 0.28]);
% SS.tau = 0.24;

% Slenderness Parameter - Superheavy
SH.tau = transpose([0.2: 0.02: 0.34]);
% SH.tau = SS.tau;
% SH.tau = 0.28;

% Technology Trade Variables (TTV) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [Structural Index

% Inital Guessed Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Takeoff Gross Weight - Starship
SS_TOGWi = 1700 * 1000;

% [m^2] Planform Area - Starship
SS_Splni = 550;

% [MTon -> kg] Takeoff Gross Weight - Superheavy
SH_TOGWi = 3800 * 1000;

% [m^2] Planform Area - Superheavy
SH_Splni = 630;

%% The Meat and the Bones ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Initial Conditions
x0_SS = [SS_TOGWi; SS_Splni];
x0_SH = [SH_TOGWi; SH_Splni];

% Set Optimization Options
tol = 1e-5;                                 % Solver Tolerance           
options = optimoptions('lsqnonlin', ...
                'display','off', ...        % Disable Text Displayed in Console
                'TolFun', tol, ...          % Function Tolerance
                  'TolX', tol);             % Solution Tolerance

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
            [x] = lsqnonlin(@(x) Solve_SS_OWE(C, MTV, SSi, x), x0_SS, [], [], options);
            
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

            % elseif 3000 < SSi.TOGW / 1000
            % 
            %     disp('3000 MTon < SS.TOGW')
            %     SS_TOGW = SSi.TOGW / 1000

            elseif Converge_SH == false
        
                % [int#] Creates Vehicle Counter
                clc
		        VehicleNo = VehicleNo + 1
    
                % Viewing Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
                % Save Converged Starship Data
                Vehicle.Chart(VehicleNo, :) = [Wpay(a) / 1000,  v_sep(e), SSi.tau, ...
                                               SSi.TOGW / 1000, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW / 1000, SSi.mppl / 1000, SSi.WR];
                
		        % Puts data in to table thats easier to read
		        % Define the table column names
		        columnNames = {'Wpay (Ton)',    'v_sep',         'SS_tau', ...
						       'SS_TOGW (Ton)', 'SS_Spln (m^2)', 'SS_Swet (m^2)', 'SS_OWEw (kg)', 'SS_OWEv (kg)', 'SS_OEW (Ton)', 'SS_mppl (Ton)', 'SS_WR'};
		        
		        % Convert the numeric array to a table
		        VehicleChartTable = array2table(Vehicle.Chart, 'VariableNames', columnNames);
                
                % Data Saved ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
                % Save Converged Starship Data
                Vehicle.Data(VehicleNo, :) = [Wpay(a),   v_sep(e), SSi.tau, ...
                                               SSi.TOGW, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW, SSi.mppl];
                Vehicle.SS(VehicleNo) = SSi;
    
		        % Define the table column names
		        columnNames = {'Wpay',    'v_sep',   'SS_tau', ...
						       'SS_TOGW', 'SS_Spln', 'SS_Swet', 'SS_OWEw', 'SS_OWEv', 'SS_OEW', 'SS_mppl'};
    
		        % Convert the numeric array to a table
		        VehicleData = array2table(Vehicle.Data, 'VariableNames', columnNames);

            else

                % Iterate Through Superheavy tau Values
                for f = 1: 1: length(SH.tau)

                    % Superheavy Slenderness Parameter
                    SHi.tau = SH.tau(f);

                    % [kg, m^2] Solve Superheavy TOGW and Planform Area
                    [y] = lsqnonlin(@(x) Solve_SH_OWE(C, MTV, SHi, SSi, x), x0_SH, [], [], options);

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

                    elseif 5000 < SSi.TOGW / 1000

                        % SH_TOGW = SSi.TOGW / 1000
                        % disp('3000 MTon < SS.TOGW')

                    else

                        % [int#] Creates Vehicle Counter
                        clc
						VehicleNo = VehicleNo + 1

                        % Viewing Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        % Save Converged Starship and Superheavy Data
                        Vehicle.Chart(VehicleNo, :) = [Wpay(a) / 1000,  v_sep(e), SSi.tau, SHi.tau, ...
                                                       SSi.TOGW / 1000, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW / 1000, SSi.mppl / 1000, SSi.WR, ... 
                                                       SHi.TOGW / 1000, SHi.Spln, SHi.Swet, SHi.OWEw, SHi.OWEv, SHi.OEW / 1000, SHi.mppl / 1000, SHi.WR];
                        
						% Puts data in to table thats easier to read
						% Define the table column names
						columnNames = {'Wpay (Ton)',    'v_sep',         'SS_tau',        'SH_tau', ...
           							   'SS_TOGW (Ton)', 'SS_Spln (m^2)', 'SS_Swet (m^2)', 'SS_OWEw (kg)', 'SS_OWEv (kg)', 'SS_OEW (Ton)', 'SS_mppl (Ton)', 'SS_WR' ...
           							   'SH_TOGW (Ton)', 'SH_Spln (m^2)', 'SH_Swet (m^2)', 'SH_OWEw (kg)', 'SH_OWEv (kg)', 'SH_OEW (Ton)', 'SH_mppl (Ton)', 'SH_WR'};
						
						% Convert the numeric array to a table
						VehicleChartTable = array2table(Vehicle.Chart, 'VariableNames', columnNames);
                        
                        % Data Saved ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        % Save Converged Starship and Superheavy Data
                        Vehicle.Data(VehicleNo, :) = [Wpay(a),   v_sep(e), SSi.tau,  SHi.tau, ...
                                                       SSi.TOGW, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW, SSi.mppl, ... 
                                                       SHi.TOGW, SHi.Spln, SHi.Swet, SHi.OWEw-SSi.OWEw, SHi.OWEv, SHi.OEW, SHi.mppl];
                        Vehicle.SS(VehicleNo) = SSi;
						Vehicle.SH(VehicleNo) = SHi;

						% Define the table column names
						columnNames = {'Wpay',    'v_sep',   'SS_tau',  'SH_tau', ...
           							   'SS_TOGW', 'SS_Spln', 'SS_Swet', 'SS_OWEw', 'SS_OWEv', 'SS_OEW', 'SS_mppl' ...
           							   'SH_TOGW', 'SH_Spln', 'SH_Swet', 'SH_OWEw', 'SH_OWEv', 'SH_OEW', 'SH_mppl'};

						% Convert the numeric array to a table
						VehicleData = array2table(Vehicle.Data, 'VariableNames', columnNames);

                    end
                end
            end
        end
    end
end

% Save To Data File
clear a columnNames e ERROR_SH ERROR_SS f i options SH SHi SS SSi tol x y
save('Data.mat');

%% Plots
clear all, load('Data.mat')
clc, close all

% Checks for Converged Vehicle
if VehicleNo == 0;
    
    % Print No Convergence
    fprintf('No Converged Vehicles\n')
    
else
    
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
    if length(Wpay) ~= 1
        C2 = VehicleData.Wpay;
    elseif length(v_sep) ~= 1
        C2 = VehicleData.v_sep;
    else
        P.Black_Lines = false;
    end
    
    % OEW vs Planform Area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Axis Labels
    P.x_Label  = 'Planform Area, Spln (m^2)';
    P.y_Label  = 'Operating Empty Weight, OEW (Tons)';

    % Plot Properties - Starship
    P.Title = 'Starship OEW vs Planform Area';
    P.x_Tick_I = 50;
    P.y_Tick_I = 10000 / 1000;      % [kg -> Ton]

    % [kg, m^2] Plot OEW vs Planform Area - Starship
    Plot_Spln_vs_OEW(VehicleData.SS_Spln, VehicleData.SS_OEW/1000, VehicleData.SS_tau, C2, VehicleNo, P);
    
    % Plot Properties - Superheavy
    P.Title = 'Superheavy OEW vs Planform Area';
    P.x_Tick_I = 100;
    P.y_Tick_I = 50000 / 1000;      % [kg -> Ton]

    % [kg, m^2] Plot OEW vs Planform Area - Superheavy
    if Converge_SH == true
        Plot_Spln_vs_OEW(VehicleData.SH_Spln, VehicleData.SH_OEW/1000, VehicleData.SH_tau, C2, VehicleNo, P);
    end

    % TOGW vs Planform Area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Axis Labels
    P.x_Label  = 'Planform Area, Spln (m^2)';
    P.y_Label  = 'Take Off Gross Weight, TOGW (Tons)';
    P.x_Tick_I = 50;
    P.y_Tick_I = 100000 / 1000;      % [kg -> Ton]

    % Plot Properties - Starship
    P.Title = 'Starship TOGW vs Planform Area';

    % [kg, m^2] Plot TOGW vs Planform Area - Starship
    Plot_Spln_vs_TOGW(VehicleData.SS_Spln, VehicleData.SS_TOGW/1000, VehicleData.SS_tau, C2, VehicleNo, P)

    % Plot Properties - Superheavy
    P.Title = 'Superheavy TOGW vs Planform Area';

    % [kg, m^2] Plot TOGW vs Planform Area - Superheavy
    if Converge_SH == true
        Plot_Spln_vs_TOGW(VehicleData.SH_Spln, VehicleData.SH_TOGW/1000, VehicleData.SH_tau, C2, VehicleNo, P)
    end

    % Wppl vs Planform Area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % % Axis Labels
    % P.x_Label  = 'Planform Area, Spln (m^2)';
    % P.y_Label  = 'Propellant Weight, Wppl (Tons)';
    % P.x_Tick_I = 50;
    % P.y_Tick_I = 100000 / 1000;      % [kg -> Ton]
    % 
    % % Plot Properties - Starship
    % P.Title = 'Starship Wppl vs Planform Area';
    % 
    % % [kg, m^2] Plot Wppl vs Planform Area - Starship
    % Plot_Spln_vs_Wppl(VehicleData.SS_Spln, VehicleData.SS_Wppl/1000, VehicleData.SS_tau, C2, VehicleNo, P)
    % 
    % % Plot Properties - Superheavy
    % P.Title = 'Superheavy Wppl vs Planform Area';
    % 
    % % [kg, m^2] Plot Wppl vs Planform Area - Superheavy
    % if Converge_SH == true
    %   Plot_Spln_vs_Wppl(VehicleData.SH_Spln, VehicleData.SH_Wppl/1000, VehicleData.SH_tau, C2, VehicleNo, P)
    % end
end

%% ~~~
%}
% Prints the simulation time on the command window.
fprintf('Program Complete! (%0.3f seconds)\n', toc);
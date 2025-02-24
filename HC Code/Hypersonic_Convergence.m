clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Constant Parameters
[C, SS, SH, FS] = Constant_Parameters();

%% Input Paramters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Create New Incriment Structure for Starship Superheavy and Full Stack
SSi = SS;   SHi = SH;   FSi = FS;   VehicleNo = 0;

%{
% Mission Trade Variables (MTV) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Payload Weight
%Wpay = [50: 25: 150] * 1000;
Wpay = 100 * 1000;

% [m/s] Separation Velocity
v_sep = [1400: 100: 2500];
%v_sep = 3000;

% Iterated Geometric Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Slenderness Parameter - Starship
SS.tau = transpose([0.16: 0.02: 0.26]);
%SS.tau = 0.23;

% Slenderness Parameter - Full Stack
%FS.tau = transpose([0.2: 0.05: 0.45]);
%SH.tau = SS.tau;
FS.tau = 0.48;
%FS.tau = 0.4;
%}

% 34 Converged Vehicles 2/23 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
% [MTon -> kg] Payload Weight
Wpay = [50: 25: 150] * 1000;

% [m/s] Separation Velocity
v_sep = 3000;

% Slenderness Parameter - Starship
SS.tau = transpose([0.18: 0.02: 0.3]);

% Slenderness Parameter - Full Stack
FS.tau = 0.45;
%}

% 70 Converged Vehicles 2/23 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% [MTon -> kg] Payload Weight
Wpay = 100 * 1000;

% [m/s] Separation Velocity
v_sep = [1500: 100: 2500];

% Slenderness Parameter - Starship
SS.tau = transpose([0.18: 0.02: 0.3]);

% Slenderness Parameter - Full Stack
FS.tau = 0.45;
%}

% Inital Guessed Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Takeoff Gross Weight - Starship
SS_TOGWi = 1700 * 1000;

% [m^2] Planform Area - Starship
SS_Splni = 550;

% [MTon -> kg] Takeoff Gross Weight - Full Stack
FS_TOGWi = 5100 * 1000;

% [m^2] Planform Area - Full Stack
FS_Splni = 1200;

%% The Meat and the Bones ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Initial Conditions
x0_SS = [SS_TOGWi; SS_Splni];
y0_FS = [FS_TOGWi; FS_Splni];

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

            % Slenderness Parameter - Starship
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

            else

                % Iterate Through Full Stack tau Values
                for f = 1: 1: length(FS.tau)

                    % Slenderness Parameter - Full Stack
                    FSi.tau = FS.tau(f);

                    % [kg, m^2] Solve Superheavy TOGW and Planform Area
                    [y] = lsqnonlin(@(y) Solve_FS_OWE(C, MTV, SSi, SHi, FSi, y), y0_FS, [], [], options);

                    % [kg, m^2] Deal Solved Output Vector
                    [FSi.TOGW, FSi.Spln] = deal(y(1), y(2));

                    % Calculate Superheavy Converged Parameters
                    [FSi] = Calculate_Full_Stack_Budget(C, MTV, SSi, SHi, FSi);

                    % Save Converged Data ~~~~~~~~~~~~~~~~~~~~~~~~~~

                    % Check SH ERROR
                    [ERROR_FS] = Solve_FS_OWE(C, MTV, SSi, SHi, FSi, y);
                    if ERROR_FS(1) > 0.001 || ERROR_FS(2) > 0.001

                        % ERROR_FS
                        % disp('FS FAIL')

                    elseif FSi.OEW < 10

                        FSi_OEW = FSi.OEW
                        disp('Bad FS Converge')

                    % elseif 5000 < FSi.TOGW / 1000
                    % 
                    %     FSi_TOGW = FSi.TOGW / 1000
                    %     disp('3000 MTon < FSi.TOGW')

                    else
                        
                        % Calculate Superheavy Parameters
                        SHi.TOGW = FSi.TOGW - SSi.TOGW;
                        SHi.Spln = FSi.Spln - SSi.Spln;
                        SHi.Swet = FSi.Swet - SSi.Swet;
                        SHi.OWEw = FSi.OWEw - SSi.OWEw;
                        SHi.OWEv = FSi.OWEv - SSi.OWEv;
                        SHi.OEW  = FSi.OEW  - SSi.OEW;
                        SHi.Wppl = FSi.Wppl - SSi.Wppl;
                        SHi.WR   = FSi.WR;
                        SHi.ff   = FSi.ff;

                        SSi.Vtot = SSi.tau * SSi.Spln^1.5;
                        FSi.Vtot = (FSi.tau*FSi.Spln^1.5) - SSi.Vtot;
                        SHi.Vtot = FSi.Vtot - SSi.Vtot;
                        SHi.Spln = FSi.Spln - SSi.Spln;
                        SHi.tau  = SHi.Vtot / SHi.Spln^1.5;

                        % [int#] Creates Vehicle Counter
                        clc
						VehicleNo = VehicleNo + 1

                        % Viewing Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        % Save Converged Starship and Superheavy Data
                        Vehicle.Chart(VehicleNo, :) = [Wpay(a) / 1000,  v_sep(e), SSi.tau,  SHi.tau,  FSi.tau, ...
                                                       SSi.TOGW / 1000, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW / 1000, SSi.Wppl / 1000, SSi.WR, SSi.ff, ... 
                                                       SHi.TOGW / 1000, SHi.Spln, SHi.Swet, SHi.OWEw, SHi.OWEv, SHi.OEW / 1000, SHi.Wppl / 1000, SHi.WR, SHi.ff, ... 
                                                       FSi.TOGW / 1000, FSi.Spln, FSi.Swet, FSi.OWEw, FSi.OWEv, FSi.OEW / 1000, FSi.Wppl / 1000, FSi.WR, FSi.ff];

						% Puts data in to table thats easier to read
						% Define the table column names
						columnNames = {'Wpay (Ton)',    'v_sep',         'SS_tau',        'SH_tau',       'FS_tau', ...
           							   'SS_TOGW (Ton)', 'SS_Spln (m^2)', 'SS_Swet (m^2)', 'SS_OWEw (kg)', 'SS_OWEv (kg)', 'SS_OEW (Ton)', 'SS_Wppl (Ton)', 'SS_WR', 'SS_ff',...
           							   'SH_TOGW (Ton)', 'SH_Spln (m^2)', 'SH_Swet (m^2)', 'SH_OWEw (kg)', 'SH_OWEv (kg)', 'SH_OEW (Ton)', 'SH_Wppl (Ton)', 'SH_WR', 'SH_ff',...
                                       'FS_TOGW (Ton)', 'FS_Spln (m^2)', 'FS_Swet (m^2)', 'FS_OWEw (kg)', 'FS_OWEv (kg)', 'FS_OEW (Ton)', 'FS_Wppl (Ton)', 'FS_WR', 'FS_ff'};

						% Convert the numeric array to a table
						VehicleChartTable = array2table(Vehicle.Chart, 'VariableNames', columnNames);

                        % Data Saved ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                        % Save Converged Starship and Superheavy Data
                        Vehicle.Data(VehicleNo, :) = [Wpay(a),  v_sep(e), SSi.tau,  SHi.tau,  FSi.tau, ...
                                                      SSi.TOGW, SSi.Spln, SSi.Swet, SSi.OWEw, SSi.OWEv, SSi.OEW, SSi.Wppl, SSi.WR, SSi.ff, ... 
                                                      SHi.TOGW, SHi.Spln, SHi.Swet, SHi.OWEw, SHi.OWEv, SHi.OEW, SHi.Wppl, SHi.WR, SHi.ff, ... 
                                                      FSi.TOGW, FSi.Spln, FSi.Swet, FSi.OWEw, FSi.OWEv, FSi.OEW, FSi.Wppl, FSi.WR, FSi.ff];
                        Vehicle.SS(VehicleNo) = SSi;
						Vehicle.SH(VehicleNo) = SHi;
                        Vehicle.FS(VehicleNo) = FSi;

						% Puts data in to table thats easier to read
						% Define the table column names
						columnNames = {'Wpay',    'v_sep',   'SS_tau',  'SH_tau',  'FS_tau', ...
           							   'SS_TOGW', 'SS_Spln', 'SS_Swet', 'SS_OWEw', 'SS_OWEv', 'SS_OEW', 'SS_Wppl', 'SS_WR', 'SS_ff', ...
           							   'SH_TOGW', 'SH_Spln', 'SH_Swet', 'SH_OWEw', 'SH_OWEv', 'SH_OEW', 'SH_Wppl', 'SH_WR', 'SH_ff', ...
                                       'FS_TOGW', 'FS_Spln', 'FS_Swet', 'FS_OWEw', 'FS_OWEv', 'FS_OEW', 'FS_Wppl', 'FS_WR', 'FS_ff'};

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
    Plot_Spln_vs_OEW(VehicleData.SH_Spln, VehicleData.SH_OEW/1000, VehicleData.SH_tau, C2, VehicleNo, P);

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
    Plot_Spln_vs_TOGW(VehicleData.SH_Spln, VehicleData.SH_TOGW/1000, VehicleData.SH_tau, C2, VehicleNo, P)
    
    % Wppl vs Planform Area ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %{
    % Axis Labels
    P.x_Label  = 'Planform Area, Spln (m^2)';
    P.y_Label  = 'Propellant Weight, Wppl (Tons)';
    P.x_Tick_I = 50;
    P.y_Tick_I = 100000 / 1000;      % [kg -> Ton]

    % Plot Properties - Starship
    P.Title = 'Starship Wppl vs Planform Area';

    % [kg, m^2] Plot Wppl vs Planform Area - Starship
    Plot_Spln_vs_Wppl(VehicleData.SS_Spln, VehicleData.SS_Wppl/1000, VehicleData.SS_tau, C2, VehicleNo, P)

    % Plot Properties - Superheavy
    P.Title = 'Superheavy Wppl vs Planform Area';

    % [kg, m^2] Plot Wppl vs Planform Area - Superheavy
    Plot_Spln_vs_Wppl(VehicleData.SH_Spln, VehicleData.SH_Wppl/1000, VehicleData.SH_tau, C2, VehicleNo, P)
    %}
end

%% ~~~
%}
% Prints the simulation time on the command window.
fprintf('Program Complete! (%0.3f seconds)\n', toc);
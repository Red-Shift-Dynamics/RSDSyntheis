clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Constant Parameters
[C, SS, SH] = Constant_Parameters();

%% Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Calculates Starship Weight and Volume Budgets
function [SS] = Calculate_Starship_Budget(C, MTV, SS)
    
    % Weight Ratio - Starship
    %[SS.WR] = Trajectory(MTV.hleo, SS.TOGW);
    [SS] = Trajectory_SS(MTV, SS);
    
    % Wetted Area to Planform Area Ratio - Starship
    %[SS.Kw] = Geometry(SS.tau, SS.Spln);
    [SS] = Geometry_SS(SS);
    
    % T/W at Sea Level - Starship
    %[SS.TW0] = Propulsion(SS.TOGW);
    [SS] = Propulsion_SS(SS);

    % [kg] Crew Weight
    Wcrew = C.fcrew * MTV.Ncrew;
    
    % [kg] Starship Operating Empty Weight (Dry Weight)
    SS.OEW = (SS.Istr*SS.Kw*SS.Spln + (SS.TW0)*SS.WR*(MTV.Wpay + Wcrew)/SS.E_TW + SS.Cun + MTV.Ncrew*(SS.fmnd + C.fcprv)) / ...
             (1/(1 + C.mua) - C.fsys - (SS.TW0)*SS.WR/SS.E_TW);
    
    % Weight and Vol Budgets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [kg] Starship Weight Budget
    SS.OWEw = SS.OEW + MTV.Wpay + Wcrew;
    
    % [kg] Starship Volume Budget
    SS.OWEv = (SS.tau*SS.Spln^1.5*(1 - SS.kvs - SS.kvv) - MTV.Ncrew*(C.vcprv + MTV.kcrew) - SS.Vun - MTV.Wpay/C.rho_pay) / ...
              ((SS.WR - 1)/SS.rho_ppl + SS.kve*(SS.TW0)*SS.WR);

    % Propellant Stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^3] Propellant Volume
    SS.Vppl = SS.OWEw*(SS.WR - 1) / SS.rho_ppl;
    
    % [kg] Propellant Weight
    SS.Wppl = SS.Vppl * SS.rho_ppl;

end

% Function to Calculate Error for Solver - Starship
function [ERROR] = Solve_SS_OWE(C, MTV, SS, x)

    % [kg, m^2] Assign Variables
    [SS.TOGW, SS.Spln] = deal(x(1), x(2));
    
    % Calculate Weight and Volume Budgets
    [SS] = Calculate_Starship_Budget(C, MTV, SS);
    
    % [kg] OWE ERROR
    OWE_ERROR = SS.OWEw - SS.OWEv;
    ERROR(1, 1) = abs(OWE_ERROR);
    
    % [kg] Calculate TOGW - Starship
    SS.TOGWnew = MTV.Wpay + SS.Wppl + SS.OEW;
    
    % [kg/m^2] TOGW ERROR
    TOGW_Spln_ERROR = (SS.TOGWnew - SS.TOGW)/SS.Spln;
    ERROR(2, 1) = abs(TOGW_Spln_ERROR);

end

% Calculates Superheavy Weight and Volume Budgets
function [SH] = Calculate_Superheavy_Budget(C, MTV, SH, SS)
    
    % Weight Ratio - Superheavy
    % [SH.WR] = Trajectory(MTV.v_sep, SH.TOGW, SS.TOGW)
    [SH] = Trajectory_SH(MTV, SH, SS);
    
    % Wetted Area to Planform Area Ratio - Superheavy
    % [SH.Kw] = Geometry(SH.tau, SH.Spln, SS.Swet)
    [SH] = Geometry_SH(SH, SS);
    
    % T/W at Sea Level - Superheavy
    % [SH.TW0] = Propulsion(SH.TOGW)
    [SH] = Propulsion_SH(SH);
    
    % [kg] Superheavy Operating Empty Weight (Dry Weight)
    SH.OEW = (SH.Istr*SH.Kw*SH.Spln + SH.Cun + C.ksup*(SS.TOGW)) / ...
             (1/(1 + C.mua) - C.fsys - (SH.TW0)*SH.WR/SH.E_TW);
    
    % Weight and Vol Budgets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [kg] Superheavy Weight Budget
    SH.OWEw = SH.OEW;
    
    % [kg] Superheavy Volume Budget
    SH.OWEv = (SH.tau*SH.Spln^1.5*(1 - SH.kvs - SH.kvv) - SH.Vun - SS.TOGW*(SS.WR - 1)/SS.rho_ppl) / ...
              ((SH.WR - 1)/SH.rho_ppl + SH.kve*(SH.TW0)*SH.WR);

    % Propellant Stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^3] Propellant Volume
    SH.Vppl = SH.OWEw*(SH.WR - 1) / SH.rho_ppl;
    
    % [kg] Propellant Weight
    SH.Wppl = SH.Vppl * SH.rho_ppl;

end

% Function to Calculate Error for Solver - Superheavy
function [ERROR] = Solve_SH_OWE(C, MTV, SH, SS, x)

    % [kg, m^2] Assign Variables
    [SH.TOGW, SH.Spln] = deal(x(1), x(2));
    
    % Calculate Weight and Volume Budgets
    [SH] = Calculate_Superheavy_Budget(C, MTV, SH, SS);
    
    % [kg] OWE ERROR
    OWE_ERROR = SH.OWEw - SH.OWEv;
    ERROR(1, 1) = abs(OWE_ERROR);
    
    % [kg] Calculate TOGW - Superheavy
    SH.TOGWnew = SH.Wppl + SH.OEW;
    
    % [kg/m^2] TOGW ERROR
    TOGW_Spln_ERROR = (SH.TOGWnew - SH.TOGW)/SH.Spln;
    ERROR(2, 1) = abs(TOGW_Spln_ERROR);

end

%% Input Paramters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Create New Incriment Structure for Starship and Superheavy
SSi = SS;   SHi = SH;

% Mission Trade Variables (MTV) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Payload Weight
Wpay = [100: 20: 150] * 1000;
%Wpay = 100;

% [#int] Crew Members
%Ncrew = [1: 1: 15];
Ncrew = 0;

% [m^3/Person] Crew Specific Volume
%kcrew = [10: 1: 14];
kcrew = 0;

% [km] Low Earth Parking Orbit
%hleo = [200: 50: 300];
hleo = 200;

% [m/s] Separation Velocity
%v_sep = [100: 20: 200];
v_sep = 100;
 
% Iterated Geometric Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Slenderness Parameter - Starship
SS.tau = transpose([0.1: 0.1: 0.5]);

% Slenderness Parameter - Superheavy
SH.tau = transpose([0.1: 0.1: 0.6]);

% Inital Guessed Values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [MTon -> kg] Takeoff Gross Weight - Starship
SS_TOGWi = 5000 * 1000;

% [m^2] Planform Area - Starship
SS_Splni = 500;

% [MTon -> kg] Takeoff Gross Weight - Superheavy
SH_TOGWi = 3000 * 1000;

% [m^2] Planform Area - Superheavy
SH_Splni = 100;

%% The Meat and the Bones ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Initial Conditions
x0 = [SS_TOGWi; SS_Splni];

% Set Optimization Options
tol = 1e-5;                                % Solver Tolerance           
options = optimoptions('lsqnonlin', ...
                'display','off', ...        % Disable Text Displayed in Console
                'TolFun', tol, ...          % Function Tolerance
                  'TolX', tol);             % Solution Tolerance
VehicleNo = 0;
% Iterate Through Payload Weight
for a = 1: 1: length(Wpay)

    % Iterate Through LEO
    for d = 1: 1: length(hleo)

        % Iterate Through Separation Velocity
        for e = 1: 1: length(v_sep)

            % Iterate Through Starship tau Values
            for i = 1: 1: length(SS.tau)
                
                % Mission Parameters
                MTV.Wpay  = Wpay(a);
                MTV.Ncrew = Ncrew;
                MTV.kcrew = kcrew;
                MTV.hleo  = hleo(d);
                MTV.v_sep = v_sep(e);
                
                % Starship ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                % Starship Slenderness Parameter
                SSi.tau = SS.tau(i);

                % [kg, m^2] Solve Starship TOGW and Planform Area
                [x] = lsqnonlin(@(x) Solve_SS_OWE(C, MTV, SSi, x), x0, [], [], options);
                
                % [kg, m^2] Deal Solved Output Vector
                [SSi.TOGW, SSi.Spln] = deal(x(1), x(2));
                 
                % Calculate Starship Converged Parameters
                [SSi] = Calculate_Starship_Budget(C, MTV, SSi);
                
                % Check SS ERROR
                [ERROR_SS] = Solve_SS_OWE(C, MTV, SSi, x);
                if ERROR_SS(1) > 0.001 || ERROR_SS(2) > 0.001
                    ERROR_SS
                    disp('SS FAIL') 

                else

                    % Iterate Through Superheavy tau Values
                    for f = 1: 1: length(SH.tau)
                        
                        % Superheavy Slenderness Parameter
                        SHi.tau = SH.tau(f);
    
                        % [kg, m^2] Solve Superheavy TOGW and Planform Area
                        [y] = lsqnonlin(@(x) Solve_SH_OWE(C, MTV, SHi, SSi, x), x0, [], [], options);
                        
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

                        else

                            % [int#] Creates Vehicle Counter
							VehicleNo = VehicleNo + 1;
                            
                            % Save Converged Starship and Superheavy Data
							Vehicle.Chart(VehicleNo, :) = [Wpay(a), hleo(d), v_sep(e), SSi.tau, SHi.tau, SSi.TOGW, SSi.Spln, SSi.WR, SSi.Swet,SSi.Kw,SSi.TW0, SSi.OEW, SSi.OWEw, SSi.OWEv, SHi.TOGW, SHi.Spln, SHi.WR, SHi.Swet,SHi.Kw,SHi.TW0, SHi.OEW, SHi.OWEw, SHi.OWEv]	;
							Vehicle.SS(VehicleNo) = SSi;
							Vehicle.SH(VehicleNo) = SHi;

							% Puts data in to table thats easier to read
							% Define the table column names
							columnNames = {'Wpay', 'hleo', 'v_sep', 'SSi_tau', 'SHi_tau', ...
               							'SSi_TOGW', 'SSi_Spln', 'SSi_WR', 'SSi_Swet', 'SSi_Kw', ...
               							'SSi_TW0', 'SSi_OEW', 'SSi_OWEw', 'SSi_OWEv', ...
               							'SHi_TOGW', 'SHi_Spln', 'SHi_WR', 'SHi_Swet', 'SHi_Kw', ...
               							'SHi_TW0', 'SHi_OEW', 'SHi_OWEw', 'SHi_OWEv'};
							
							% Convert the numeric array to a table
							VehicleChartTable = array2table(Vehicle.Chart, 'VariableNames', columnNames);

                        end
                    end
                end
            end
        end
    end
end

%% Plots

% Plot Properties
P.Color = 'Black';

% [kg, m^2] Plot OEW vs Planform Area
Plot_Spln_vs_OEW(VehicleChartTable.SSi_Spln, VehicleChartTable.SSi_OEW, P);

%% ~~~
%}
% Prints the simulation time on the command window.
fprintf('Program Complete! (%0.3f seconds)\n', toc);


% Check Calculations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
% Interested Mission Trade Matrix Increments
a = 2; b = 3; c = 4; d = 1;

% Interested tau Value
i = 7;

% Mission Parameters
MTV.Wpay  = Wpay(a);
MTV.Ncrew = Ncrew(b);
MTV.kcrew = kcrew(c);
MTV.hleo  = hleo(d);

% Starship Slenderness Parameter
SSi.tau = SS.tau(i);

% [kg, m^2] Deal Solved Output Vector
SSi.TOGW = Data.Wpay(a).Ncrew(b).kcrew(c).hleo(d).SS.TOGW(i);
SSi.Spln = Data.Wpay(a).Ncrew(b).kcrew(c).hleo(d).SS.Spln(i);

% Calculate Starship Converged Parameters
[SSval] = Calculate_Starship_Budget(C, MTV, SSi)
%}

                        % % SSi Output Parameters to Main Starship Structure
                        % SS.TOGW(i, :) = SSi.TOGW;       % [kg]  TOGW                - Starship
                        % SS.Spln(i, :) = SSi.Spln;       % [m^2] Planform Area       - Starship
                        % SS.WR(i, :)   = SSi.WR;         %       Weight Ratio        - Starship
                        % SS.Kw(i, :)   = SSi.Kw;         %       Swet to Spln Ratio  - Starship
                        % SS.TW0(i, :)  = SSi.TW0;        %       T/W at Sea Level    - Starship
                        % SS.OEW(i, :)  = SSi.OEW;        % [kg]  Operating Empty Weight (Dry Weight) - Starship 
                        % SS.OWEw(i, :) = SSi.OWEw;       % [kg]  Weight Budget - Starship 
                        % SS.OWEv(i, :) = SSi.OWEv;       % [kg]  Volume Budget - Starship 
                        % SS.Vppl(i, :) = SSi.Vppl;       % [m^3] Propellant Volume - Starship 
                        % SS.Wppl(i, :) = SSi.Wppl;       % [kg]  Propellant Weight - Starship 


                            % % SHi Output Parameters to Main Superheavy Structure
                            % SH.TOGW(f, :) = SHi.TOGW;       % [kg]  TOGW                - Superheavy
                            % SH.Spln(f, :) = SHi.Spln;       % [m^2] Planform Area       - Superheavy
                            % SH.WR(f, :)   = SHi.WR;         %       Weight Ratio        - Superheavy
                            % SH.Kw(f, :)   = SHi.Kw;         %       Swet to Spln Ratio  - Superheavy
                            % SH.TW0(f, :)  = SHi.TW0;        %       T/W at Sea Level    - Superheavy
                            % SH.OEW(f, :)  = SHi.OEW;        % [kg]  Operating Empty Weight (Dry Weight) - Superheavy 
                            % SH.OWEw(f, :) = SHi.OWEw;       % [kg]  Weight Budget - Superheavy 
                            % SH.OWEv(f, :) = SHi.OWEv;       % [kg]  Volume Budget - Superheavy 
                            % SH.Vppl(f, :) = SHi.Vppl;       % [m^3] Propellant Volume - Superheavy 
                            % SH.Wppl(f, :) = SHi.Wppl;       % [kg]  Propellant Weight - Superheavy 

%}
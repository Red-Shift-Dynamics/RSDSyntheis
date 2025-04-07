clear all, clc, close all, format compact, format longG, tic;
%% Inputs ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m] Diameter and Radius
FS.D = 9;
% FS.D = NaN;

% [m] Nose Cone Height - Starship
SS.H_Cone = 13.65;
% SS.H_Cone = NaN;

% [m] Fuselage Height - Starship
% SS.H_Fuse = 36.35;
% SS.H_Fuse = 50;
SS.H_Fuse = 35.3263592717875;   % 4th Conv Sol - D = 9 m, No Flaps
% SS.H_Fuse = 34.64546562802;     % 4th Conv Sol - D = 9 m, Wtih Flaps

% [m] Fuselage Height - Superheavy
% SH.H_Fuse = 66.5;
SH.H_Fuse = 68.222689847986;    % 4th Converged Solution with D = 9 m
% SH.H_Fuse = NaN;

%
% [m] Fore and Aft Flaps Span - Starship
SS.b_FF = 4.21;
SS.b_AF = 4.30;

% [m] Fore and Aft Mean Aero Cord - Starship
SS.cbar_FF = 5.57;
SS.cbar_AF = 4.05;

% [m] Fore and Aft Flaps Thickness - Starship
SS.t_FF = 0.53;
SS.t_AF = 0.53;
%}

%{
% [m] Fore and Aft Flaps Span - Starship
SS.b_FF = 0;
SS.b_AF = 0;

% [m] Fore and Aft Mean Aero Cord - Starship
SS.cbar_FF = 0;
SS.cbar_AF = 0;

% [m] Fore and Aft Flaps Thickness - Starship
SS.t_FF = 0;
SS.t_AF = 0;
%}

% Target Values (Current Block 2 Starship) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% TV.SS.Spln = 403.93125;
% TV.SS.Swet = 1278.04238089983;
% TV.SS.V    = 2707.20320938127;
% 
% TV.SH.Spln = 598.5;
% TV.SH.Swet = 1880.24320317349;
% TV.SH.V    = 4230.54720714035;
% 
% TV.FS.Spln = TV.SS.Spln + TV.SH.Spln;
% TV.FS.Swet = TV.SS.Swet + TV.SH.Swet;
% TV.FS.V    = TV.SS.V    + TV.SH.V;

% TV.SS.tau = TV.SS.V / TV.SS.Spln^1.5;
% TV.FS.tau = TV.FS.V / TV.FS.Spln^1.5;

% Target Values (4th Converged Solution) ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% TV.SS.tau = 0.17;
TV.SS.V = 2642.082;

% TV.SH.tau = 0.30;
TV.SH.V = 4340.140;

% TV.FS.tau = 0.16;

% What to Converge to? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% TV.Converge = 'tau';
TV.Converge = 'V';

%% Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Calculate Starship Geometry
function [SS] = Calculate_SS_Geo(SS, FS)

    % Nose Cone ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Nose Cone Equation - Starship
    syms x
    n = 0.6;
    SS.Cone.f(x)  = FS.D/2 * (x / SS.H_Cone)^n;
    SS.Cone.df(x) = diff(SS.Cone.f, x);
    
    % [m^2] Cone - Planform Area
    SS.Spln.Cone = 2 * double(int(SS.Cone.f(x), x, 0, SS.H_Cone));
    
    % [m^2] Cone - Wetted Area
    SS.Swet.Cone = 2*pi * double(int([SS.Cone.f(x)*sqrt(1 + (SS.Cone.df(x))^2)], x, 0, SS.H_Cone));
    
    % [m^3] Cone - Volume
    SS.V.Cone = pi * double(int([(SS.Cone.f(x))^2], x, 0, SS.H_Cone));

    % Fuselage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [m^2] Fuselage - Starship - Planfrom Area
    SS.Spln.Fuse = FS.D * SS.H_Fuse;
    
    % [m^2] Fuselage - Starship - Wetted Area
    SS.Swet.Fuse = pi * FS.D * SS.H_Fuse;
    
    % [m^3] Fuselage - Starship - Volume
    SS.V.Fuse = pi * (FS.D/2)^2 * SS.H_Fuse;

    % Flaps ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [m^2] Fore Flap - Planform Area
    SS.Spln.FF = SS.b_FF * SS.cbar_FF;
    
    % [m^2] Fore Flap - Wetted Area
    SS.Swet.FF = 2*(SS.Spln.FF + SS.b_FF*SS.t_FF);
    
    % [m^3] Fore Flap - Volume
    SS.V.FF = SS.t_FF * SS.Spln.FF;
    
    % [m^2] Aft Flap - Planform Area
    SS.Spln.AF = SS.b_AF * SS.cbar_AF;
    
    % [m^2] Aft Flap - Wetted Area
    SS.Swet.AF = 2*(SS.Spln.AF + SS.b_AF*SS.t_AF);
    
    % [m^3] Aft Flap - Volume
    SS.V.AF = SS.t_AF * SS.Spln.AF;
    
    % [m^2] Fore and Aft Flaps - Planform Area
    SS.Spln.Flaps = 2*(SS.Spln.FF + SS.Spln.AF);
    
    % [m^2] Fore and Aft Flaps - Wetted Area
    SS.Swet.Flaps = 2*(SS.Swet.FF + SS.Swet.AF);
    
    % [m^3] Fore and Aft Flaps - Volume
    SS.V.Flaps = 2*(SS.V.FF + SS.V.AF);

    % Totals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^2] Starship - Planform Area
    SS.Spln.tot = SS.Spln.Cone + SS.Spln.Fuse + SS.Spln.Flaps;
    
    % [m^2] Starship - Wetted Area
    SS.Swet.tot = SS.Swet.Cone + SS.Swet.Fuse + SS.Swet.Flaps;
    
    % [m^3] Starship - Volume
    SS.V.tot = SS.V.Cone + SS.V.Fuse + SS.V.Flaps;

    % Starship Slenderness
    SS.tau = SS.V.tot / SS.Spln.tot^1.5;

end

% Calculate Superheavy Geometry
function [SH] = Calculate_SH_Geo(SH, FS)

    % Fuselage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^2] Fuselage - Superheavy - Planfrom Area
    SH.Spln.Fuse = FS.D * SH.H_Fuse;
    
    % [m^2] Fuselage - Superheavy - Wetted Area
    SH.Swet.Fuse = pi * FS.D * SH.H_Fuse;
    
    % [m^3] Fuselage - Superheavy - Volume
    SH.V.Fuse = pi * (FS.D/2)^2 * SH.H_Fuse;

    % Grid Fins ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [m^2] Grid fin - Planform Area
    SH.Spln.GF = 0;
    
    % [m^2] Grid fin - Wetted Area
    SH.Swet.GF = 0;
    
    % [m^3] Grid fin - Volume
    SH.V.GF = 0;

    % Totals ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^2] Superheavy - Planform Area
    SH.Spln.tot = SH.Spln.Fuse + SH.Spln.GF;

    % [m^2] Superheavy - Wetted Area
    SH.Swet.tot = SH.Swet.Fuse + SH.Swet.GF;
    
    % [m^3] Superheavy - Volume
    SH.V.tot = SH.V.Fuse + SH.V.GF;

    % Superheavy Slenderness
    SH.tau = SH.V.tot / SH.Spln.tot^1.5;

end

% Calculate Full Stack Geometry
function [SS, SH, FS] = Calculate_Numbers(SS, SH, FS)

    % Calculate Stages Geometry ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Calculate Starship Geometry
    [SS] = Calculate_SS_Geo(SS, FS);

    % Calculate Superheavy Geometry
    [SH] = Calculate_SH_Geo(SH, FS);

    % Full Stack ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [m^2] Full Stack - Planform Area
    FS.Spln = SS.Spln.tot + SH.Spln.tot;
    
    % [m^2] Full Stack - Wetted Area
    FS.Swet = SS.Swet.tot + SH.Swet.tot;
    
    % [m^3] Full Stack - Volume
    FS.V = SS.V.tot + SH.V.tot;

    % Full Stack Slenderness
    FS.tau = FS.V / FS.Spln^1.5;

end

% Solve Starship Geometry
function [ERROR_SS] = Solve_SS(SS_Var, TV, SS, FS)

    % Check Variable Missing
    if isnan(SS.H_Fuse) == 1
        SS.H_Fuse = SS_Var;
    elseif isnan(SS.H_Cone) == 1
        SS.H_Cone = SS_Var;
    else
        error('No SS NaN Variables')
    end
    
    % Calculate Starship Geometry
    [SS] = Calculate_SS_Geo(SS, FS);

    % Check SS Error
    if TV.Converge == 'tau'
        ERROR_SS = TV.SS.tau - (SS.V.tot/SS.Spln.tot^1.5);
    elseif TV.Converge == 'V'
        ERROR_SS = TV.SS.V - SS.V.tot;
    else
        error('Converge SS what?')
    end

end

% Solve Superheavy Geometry
function [ERROR_SH] = Solve_SH(SH_Var, TV, SH, FS)

    % Check Variable Missing
    if isnan(SH.H_Fuse) == 1
        SH.H_Fuse = SH_Var;
    else
        error('No SH NaN Variables')
    end
    
    % Calculate Starship Geometry
    [SH] = Calculate_SH_Geo(SH, FS);

    % Check SH Error
    if TV.Converge == 'tau'
        ERROR_SH = TV.SH.tau - (SH.V.tot/SH.Spln.tot^1.5);
    elseif TV.Converge == 'V'
        ERROR_SH = TV.SH.V - SH.V.tot;
    else
        error('Converge SH what?')
    end
    
end

% Solve Full Stack Geometry
function [ERROR_FS] = Solve_FS(FS_Var, TV, SS, SH, FS)
    
    % Check Variable Missing
    if isnan(FS.D) == 1
        FS.D = FS_Var;
    else
        error('No FS NaN Variables')
    end
    
    % Calculate Geometry
    [SS, SH, FS] = Calculate_Numbers(SS, SH, FS);
    
    % Check FS Error
    if TV.Converge == 'tau'
        ERROR_FS = TV.FS.tau - (FS.V/FS.Spln^1.5);
    elseif TV.Converge == 'V'
        ERROR_FS = TV.FS.V - FS.V;
    else
        error('Converge FS what?')
    end

end

%% Calculation ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Set Optimization Options
tol   = 1e-10;                                      % Solver Tolerance  
I_Max = 500;                                        % Max Iterations
options = optimoptions('fsolve', ...
                'display','off', ...                % Disable Text Displayed in Console
                  'TolX', tol, ...                  % Solution Tolerance
                'TolFun', tol, ...                  % Function Tolerance
                'MaxIterations', I_Max, ...         % Max Number of Iterations
                'MaxFunctionEvaluations', 2*I_Max); % Max Function Evaluations

% Calculate Numbers
Var_i = 10;

% Check Variable Missing
if isnan(SS.H_Cone) == 1
    SS.H_Cone = fsolve(@(SS_Var) Solve_SS(SS_Var, TV, SS, FS), Var_i, options);
end

if isnan(SS.H_Fuse) == 1
    SS.H_Fuse = fsolve(@(SS_Var) Solve_SS(SS_Var, TV, SS, FS), Var_i, options);
end

if isnan(SH.H_Fuse) == 1
    SH.H_Fuse = fsolve(@(SH_Var) Solve_SH(SH_Var, TV, SH, FS), Var_i, options);
end

if isnan(FS.D) == 1
    FS.D = fsolve(@(FS_Var) Solve_FS(FS_Var, TV, SS, SH, FS), Var_i, options);
end

% Recalculate Geometry
[SS, SH, FS] = Calculate_Numbers(SS, SH, FS)
fprintf('\nSS.Spln.tot \n\t%f', SS.Spln.tot);
fprintf('\nSS.V.tot \n\t%f',    SS.V.tot);
fprintf('\nSH.Spln.tot \n\t%f', SH.Spln.tot);
fprintf('\nSH.V.tot \n\t%f',    SH.V.tot);

% Print Simulation Time
fprintf('\n\nProgram Complete %0.3fs\n\n', toc);

%% ~~~
%}
%% Trajectory Analysis - Superheavy
% [SS.WR] = Trajectory_SH(MTV.Vsep, SH.TOGW, SS.TOGW)
function [SH] = Trajectory_SH(MTV, SH, SS)
    
    % [kg] Propellant Weight - Starship
    SH.Wppl = 1000 * MTV.v_sep;
    
    % Weight Ratio - Starship
    SH.WR = SH.TOGW/(SH.TOGW - SH.Wppl);

    % % [kg] TOGW - Superheavy
    % TOGW1 = SH.TOGW;
    % 
    % % [kg] TOGW - Starship
    % TOGW2 = SS.TOGW;
    % 
    % % [m/s] Separation Velocity
    % Vsep = MTV.v_sep;
    % 
    % Isp = 500;      % [s]
    % tb = 10;        % [s]
    % 
    % % Weight Ratio - Starship
    % SH.WR = WR(TOGW1, TOGW2, Isp, tb, Vsep);

end

%% ~~~
%}
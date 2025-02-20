%% Trajectory Analysis - Superheavy
% [SS.WR] = Trajectory(MTV.Vsep, SH.TOGW, SS.TOGW)
function [SH] = Trajectory(MTV, SH, SS)
    
    % [kg] Propellant Weight - Starship
    SH.Wppl = 1000 * MTV.v_sep;
    
    % [m/s] Separation Velocity
    Vsep = MTV.v_sep;

    % Weight Ratio - Starship
    SH.WR = WR(TOGW1, TOGW2, Isp, tb, Vsep);

end

%% ~~~
%}
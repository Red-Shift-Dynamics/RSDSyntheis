%% Trajectory Analysis - Superheavy
% [SS.WR] = Trajectory(MTV.v_sep, SH.TOGW, SS.TOGW)
function [SH] = Trajectory(MTV, SH, SS)
    
    % [kg] Propellant Weight - Starship
    SH.Wppl = 1000 * MTV.v_sep;

    % Weight Ratio - Starship
    SH.WR = SH.TOGW/(SH.TOGW - SH.Wppl);
    
end

%% ~~~
%}
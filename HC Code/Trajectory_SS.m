%% Trajectory Analysis - Starship
%[SS.WR] = Trajectory(MTV.Vsep, SS.TOGW)
function [SS] = Trajectory_SS(MTV, SS)
    
    % [kg] Propellant Weight - Starship
    SS.Wppl = 1000 * MTV.hleo;

    % Weight Ratio - Starship
    SS.WR = SS.TOGW/(SS.TOGW - SS.Wppl);
    
end

%% ~~~
%}
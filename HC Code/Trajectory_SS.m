%% Trajectory Analysis - Starship
%[SS.WR] = Trajectory(MTV.hleo, SS.TOGW)
function [SS] = Trajectory(MTV, SS)
    
    % [kg] Propellant Weight - Starship
    SS.Wppl = 1000 * MTV.hleo;

    % Weight Ratio - Starship
    SS.WR = SS.TOGW/(SS.TOGW - SS.Wppl);
    
end

%% ~~~
%}
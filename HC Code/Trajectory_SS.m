%% Trajectory Analysis - Starship
%[SS.WR] = Trajectory(MTV.Vsep, SS.TOGW)
function [SS] = Trajectory_SS(MTV, SS)
    
    % % [kg] Propellant Weight - Starship
    % SS.Wppl = 1000 * MTV.hleo;
    
    % [kg] Starship TOGW;
    TOGW2 = SS.TOGW;

    Isp = 500;      % [s]
    tb = 10;        % [s]

    % [m/s] Separation Velocity
    Vsep = MTV.v_sep;

    % Weight Ratio - Starship
    SS.WR = WR(~, TOGW2, Isp, tb, Vsep);
    
end

%% ~~~
%}
%% T/W at Sea Level - Starship
function [SS] = Propulsion_SS(SS)
    
    % [kg] Sea Level Thrust - Starship
    SS.T0 = SS.ET0 * SS.N_eng;

    % Sea Level Thrust to Weight Ratio - Starship
    SS.TW0 = SS.T0 / SS.TOGW;

end

%% ~~~
%}
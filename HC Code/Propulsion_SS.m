%% T/W at Sea Level - Starship
%[SS.TW0] = Propulsion(SS.TOGW)
function [SS] = Propulsion(SS)
    
    % [int#] Engines - Starship
    SS.N_eng = 6;

    % [MTon -> kg] Sea Level Thrust - Starship
    SS.T0 = 258 * 1000 * SS.N_eng;

    % Sea Level Thrust to Weight Ratio - Starship
    SS.TW0 = SS.T0 / SS.TOGW;

end

%% ~~~
%}
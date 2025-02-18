%% T/W at Sea Level - Starship
%[SS.TW0] = Propulsion(SS.TOGW)
function [SS] = Propulsion(SS)
    
    % [MTon -> kg] Sea Level Thrust
    SS.T0 = 1000000;

    % Sea Level Thrust to Weight Ratio - Starship
    SS.TW0 = SS.T0 / SS.TOGW;

end

%% ~~~
%}
%% T/W at Sea Level - Starship
% [SH.TW0] = Propulsion(SH.TOGW)
function [SH] = Propulsion(SH)
    
    % [MTon -> kg] Sea Level Thrust
    SH.T0 = 100000000;

    % Sea Level Thrust to Weight Ratio - Starship
    SH.TW0 = SH.T0 / SH.TOGW;

end

%% ~~~
%}
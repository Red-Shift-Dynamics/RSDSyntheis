%% T/W at Sea Level - Superheavy
% [SH.TW0] = Propulsion(SH.TOGW)
function [SH] = Propulsion(SH)
    
    % [int#] Engines - Superheavy
    SH.N_eng = 33;

    % [MTon -> kg] Sea Level Thrust - Superheavy
    SH.T0 = 230 * 1000 * SH.N_eng * 100000000;

    % Sea Level Thrust to Weight Ratio - Superheavy
    SH.TW0 = SH.T0 / SH.TOGW;

end

%% ~~~
%}
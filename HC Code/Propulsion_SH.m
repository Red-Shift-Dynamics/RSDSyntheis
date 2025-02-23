%% T/W at Sea Level - Superheavy
% [SH.TW0] = Propulsion(SH.TOGW)
function [SH] = Propulsion(SH)
    
    % [kg] Sea Level Thrust - Starship
    SH.T0 = SH.ET0 * SH.N_eng;

    % Sea Level Thrust to Weight Ratio - Starship
    SH.TW0 = SH.T0 / SH.TOGW;

end

%% ~~~
%}
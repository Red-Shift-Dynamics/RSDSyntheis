%% T/W at Sea Level - Superheavy
% [SH.TW0] = Propulsion(SH.TOGW)
function [SH] = Propulsion_SH(SH, SS)
    
    % [kg] Sea Level Thrust - Superheavy
    SH.T0 = SH.ET0 * SH.N_eng;

    % Sea Level Thrust to Weight Ratio - Superheavy
    SH.TW0 = SH.T0 / (SH.TOGW + SS.TOGW);

end

%% ~~~
%}
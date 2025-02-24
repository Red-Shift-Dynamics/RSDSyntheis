%% T/W at Sea Level - Full Stack
% [FS.TW0] = Propulsion(FS.TOGW)
function [FS] = Propulsion_SH(SS, SH, FS)
    
    % [kg] Sea Level Thrust - Superheavy
    SH.T0 = SH.ET0 * SH.N_eng;

    % Sea Level Thrust to Weight Ratio - Superheavy
    % FS.TW0 = SH.T0 / (FS.TOGW + SS.TOGW);
    FS.TW0 = SH.T0 / FS.TOGW;

end

%% ~~~
%}
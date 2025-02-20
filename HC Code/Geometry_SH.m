%% Wetted Area to Planform Area Ratio Calculator - Superheavy
% [SH.Kw] = Geometry(SH.tau, SH.Spln, SS.Swet)
function [SH] = Geometry_SH(SH, SS)
    
    % [m^2] Wetted Area - Starship
    %SH.Swet = sqrt(SH.tau) * 10000;

    % Wetted to Planform Area Ratio - Starship
    %SH.Kw = (SH.Swet + SS.Swet)/SH.Spln;
    SH.Kw = -56.368 * (SH.tau^2) + 23.374 * SH.tau + 1.0887;

end

%% ~~~
%}
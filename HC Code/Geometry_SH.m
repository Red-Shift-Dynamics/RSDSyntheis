%% Wetted Area to Planform Area Ratio Calculator - Superheavy
% [SH.Kw, SH.Swet] = Geometry(SH.tau, SH.Spln, SS.Swet)
function [SH] = Geometry_SH(SH, SS)

    % Wetted to Planform Area Ratio - Superheavy
    %SH.Kw = (SH.Swet + SS.Swet)/SH.Spln;
    SH.Kw = -56.368 * (SH.tau^2) + 23.374 * SH.tau + 1.0887;

    % [m^2] Wetted Area - Superheavy
    SH.Swet = (SH.Kw * SH.Spln) - SS.Swet;

end

%% ~~~
%}
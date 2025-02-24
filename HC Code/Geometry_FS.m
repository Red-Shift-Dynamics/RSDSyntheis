%% Wetted Area to Planform Area Ratio Calculator - Superheavy
% [FS.Kw, FS.Swet] = Geometry(FS.tau, FS.Spln)
function [FS] = Geometry_SH(FS)

    % Wetted to Planform Area Ratio - Superheavy
    %SH.Kw = (SH.Swet + SS.Swet)/SH.Spln;
    %SH.Kw = -56.368 * (SH.tau^2) + 23.374 * SH.tau + 1.0887;
    FS.Kw = pi;

    % [m^2] Wetted Area - Full Stack
    FS.Swet = FS.Kw * FS.Spln;

end

%% ~~~
%}
%% Wetted Area to Planform Area Ratio Calculator - Superheavy
% [SH.Kw, SH.Swet] = Geometry(SH.tau, SH.Spln, SS.Swet)
function [SH] = Geometry_SH(SH, SS)

    % Wetted to Planform Area Ratio - Superheavy
    %SH.Kw = -56.368 * (SH.tau^2) + 23.374 * SH.tau + 1.0887;
    %SH.Kw = pi;
    SH.Kw = 27.337*SH.tau^2 - 8.068*SH.tau + 3.7794;        % Updated - 2/25

    % [m^2] Wetted Area - Superheavy
    SH.Swet = SH.Kw * SH.Spln;

end

%% ~~~
%}
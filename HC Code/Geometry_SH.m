%% Wetted Area to Planform Area Ratio Calculator - Superheavy
% [SH.Kw] = Geometry(SH.tau, SH.Spln, SS.Swet)
function [SH] = Geometry(SH, SS)
    
    % [m^2] Wetted Area - Starship
    SH.Swet = sqrt(SH.tau) * 10000;

    % Wetted to Planform Area Ratio - Starship
    SH.Kw = (SH.Swet + SS.Swet)/SH.Spln;

end

%% ~~~
%}
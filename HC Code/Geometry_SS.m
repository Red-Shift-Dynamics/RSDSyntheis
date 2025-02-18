%% Wetted Area to Planform Area Ratio Calculator
%[SS.Kw] = Geometry(SS.tau, SS.Spln)
function [SS] = Geometry(SS)
    
    % [m^2] Wetted Area - Starship
    SS.Swet = sqrt(SS.tau) * 10000;

    % Wetted to Planform Area Ratio - Starship
    SS.Kw = SS.Swet/SS.Spln;

end

%% ~~~
%}
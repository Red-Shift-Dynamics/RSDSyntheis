%% Wetted Area to Planform Area Ratio - Starship
%[SS.Kw] = Geometry(SS.tau, SS.Spln);
function [SS] = Geometry_SS(SS);
    
    % [m^2] Wetted Area - Starship
    %SS.Swet = sqrt(SS.tau) * 10000;

    % Wetted to Planform Area Ratio - Starship
    %SS.Kw = SS.Swet/SS.Spln;
    SS.Kw = -56.368 * (SS.tau^2) + 23.374 * SS.tau + 1.0887;
    
end

%%
%% Wetted Area to Planform Area Ratio - Starship
%[SS.Kw, SS.Swet] = Geometry(SS.tau, SS.Spln);
function [SS] = Geometry_SS(SS);

    % Wetted to Planform Area Ratio - Starship
    %SS.Kw = SS.Swet/SS.Spln;
    SS.Kw = 27.337*SS.tau^2 - 8.068*SS.tau + 3.7794;    % Updated - 2/25

    % [m^2] Wetted Area - Starship
    SS.Swet = SS.Kw * SS.Spln;

end

%%
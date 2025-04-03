%% Plot OEW vs Planform Area
function Plot_Spln_vs_TOGW(Spln, TOGW, tau, C2, VehicleNo, P)
    
    % Axis Parameters
    x = Spln;
    y = TOGW;
    C1 = tau;
    
    % Plot Data
    Plot_Common(x, y, C1, C2, VehicleNo, P)

end
%% ~~~
%}
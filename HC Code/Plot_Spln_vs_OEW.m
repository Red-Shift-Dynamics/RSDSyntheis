%% Plot OEW vs Planform Area
function Plot_Spln_vs_OEW(Spln, OEW, tau, C2, VehicleNo, P);
    
    % Axis Parameters
    x = Spln;
    y = OEW;
    C1 = tau;
    
    % Plot Data
    Plot_Common(x, y, C1, C2, VehicleNo, P)

end
%% ~~~
%}
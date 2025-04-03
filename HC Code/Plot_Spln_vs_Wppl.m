%% Plot OEW vs Propellant Weight
function Plot_Spln_vs_Wppl(Spln, Wppl, tau, C2, VehicleNo, P);
    
    % Axis Parameters
    x = Spln;
    y = Wppl;
    C1 = tau;
    
    % Plot Data
    Plot_Common(x, y, C1, C2, VehicleNo, P)

end
%% ~~~
%}
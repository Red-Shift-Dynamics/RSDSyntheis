%% Calculates Starship Weight and Volume Budgets
function [SS] = Calculate_Starship_Budget(C, MTV, SS)
    
    % Weight Ratio - Starship
    %[SS.WR] = Trajectory(MTV.v_sep, SS.TOGW);
    [SS] = Trajectory_SS(MTV, SS);
    
    % Wetted Area to Planform Area Ratio - Starship
    %[SS.Kw] = Geometry(SS.tau, SS.Spln);
    [SS] = Geometry_SS(SS);
    
    % T/W at Sea Level - Starship
    %[SS.TW0] = Propulsion(SS.TOGW);
    [SS] = Propulsion_SS(SS);
    
    % [kg] Starship Operating Empty Weight (Dry Weight)
    SS.OEW = (SS.Istr*SS.Kw*SS.Spln + (SS.TW0)*SS.WR*(MTV.Wpay)/SS.E_TW + SS.Cun) / ...
             (1/(1 + C.mua) - C.fsys - (SS.TW0)*SS.WR/SS.E_TW);
    
    % Weight and Vol Budgets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [kg] Starship Weight Budget
    SS.OWEw = SS.OEW + MTV.Wpay;
    
    % [kg] Starship Volume Budget
    SS.OWEv = (SS.tau*SS.Spln^1.5*(1 - SS.kvs - SS.kvv)- SS.Vun - MTV.Wpay/C.rho_pay) / ...
              ((SS.WR - 1)/SS.rho_ppl + SS.kve*(SS.TW0)*SS.WR);

    % Propellant Stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^3] Propellant Volume
    SS.Vppl = SS.OWEw*(SS.WR - 1) / SS.rho_ppl;
    
    % [kg] Propellant Weight
    SS.Wppl = SS.Vppl * SS.rho_ppl;

end
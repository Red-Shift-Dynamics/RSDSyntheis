    %% Calculates Superheavy Weight and Volume Budgets
function [SH] = Calculate_Superheavy_Budget(C, MTV, SH, SS)
    
    % Weight Ratio - Superheavy'
    % [SH.WR, SH.ff, SH.Wppl]
    [SH] = WR_SH(SH, SS, MTV.v_sep);
    
    % Wetted Area to Planform Area Ratio - Superheavy
    % [SH.Kw] = Geometry(SH.tau, SH.Spln, SS.Swet)
    [SH] = Geometry_SH(SH, SS);
    
    % T/W at Sea Level - Superheavy
    % [SH.TW0] = Propulsion(SH.TOGW)
    [SH] = Propulsion_SH(SH);
    
    % [kg] Superheavy Operating Empty Weight (Dry Weight)
    SH.OEW = (SH.Istr*SH.Kw*SH.Spln + SH.Cun + C.ksup*(SS.TOGW)) / ...
             (1/(1 + C.mua) - C.fsys - (SH.TW0)*SH.WR/SH.E_TW);
    
    % Weight and Vol Budgets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [kg] Superheavy Weight Budget
    SH.OWEw = SH.OEW;
    
    % [kg] Superheavy Volume Budget
    SH.OWEv = (SH.tau*SH.Spln^1.5*(1 - SH.kvs - SH.kvv) - SH.Vun - SS.TOGW*(SS.WR - 1)/SS.rho_ppl) / ...
              ((SH.WR - 1)/SH.rho_ppl + SH.kve*(SH.TW0)*SH.WR);

    % Propellant Stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^3] Propellant Volume
    SH.Vppl = SH.OWEw*(SH.WR - 1) / SH.rho_ppl;
    
    % [kg] Propellant Weight
    SH.mppl = SH.Vppl * SH.rho_ppl;

end
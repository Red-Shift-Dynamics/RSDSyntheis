%% Calculates Full Stack Weight and Volume Budgets
function [FS] = Calculate_Full_Stack_Budget(C, MTV, SS, SH, FS)
    
    % Weight Ratio - Full Stack
    % [SH.WR, SH.ff, SH.Wppl] = WR_FS()
    [FS] = WR_SH(FS, SS, SH, MTV.v_sep);
    
    % Wetted Area to Planform Area Ratio - Full Stack
    % [FS.Kw] = Geometry(FS.tau, FS.Spln)
    [FS] = Geometry_FS(FS);
    
    % T/W at Sea Level - Full Stack
    % [FS.TW0] = Propulsion(FS.TOGW)
    [FS] = Propulsion_FS(SS, SH, FS);
    
    % [kg] Operating Empty Weight (Dry Weight) - Full Stack
    FS.OEW = (FS.Istr*FS.Kw*FS.Spln + (FS.TW0*FS.WR/SH.E_TW)*MTV.Wpay + FS.Cun + C.ksup*(SS.TOGW)) / ...
             (1/(1 + C.mua) - C.fsys - (FS.TW0)*FS.WR/SH.E_TW);
    
    % Weight and Vol Budgets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [kg] Weight Budget - Full Stack
    FS.OWEw = FS.OEW + MTV.Wpay;
    
    % [kg] Volume Budget - Full Stack
    FS.OWEv = (FS.tau*FS.Spln^1.5*(1 - FS.kvs - FS.kvv) - FS.Vun - MTV.Wpay/C.rho_pay - SS.TOGW*(SS.WR - 1)/SS.rho_ppl) / ...
              ((FS.WR - 1)/SH.rho_ppl + SH.kve*(FS.TW0)*FS.WR);

    % Propellant Stuff ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [m^3] Propellant Volume
    FS.Vppl = FS.OWEw*(FS.WR - 1) / SH.rho_ppl;
    
    % [kg] Propellant Weight
    FS.mppl = FS.Vppl * SH.rho_ppl;

end
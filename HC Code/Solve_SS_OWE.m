%% Function to Calculate Error for Solver - Starship
function [ERROR] = Solve_SS_OWE(C, MTV, SS, x)

    % [kg, m^2] Assign Variables
    [SS.TOGW, SS.Spln] = deal(x(1), x(2));
    
    % Calculate Weight and Volume Budgets
    [SS] = Calculate_Starship_Budget(C, MTV, SS);
    
    % [kg] OWE ERROR
    OWE_ERROR = SS.OWEw - SS.OWEv;
    ERROR(1, 1) = abs(OWE_ERROR);
    
    % [kg] Calculate TOGW - Starship
    SS.TOGWnew = MTV.Wpay + SS.Wppl + SS.OEW;
    
    % [kg/m^2] TOGW ERROR
    TOGW_Spln_ERROR = (SS.TOGWnew - SS.TOGW)/SS.Spln;
    ERROR(2, 1) = abs(TOGW_Spln_ERROR);

end
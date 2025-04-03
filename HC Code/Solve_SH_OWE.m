%% Function to Calculate Error for Solver - Superheavy
function [ERROR] = Solve_SH_OWE(C, MTV, SH, SS, x)

    % [kg, m^2] Assign Variables
    [SH.TOGW, SH.Spln] = deal(x(1), x(2));
    
    % Calculate Weight and Volume Budgets
    [SH] = Calculate_Superheavy_Budget(C, MTV, SH, SS);
    
    % [kg] OWE ERROR
    OWE_ERROR = SH.OWEw - SH.OWEv;
    ERROR(1, 1) = abs(OWE_ERROR);
    
    % [kg] Calculate TOGW - Superheavy
    SH.TOGWnew = SH.Wppl + SH.OEW;      % MIGHT NEED TO ADD SS.OEW
    
    % [kg/m^2] TOGW ERROR
    TOGW_Spln_ERROR = (SH.TOGWnew - SH.TOGW)/SH.Spln;
    ERROR(2, 1) = abs(TOGW_Spln_ERROR);

end
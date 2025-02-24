%% Function to Calculate Error for Solver - Full Stack
function [ERROR] = Solve_FS_OWE(C, MTV, SS, SH, FS, y)

    % [kg, m^2] Assign Variables
    [FS.TOGW, FS.Spln] = deal(y(1), y(2));
    
    % Calculate Weight and Volume Budgets - Full Stack
    [FS] = Calculate_Full_Stack_Budget(C, MTV, SS, SH, FS);
    
    % [kg] OWE ERROR - Full Stack
    OWE_ERROR = FS.OWEw - FS.OWEv;
    ERROR(1, 1) = abs(OWE_ERROR);
    
    % [kg] Calculate TOGW - Full Stack
    FS.TOGWnew = FS.Wppl + FS.OEW + MTV.Wpay;
    
    % [kg/m^2] TOGW ERROR - Full Stack
    TOGW_Spln_ERROR = (FS.TOGWnew - FS.TOGW)/FS.Spln;
    ERROR(2, 1) = abs(TOGW_Spln_ERROR);

end
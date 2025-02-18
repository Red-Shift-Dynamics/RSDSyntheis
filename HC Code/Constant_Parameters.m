%% Constants For Both Vehicles
function [C, SS, SH] = Constant_Parameters()
    
    % [(Ton -> kg)/Person] Crew Member Specific Weight
    C.fcrew = 0.14 * 1000;
    
    % [(Ton -> kg)/Person] Crew Provisions Specific Weight
    C.fcprv = 0.45 * 1000;

    % [% -> dec] Margin on Inert Weight
    C.mua = 15 / 100;

    % Variable Systems Weight
    C.fsys = 0.16;

    % [m^3/Person] Crew Provision Volume Coeff
    C.vcprv = 5;

    % [kg/m^3] Payload Density
    C.rho_pay = 100;

    % Support Weight Coeff - Superheavy
    C.ksup = 0.05;

    % Starship Constant Parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [kg/m^3] Structural Index - Starship 
    SS.Istr = 17;

    % Engine Thrust to Weight - Starship 
    SS.E_TW = 100;
    
    % [Ton -> kg] Constant Unmammed Systems Weight - Starship 
    SS.Cun = 1.6 * 1000;
    
    % [(Ton -> kg)/person] Unmanned Systems Specific Weight Coeff - Starship 
    SS.fmnd = 1.05 * 1000;
    
    % Systems Volume Coeff - Starship 
    SS.kvs = 0.018;
    
    % Void Volume Coeff - Starship 
    SS.kvv = 0.12;

    % [m^3] Unmanned Systems Volume Coeff - Starship 
    SS.Vun = 5;

    % [] Propellant Density - Starship      WRONG!!!!!!!
    SS.rho_ppl = 541;

    % [m^3/(Ton -> kg)] Engine Volume Coeff - Starship
    SS.kve = 0.1 / 1000;

    % Superheavy Constant Parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [kg/m^3] Structural Index - Superheavy
    SH.Istr = 17;

    % Engine Thrust to Weight - Superheavy 
    SH.E_TW = 100;
    
    % [Ton -> kg] Constant Unmammed Systems Weight - Superheavy
    SH.Cun = 1.6 * 1000;
    
    % Systems Volume Coeff - Superheavy
    SH.kvs = 0.018;
    
    % Void Volume Coeff - Superheavy
    SH.kvv = 0.12;

    % [m^3] Unmanned Systems Volume Coeff - Superheavy
    SH.Vun = 5;

    % [] Propellant Density - Superheavy     WRONG!!!!!!!
    SH.rho_ppl = 541;

    % [m^3/(Ton -> kg)] Engine Volume Coeff - Superheavy
    SH.kve = 0.1 / 1000;

end

%% ~~~
%}
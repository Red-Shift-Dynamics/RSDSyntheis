%% Constants For Both Vehicles
function [C, SS, SH] = Constant_Parameters()
    
    % [(Ton -> kg)/Person] Crew Member Specific Weight
    %C.fcrew = 0.14 * 1000; %textbook value

    % [kg/Person] Crew Member Specific Weight
    C.fcrew = 0.067 * 1000;
    

    % [(Ton -> kg)/Person] Crew Provisions Specific Weight
    %C.fcprv = 0.45 * 1000; %textbook value
    
    % [kg/Person for 6 months (182 days)] Crew Provisions Specific Weight
    C.fcprv = 1.125 * 182; 


    % [% -> dec] Margin on Inert Weight
    C.mua = 15 / 100;


    % Variable Systems Weight
    %C.fsys = 0.16; %textbook value

    % Variable Systems Weight
    C.fsys = 0.113615;


    % [m^3/Person for 6 months (182 days)] Crew Provision Volume Coeff
    C.vcprv = 0.00308077 * 182;


    % [kg/m^3] Payload Density
    %C.rho_pay = 100; %textbook value

    % [(ton -> kg)/m^3] Payload Density
    C.rho_pay = (100*1000) / 664.0246163; 


    % Support Weight Coeff - Superheavy
    C.ksup = 0.05;

    % Starship Constant Parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    % [kg/m^2] Structural Index - Starship 
    SS.Istr = 17;

    % Engine Thrust to Weight - Starship 
    SS.E_TW = 141.1042945;
    

    % [Ton -> kg] Constant Unmammed Systems Weight - Starship 
    %SS.Cun = 1.6 * 1000; %textbook values

    % [Ton -> kg] Constant Unmammed Systems Weight - Starship 
    SS.Cun = .928 * 1000;
    

    % [(Ton -> kg)/person] Unmanned Systems Specific Weight Coeff - Starship 
    %SS.fmnd = 1.05 * 1000; %textbook values

    % [(Ton -> kg)/person] Unmanned Systems Specific Weight Coeff - Starship 
    SS.fmnd = 0.485 * 1000;

    
    % Systems Volume Coeff - Starship 
    SS.kvs = 0.018;

    % Void Volume Coeff - Starship 
    SS.kvv = 0.12;

    % [m^3] Unmanned Systems Volume Coeff - Starship 
    SS.Vun = 5;

    % [g/L = kg/m^3] Propellant Density - Starship
    SS.rho_ppl = 892.84;

    % [m^3/(Ton -> kg)] Engine Volume Coeff - Starship
    SS.kve = 0.05 * 1000;

    % Superheavy Constant Parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [kg/m^2] Structural Index - Superheavy
    SH.Istr = 17;

    % Engine Thrust to Weight - Superheavy 
    SH.E_TW = SS.E_TW;
    

    % [Ton -> kg] Constant Unmammed Systems Weight - Superheavy
    %SH.Cun = 1.6 * 1000; %textbook value

    % [Ton -> kg] Constant Unmammed Systems Weight - Superheavy
    SH.Cun = .304 * 1000;
    

    % Systems Volume Coeff - Superheavy
    SH.kvs = 0.018;
    
    % Void Volume Coeff - Superheavy
    SH.kvv = 0.12;

    % [m^3] Unmanned Systems Volume Coeff - Superheavy
    SH.Vun = 5;

    % [kg/m^3] Propellant Density - Superheavy
    SH.rho_ppl = SS.rho_ppl;

    % [m^3/(Ton -> kg)] Engine Volume Coeff - Superheavy
    SH.kve = 0.05 * 1000;
    
    % Propulsion Parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [s]Raptor 2 ISP at Sea Level
    SH.IspSL = 347;
    
    % [s]Raptor 2 ISP in Vacuum
    SH.IspVAC = 356;
    
    % [s]Specific impulse of Vacuum optimized Raptor at Vacuum
    SS.IspRVAC = 380;
end

%% ~~~
%}
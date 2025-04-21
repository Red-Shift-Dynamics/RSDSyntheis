%% Constants For Both Vehicles
function [C, SS, SH] = Constant_Parameters()

    % [% -> dec] Margin on Inert Weight
    C.mua = 16 / 100;

    % [(ton -> kg)/m^3] Payload Density
    C.rho_pay = (100 * 1000) / 664.0246163; 

    % Support Weight Coeff - Hot Stage
    C.ksup = 0.013;                     % Updated 2/25 (with assumed 20t hot staging ring)

    % Starship Constant Parameters ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Variable Systems Weight - Starship
    SS.fsys = 0.14221;                  % Updated 3/22

    % [kg/m^2] Structural Index - Starship 
    SS.Istr = 41;                       % ~ Sokol ~

    % [Ton -> kg] Constant Unmammed Systems Weight - Starship 
    SS.Cun = (0.928 + 12.1) * 1000;        % Updated 4/19 - 12.1t extra for thermal systems

    % Systems Volume Coeff - Starship 
    SS.kvs = 0.018;

    % Void Volume Coeff - Starship 
    SS.kvv = 0.05;                      % JUSTIFY VALUE

    % [m^3] Unmanned Systems Volume Coeff - Starship 
    SS.Vun = 5;

    % [m^3/(Ton -> kg)] Engine Volume Coeff - Starship
    SS.kve = 0.005 / 1000;
    
    % [g/L = kg/m^3] Propellant Density - Starship
    SS.rho_ppl = 892.84;

    % [int#] # Engines - Starship
    SS.N_eng = 6;

    % Superheavy Constants ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Variable Systems Weight - Starship
    SH.fsys = 0.08512;                  % Updated 3/22

    % [kg/m^2] Structural Index - Superheavy
    % SH.Istr = 95.5331;                % ~ FROM JASON ~
    % SH.Istr = 75;
    % SH.Istr = 93;                     % ~ Sokol ~ 3/2
    SH.Istr = 82;                       % ~ Sokol ~ 3/3

    % [Ton -> kg] Constant Unmammed Systems Weight - Superheavy
    SH.Cun = (.304 + 12) * 1000;        % Updated 3/22 - 12t for Grid Fins
    
    % Systems Volume Coeff - Superheavy
    SH.kvs = 0.018;
    
    % Void Volume Coeff - Superheavy
    SH.kvv = 0.05;

    % [m^3] Unmanned Systems Volume Coeff - Superheavy
    SH.Vun = 5;

    % [m^3/(Ton -> kg)] Engine Volume Coeff - Superheavy
    SH.kve = 0.005 / 1000;

    % [kg/m^3] Propellant Density - Superheavy
    SH.rho_ppl = SS.rho_ppl;
    
    % [int#] # Engines - Superheavy
    SH.N_eng = 33;

    % Raptor 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
    % [s]Specific impulse of Vacuum optimized Raptor at Vacuum
    SS.IspRVAC = 380;               % Raptor 2

    % [Mton -> kg] Sealevel Thrust - Starship
    % SS.ET0 = 258 * 1000;
    SS.ET0 = 244 * 1000;                % Average 3/22

    % Engine Thrust to Weight - Starship 
    % SS.E_TW = 149.5;                  % Updated 3/9
    SS.E_TW = 145.302;                  % Average 3/22 

    % [s]Raptor 2 ISP at Sea Level
    SH.IspSL = 347;

    % [s]Raptor 2 ISP in Vacuum
    SH.IspVAC = 356;

    % [Mton -> kg] Sealevel Thrust - Superheavy
    SH.ET0 = 230 * 1000;

    % Engine Thrust to Weight - Superheavy 
    SH.E_TW = 141.1042945;              % Updated - 2/25
%}
    % Raptor 3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
    % [s]Specific impulse of Vacuum optimized Raptor at Vacuum
    SS.IspRVAC = 380;         

    % [Mton -> kg] Sealevel Thrust - Starship
    SS.ET0 = 258 * 1000;            

    % Engine Thrust to Weight - Starship                 
    SS.E_TW = (192.6 + 183.61)/2;                   % 192.6 E_TW RVAC

    % [s]Raptor 3 ISP at Sea Level
    SH.IspSL = 350;

    % [s]Raptor 3 ISP in Vacuum
    SH.IspVAC = 367;

    % [Mton -> kg] Sealevel Thrust - Superheavy
    SH.ET0 = 280 * 1000;

    % Engine Thrust to Weight - Superheavy 
    SH.E_TW = 183.61;
%}
end

%% ~~~
%}
    
    % % Variable Systems Weight
    % C.fsys = 0.113615;


    % % [(Ton -> kg)/person] Crew Systems Specific Weight Coeff - Starship 
    % SS.fmnd = 0.485 * 1000;        

        % [(Ton -> kg)/Person] Crew Member Specific Weight
        % C.fcrew = 0.14 * 1000;    %textbook value

        % % [kg/Person] Crew Member Specific Weight
        % C.fcrew = 0.067 * 1000;
    
        % % [(Ton -> kg)/Person] Crew Provisions Specific Weight
        % C.fcprv = 0.45 * 1000;     %textbook value
    
        % % [kg/Person for 6 months (182 days)] Crew Provisions Specific Weight
        % C.fcprv = 1.125 * 182; 

        % % Variable Systems Weight
        % C.fsys = 0.16;     %textbook value

        % % [m^3/Person for 6 months (182 days)] Crew Provision Volume Coeff
        % C.vcprv = 0.00308077 * 182;

        % [kg/m^3] Payload Density
        % C.rho_pay = 100;       %textbook value

        % % [Ton -> kg] Constant Unmammed Systems Weight - Starship 
        % SS.Cun = 1.6 * 1000;      %textbook values
        
        % % [(Ton -> kg)/person] Unmanned Systems Specific Weight Coeff - Starship 
        % SS.fmnd = 1.05 * 1000;    %textbook values

        % % [Ton -> kg] Constant Unmammed Systems Weight - Superheavy
        % SH.Cun = 1.6 * 1000; %textbook value

%{

%}
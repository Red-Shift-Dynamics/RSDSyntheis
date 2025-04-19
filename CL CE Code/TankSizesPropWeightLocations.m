%% Tank Size and Location Function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{

Inputs:
    Vppl_Max - [m^3] Max     Propellant Volume
    Vppl_Cur - [m^3] Current Propellant Volume
    D        - [m]   Rocket Diameter

Outputs:
    Wppl.LOX       - [kg] Weight of Lox
    Wppl.Meth      - [kg] Weight of Methane
    Lppl.LOX_Base  - [m]  Location of LOX     Tank Base from Rocket Base 
    Lppl.Meth_Base - [m]  Location of Methane Tank Base from Rocket Base

%}
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [Wppl, Lppl] = TankSizesPropWeightLocations(Vppl_Max, Vppl_Cur, D)

    % [g/L] Methane Density
    rho_Meth = 438.9;
    
    % [g/L] LOX Density
    rho_LOX = 1259.9;
    
    % Mixture Ratio
    Mix = 3.55;

    % [m] Raptor 3 Engine Height
    H_Engine = 3.5;

    % Tank Sizes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [m^3] Methane Volume
    V_Meth = Vppl_Max / (1 + Mix*rho_Meth/rho_LOX);
    
    % [m^3] LOX Volume
    V_LOX = Vppl_Max - V_Meth;
    
    % [m] Height of Methane Tank
    H_Meth = V_Meth / (pi*(D/2)^2);
    
    % [m] Height of LOX Tank
    H_LOX = V_LOX / (pi*(D/2)^2);
    
    % [m] Location of LOX Tank Base from Rocket Base
    Lppl.LOX_Base = H_Engine + 1;
    
    % [m] Location of Methane Tank Base from Rocket Base
    Lppl.Meth_Base = Lppl.LOX_Base + H_LOX + 0.5;
    
    % Propellant Weights ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % [m^3] Methane Volume
    V_Meth_Current = Vppl_Cur / (1 + Mix*rho_Meth/rho_LOX);
    
    % [m^3] LOX Volume
    V_LOX_Current = Vppl_Cur - V_Meth_Current;
    
    % [kg] Methane Weight
    Wppl.Meth = rho_Meth * V_Meth_Current;
    
    % [kg] LOX Weight
    Wppl.LOX = rho_LOX * V_LOX_Current;

end
%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}
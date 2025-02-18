%{
Function WR.m
Authored By: Aayush Sudhakar
2/18/2025

This Function: 
Calculates the weight ratios for each stage during launch with gravity adjusted ideal rocket eqution
Assumes a 9000m/s required delta V for orbit


Inputs:                                                         Units
TOGW1 = Stage 1 Take Off Gross Weight (Superheavy)              (kg)
TOGW2 = Stage 2 Take Off Gross Weight (Starship)                (kg)
Isp   = Structure of Specific Impulses of Propulsion System     (seconds)
tb    = Burn Time to separation                                 (seconds)
Vsep  = Separation Velocity (non inertial)                      (m/s)
%}

function WR = WR(TOGW1, TOGW2, Isp, tb, Vsep)
    
    Isp_R_SL = Isp.R_SL;
    % [s]Specific impulse of Raptor at Sea Level

    Isp_R_VAC = Isp.R_VAC;
    % [s]Specific impulse of Raptor at Vacuum

    IspRVAC = Isp.RVAC;
    % [s]Specific impulse of Vacuum optimized Raptor at Vacuum
    
    Isp1 = (Isp_R_SL + Isp_R_VAC) / 2;
    % [s]Average Isp for Stage 1

    Isp2 = (Isp_R_VAC + IspRVAC) / 2;
    % [s]Average Isp for Stage 2

    g = 9.80665;
    % [m/s^2]Earth acceleration due to gravity

    dV1 = Vsep + tb * g;
    % [m/s]Gravity adjusted delta v at separation

    mf1 = (TOGW1 + TOGW2)/ exp(dV1 / (g * Isp1));
    % [kg]Mass at stage separation

    m_ppl1 = (TOGW1 + TOGW2) - mf1;
    % [kg]Mass of the Stage 1 propellant used in the burn (does not account for fuel required 
    % to land)

    WR1 = TOGW1 / (TOGW1 - m_ppl1);
    % []Weight Ratio of Stage 1 

    ff1 = (WR1 - 1) / WR1;
    % []Stage 1 Fuel Fraction

    dV2 = 9000 - dV1;
    % [m/s]Delta v for remainder of launch

    mf2 = (TOGW2)/ exp(dV2/ (g * Isp2));
    % [kg]Mass at orbit insertion

    m_ppl2 = TOGW2 - mf2;
    % [kg]Mass of the Stage 2 propellant used in the burn (does not account for fuel required for 
    % additional maneuvers)

    WR2 = TOGW2 / (TOGW2 - m_ppl2);
    % []Weight Ratio of Stage 2

    ff2 = (WR2 - 1) / WR2;
    % []Stage 2 Fuel Fraction

    WR.WR1 = WR1;
    WR.WR2 = WR2;
    WR.ff1 = ff1;
    WR.ff2 = ff2;
    % []Add outputs to structure

end
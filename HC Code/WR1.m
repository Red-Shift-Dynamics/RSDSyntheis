%{
Function WR1.m
Authored By: Aayush Sudhakar
Created: 2/18/2025
Updated: 2/19/2025

This Function: 
Calculates the weight ratios for Stage 1 during launch with gravity adjusted ideal rocket eqution
Assumes a 9000m/s required delta V for orbit (with losses)
Assumes 150 second Stage 1 burn time 


Inputs:                                                Units
TOGW1  = Stage 1 Take Off Gross Weight (Superheavy)    (kg)
TOGW2  = Stage 2 Take Off Gross Weight (Starship)      (kg)
Vsep   = Separation Velocity (non inertial)            (m/s)
%}

function WR_1 = WR1(TOGW1, TOGW2, Vsep)
    
    IspSL = 347;
    % [s]Raptor 2 ISP at Sea Level

    IspVAC = 356;
    % [s]Raptor 2 ISP in Vacuum

    Isp1 = (IspSL + IspVAC) / 2;
    % [s]Average Isp for Stage 1

    g = 9.80665;
    % [m/s^2]Earth acceleration due to gravity

    dV1Launch = Vsep + 150 * g;
    % [m/s]Gravity adjusted delta v at separation

    mf1 = (TOGW1 + TOGW2)/ exp(dV1Launch / (g * Isp1));
    % [kg]Mass at stage separation

    m_ppl_launch = (TOGW1 + TOGW2) - mf1;
    % [kg]Mass of the Stage 1 propellant used in the burn (does not account for fuel required 
    % to land)

    m_ppl1 = m_ppl_launch + 400*1000;
    % [kg]Mass of total Stage 1 propellant. Includes estimated 400 tons for landing burn

    WR1 = TOGW1 / (TOGW1 - m_ppl1);
    % []Weight Ratio of Stage 1 

    ff1 = (WR1 - 1) / WR1;
    % []Stage 1 Fuel Fraction

    WR_1.WR = WR1;
    WR_1.ff = ff1;
    WR_1.m_ppl = m_ppl1;
    % []Add outputs to structure

end
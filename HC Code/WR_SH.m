%{
Function WR_SH.m
Authored By: Aayush Sudhakar
Created: 2/18/2025
Updated: 2/20/2025

This Function: 
Calculates the weight ratio for Stage 1 during launch with gravity adjusted ideal rocket eqution
Assumes a 9000m/s required delta V for orbit (with losses)
Assumes 150 second Stage 1 burn time 
Assumes 400,000 kg required fuel for boostback and landing

Inputs:                                                  Units
TOGW_SH  = Stage 1 Take Off Gross Weight (Superheavy)    (kg)
TOGW_SS  = Stage 2 Take Off Gross Weight (Starship)      (kg)
Vsep     = Separation Velocity (non inertial)            (m/s)

Outputs:
WR_SH    = Superheavy Weight Ratio                       (-)
ff_SH    = Superheavy fuel fraction                      (-)
m_ppl_SH = Superheavy propellant                         (kg)
%}

function SH = WR_SH(SH, SS, Vsep)
    
    TOGW_SH = SH.TOGW;
    % [kg]Superheavy TOGW

    TOGW_SS = SS.TOGW;
    % [kg]Starship TOGW

    IspSL = SH.IspSL;
    % [s]Raptor 2 ISP at Sea Level
    
    IspVAC = SH.IspVAC;
    % [s]Raptor 2 ISP in Vacuum

    Isp = (IspSL + IspVAC) / 2;
    % [s]Average Isp for Stage 1

    g = 9.80665;
    % [m/s^2]Earth acceleration due to gravity

    dVLaunch = Vsep + 150 * g;
    % [m/s]Gravity adjusted delta v at separation

    mf = (TOGW_SH + TOGW_SS)/ exp(dVLaunch / (g * Isp));
    % [kg]Mass at stage separation

    m_ppl_launch = (TOGW_SH + TOGW_SS) - mf;
    % [kg]Mass of the SH propellant used in the burn (does not account for fuel required 
    % to land)

    m_ppl = m_ppl_launch + .1*TOGW_SH;
    % [kg]Mass of total SH propellant. Includes estimated 10% of TOGW for landing burn

    WR = (TOGW_SH) / (TOGW_SH - m_ppl);
    % []Weight Ratio of SH 

    ff = (WR - 1) / WR;
    % []Stage 1 Fuel Fraction

    SH.WR = WR;
    SH.ff = ff;
    SH.Wppl = m_ppl;
    % []Add outputs to structure

end
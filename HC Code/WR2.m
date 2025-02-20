%{
Function WR2.m
Authored By: Aayush Sudhakar
Created: 2/18/2025
Updated: 2/19/2025

This Function: 
Calculates the weight ratios for each stage during launch with gravity adjusted ideal rocket eqution
Assumes a 9000m/s required delta V for orbit (with losses)


Inputs:                                                         Units
TOGW2 = Stage 2 Take Off Gross Weight (Starship)                (kg)
Vsep  = Separation Velocity (non inertial)                      (m/s)
%}

function WR_2 = WR2(TOGW2, Vsep)

    IspRVAC = 380;
    % [s]Specific impulse of Vacuum optimized Raptor at Vacuum

    g = 9.80665;
    % [m/s^2]Earth acceleration due to gravity

    dV2Launch = 9000 - Vsep + 150 * g;
    % [m/s]Required Delta v for remainder of launch

    dV2Total = dV2Launch + 1000;
    % [m/s]Total ideal Delta v capacity for Starship (Launch plus LEO maneuvers)

    mf2 = (TOGW2)/ exp(dV2Total/ (g * IspRVAC));
    % [kg]Dry mass of starship

    m_ppl2 = TOGW2 - mf2;
    % [kg]Mass of the Stage 2 propellant

    WR2 = TOGW2 / (TOGW2 - m_ppl2);
    % []Weight Ratio of Stage 2

    ff2 = (WR2 - 1) / WR2;
    % []Stage 2 Fuel Fraction

    WR_2.WR = WR2;
    WR_2.ff = ff2;
    WR_2.m_ppl = m_ppl2;
    % []Add outputs to structure

end
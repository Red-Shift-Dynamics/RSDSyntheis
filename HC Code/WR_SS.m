%{
Function WR_SS.m
Authored By: Aayush Sudhakar
Created: 2/18/2025
Updated: 2/20/2025

This Function: 
Calculates the weight ratios for each stage during launch with gravity adjusted ideal rocket eqution
Assumes a 9000m/s required delta V for orbit (with losses)
Assumes a 1000m/s required delta V for LEO manuevers

Inputs:                                                Units
TOGW_SS = Stage 2 Take Off Gross Weight (Starship)     (kg)
Vsep  = Separation Velocity (non inertial)             (m/s)

Outputs:
WR_SS    = Starship Weight Ratio                       (-)
ff_SS    = Starship fuel fraction                      (-)
m_ppl_SS = Starship propellant                         (kg)
%}

function SS = WR_SS(SS, Vsep)

    TOGW_SS = SS.TOGW;
    % [kg]Starship TOGW

    IspRVAC = SS.IspRVAC;
    % [s]Specific impulse of Vacuum optimized Raptor at Vacuum

    g = 9.80665;
    % [m/s^2]Earth acceleration due to gravity

    dVLaunch = 9000 - Vsep + 150 * g;
    % [m/s]Required Delta v for remainder of launch

    dVTotal = dVLaunch + 1000;
    % [m/s]Total ideal Delta v capacity for Starship (Launch plus LEO maneuvers)

    mf = (TOGW_SS)/ exp(dVTotal/ (g * IspRVAC));
    % [kg]Dry mass of starship

    m_ppl = TOGW_SS - mf;
    % [kg]Mass of the Stage 2 propellant

    WR = TOGW_SS / (TOGW_SS - m_ppl);
    % []Weight Ratio of Stage 2

    ff = (WR - 1) / WR;
    % []Stage 2 Fuel Fraction

    SS.WR = WR;
    SS.ff = ff;
    SS.Wppl = m_ppl;
    % []Add outputs to structure

end
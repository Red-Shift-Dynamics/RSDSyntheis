%{
====================================================================================================
SCRIPT NAME: LaunchSimulation.m
AUTHOR: Julio César Benavides, Ph.D.
ADJUSTED: Aayush Sudhakar
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
LAST ADJUSTMENT: 04/09/2025
====================================================================================================
SCRIPT DESCRIPTION:
This script solves the launch-to-orbit problem for a Falcon 9 Block V launch vehicle with a 23
metric ton payload mass to a 200 km altitude above mean equator orbit.
====================================================================================================
USER-DEFINED FUNCTIONS:
(LaunchConstants.m)|This function loads all the constants and launch parameters used during the
launch simulation.
----------------------------------------------------------------------------------------------------
(LaunchPropagate.m)|This function propagates the launch problem and returns a structure containing
the orbital data purtaining to the launch.
----------------------------------------------------------------------------------------------------
(PlotAltitude.m)|This function plots the rocket's altitude above mean equator as a function of time.
----------------------------------------------------------------------------------------------------
(PlotSpeed.m)|This function plots the rocket's radial, tangential, and total speed with respect to
the Earth as a function of time.
----------------------------------------------------------------------------------------------------
(PlotOrbit.m)|This function plot's the rocket's orbit with respect to the Earth in Earth-centered
inertial coordinates.
----------------------------------------------------------------------------------------------------
(PlotGroundTrack.m)|This function plot's the rocket's ground track with respect to the Earth.
----------------------------------------------------------------------------------------------------
(PlotCoe.m)|This function plot's the rocket's classical orbital elements as a function of time.
====================================================================================================
ABBREVIATIONS:
'ECI' = "Earth-centered inertial".
----------------------------------------------------------------------------------------------------
'WRT' = "with respect to".
====================================================================================================
ADDITIONAL COMMENTS:
None.
====================================================================================================
PERMISSION:
Any use of this code, either in part or in full, must first be approved by Dr. Julio César
Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA).  For permission to
use this code, Dr. Benavides may be contacted at aea.engineer.com.
====================================================================================================
%}

tic;
% []Starts the program timer.

clc;
% []Clears the command window.

clear;
% []Clears the variable workspace.

format('Compact');
% []Formats the command window output to single-spaced output.

format('LongG');
% []Formats the command window output to print 16 digits for double-precision variables.

close('All');
% []Closes all figures.

String = 'Begin Simulation ...\n';
% []Formatted string.

Equal = strcat(repelem('=',100),'\n');
% []Formatted string with 100 equal signs and a carriage return.

Dash = strcat(repelem('-',100),'\n');
% []Formatted string with 100 dash signs and a carriage return.

fprintf(String);
% []Prints the formatted string on the command window.

fprintf(Equal);
% []Prints the formatted string on the command window.

%% LOAD CONSTANTS:

%C = Rap2ConvLaunchConstants;
%C = Ship7LaunchConstants;
%C = Rap3ConvLaunchConstants;
C = Rap3_130_LaunchConstants; % 130 pay
% []Loads the launch problem constants and parameters.

%% NUMERICAL INTEGRATION:

to = linspace(0,600,2000);
% [s]Modeling time.

So = C.So;
% [km,km/s]Initial rocket state WRT the Earth in ECI coordinates.

S = LaunchPropagate(to,So,C);
% []Propagates the launch problem.

%% PLOT RESULTS:

GR = [218, 165, 2] / 255;
% []Goldenrod RGB color code.

FB = [178, 34, 34] / 255;
% []Firebrick RGB color code.

PlotAltitude(S,C);
% []Plots the rocket's altitude above mean equator as a function of time.

PlotSpeed(S,C);
% []Plots the rocket's speeds as a function of time.

dv = PlotMass(S,C)
% []Plots the rocket's mass as a function of time.

PlotThrust(S,C);
% []Plots the rocket's thrust as a function of time.

PlotDynamicPressure(S,C);
% []Plots Rocket's dynamic pressure.

PlotVelocity(S,C);

PlotAcceleration(S,C);

PlotFlightPath(S,C);

Color = {FB,GR};
% []Mission segment color codes.

PlotOrbit(S,'Black',Color);
% []Plots the rocket's orbit WRT the Earth in ECI coordinates.

PlotGroundTrack(S,'Black',Color);
% []Plots the rocket's ground track as a function of time.

Color = {'k'};
% []Mission segment color codes.

PlotCoe(S,'Minutes','Earth Radii',Color);
% []Plots the rocket's classical orbital elements as a function of time.

%% SAVE LAUNCH DATA:

% save('LaunchData.mat','S','dv');
% []Saves the launch data.

%% PRINT THE SIMULATION TIME:

fprintf(Equal);
% []Prints the formatted string on the command window.

SimulationTime = toc;
% []Stops the program timer.

SimulationTimeString = 'Simulation Complete! (%0.3f seconds)\n';
% []Formatted string.

fprintf(SimulationTimeString,SimulationTime);
% []Prints the simulation time on the command window.
%===================================================================================================
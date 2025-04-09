%{
====================================================================================================
FUNCTION NAME: LaunchEom.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the equations of motion for the launch problem.
====================================================================================================
INPUT VARIABLES:
(t)|Time.
----------------------------------------------------------------------------------------------------
(S)|State vector.
----------------------------------------------------------------------------------------------------
(C)|Launch constants and parameters structure.
====================================================================================================
OUTPUT VARIABLES:
(dSdt)|State vector derivative.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(t)|Scalar {1 x 1}|(s).
----------------------------------------------------------------------------------------------------
(S)|Column Vector {6 x 1}|(km,km/s).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(dSdt)|Column Vector {6 x 1}|(km/s,km/s^2).
====================================================================================================
USER-DEFINED FUNCTIONS:
(MassThrust.m)|This function calculates the rocket mass and rocket thrust force in Earth-centered
inertial coordinates.
----------------------------------------------------------------------------------------------------
(Drag.m)|This function calculates the rocket drag force in Earth-centered inertial coordinates.
----------------------------------------------------------------------------------------------------
(Gravity.m)|This function calculates the acceleration due to gravity in Earth-centered inertial
coordinates using the relative two-body problem model of gravity.
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

function dSdt = LaunchEom(t,S,C)

    R = S(1:3);
    % [km]Rocket position WRT the Earth in ECI coordinates.

    V = S(4:6);
    % [km]Rocket velocity WRT the Earth in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    r = norm(R);
    % [km]Rocket range WRT the Earth.

    hcg = r - C.Re;
    % [km]Rocket altitude above mean equator.

    %-----------------------------------------------------------------------------------------------

    [m,T] = MassThrust(t,R,V,hcg,C);
    % [kN]Rocket mass and thrust force in ECI coordinates.

    D = Drag(R,V,hcg,C);
    % [kN]Drag force in ECI coordinates.

    g = Gravity(R,r,C);
    % [km/s^2]Acceleration due to gravity in ECI coordinates.

    %-----------------------------------------------------------------------------------------------

    dSdt = zeros(6,1);
    % []Allocates memory for the state vector derivative.

    dSdt(1:3) = V;
    % [km/s]Rocket velocity WRT the Earth in ECI coordinates.

    dSdt(4:6) = (T + D) / m + g;
    % [km/s^2]Rocket acceleration WRT the Earth in ECI coordinates.

end
%===================================================================================================
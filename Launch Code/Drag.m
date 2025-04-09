%{
====================================================================================================
FUNCTION NAME: Drag.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the rocket drag force in Earth-centered inertial coordinates.
====================================================================================================
INPUT VARIABLES:
(R)|Position vector.
----------------------------------------------------------------------------------------------------
(V)|Velocity vector.
----------------------------------------------------------------------------------------------------
(hcg)|Altitude above mean equator.
----------------------------------------------------------------------------------------------------
(C)|Launch constants and parameters structure.
====================================================================================================
OUTPUT VARIABLES:
(D)|Drag force.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(R)|Column Vector {3 x 1}|(km).
----------------------------------------------------------------------------------------------------
(V)|Column Vector {3 x 1}|(km/s).
----------------------------------------------------------------------------------------------------
(hcg)|Scalar {1 x 1}|(km).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(D)|Column Vector {3 x 1}|(kN).
====================================================================================================
USER-DEFINED FUNCTIONS:
(StandardAtmosphere.m)|This function calculates the local atmospheric temperature, pressure, and
density based on the ARDC 1959 Standard Atmosphere.
====================================================================================================
ABBREVIATIONS:
'ECI' = "Earth-centered inertial".
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

function D = Drag(R,V,hcg,C)

    hcg = hcg * 1000;
    % [m]Converts the altitude above mean equator from km to m.

    [~,~,rho] = StandardAtmosphere(hcg);
    % [kg/m^3]Atmospheric density.

    rho = rho * 1E9;
    % [kg/km^3]Converts the atmospheric density from kg/m^3 to kg/km^3.

    Vinf = V - cross(C.We,R);
    % [km/s]Rocket true air velocity.

    vinf = norm(Vinf);
    % [km/s]Rocket true air speed.

    D = -0.5 * C.R.Cd * rho * C.R.Ar * vinf * Vinf;
    % [kN]Drag force in ECI coordinates.

end
%===================================================================================================
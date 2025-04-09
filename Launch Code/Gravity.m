%{
====================================================================================================
FUNCTION NAME: Gravity.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the acceleration due to gravity in Earth-centered inertial coordinates
using the relative two-body problem model of gravity.
====================================================================================================
INPUT VARIABLES:
(R)|Position vector.
----------------------------------------------------------------------------------------------------
(r)|Range.
----------------------------------------------------------------------------------------------------
(C)|Launch parameters.
====================================================================================================
OUTPUT VARIABLES:
(g)|Acceleration due to gravity.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(R)|Column Vector {3 x 1}|(km).
----------------------------------------------------------------------------------------------------
(r)|Scalar {1 x 1}|(km).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(g)|Column Vector {3 x 1}|(km/s^2).
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
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

function g = Gravity(R,r,C)

    g = -C.Gm * R / r^3;
    % [km/s^2]Acceleration due to gravity in ECI coordinates.

end
%===================================================================================================
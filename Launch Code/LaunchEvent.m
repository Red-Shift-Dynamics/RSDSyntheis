%{
====================================================================================================
FUNCTION NAME: LaunchEvent.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function determines the numerical integration stop condition.
====================================================================================================
INPUT VARIABLES:
(S)|State vector.
----------------------------------------------------------------------------------------------------
(C)|Launch constants and parameters structure.
====================================================================================================
OUTPUT VARIABLES:
(v)|Zero-event speed.
----------------------------------------------------------------------------------------------------
(IsTerminal)|Numerical integration termination parameter.
----------------------------------------------------------------------------------------------------
(Direction)|Zero-event direction check.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(S)|Column Vector {6 x 1}|(km,km/s).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(v)|Scalar {1 x 1}|(km/s).
----------------------------------------------------------------------------------------------------
(IsTerminal)|Scalar {1 x 1}|(-).
----------------------------------------------------------------------------------------------------
(Direction)|Scalar {1 x 1}|(-).
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
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

function [v,IsTerminal,Direction] = LaunchEvent(~,S,C)

    V = S(4:6);
    % [km/s]Rocket velocity WRT the Earth in ECI coordinates.

    vc = sqrt(C.Gm / C.rf);
    % [km/s]Final circular orbit speed.

    v = norm(V) - vc;
    % [km/s]Zero-event speed.

    IsTerminal = 1;
    % []Terminates the numerical integration when the zero-event is reached.

    Direction = 1;
    % []Only checks the increasing event functions.

end
%===================================================================================================
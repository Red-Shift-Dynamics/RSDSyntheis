%{
====================================================================================================
FUNCTION NAME: MassThrust.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the rocket mass and rocket thrust force in ECI coordinates.
====================================================================================================
INPUT VARIABLES:
(t)|Time.
----------------------------------------------------------------------------------------------------
(R)|Position vector.
----------------------------------------------------------------------------------------------------
(V)|Velocity vector.
----------------------------------------------------------------------------------------------------
(hcg)|Altitude above mean equator.
----------------------------------------------------------------------------------------------------
(C)|Launch constants and parameters structure.
====================================================================================================
OUTPUT VARIABLES:
(m)|Rocket mass.
----------------------------------------------------------------------------------------------------
(T)|Thrust force.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(t)|Scalar {1 x 1}|(s).
----------------------------------------------------------------------------------------------------
(R)|Column Vector {3 x 1}|(km).
----------------------------------------------------------------------------------------------------
(V)|Column Vector {3 x 1}|(km/s).
----------------------------------------------------------------------------------------------------
(hcg)|Scalar {1 x 1}|(km).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(m)|Scalar {1 x 1}|(kg).
----------------------------------------------------------------------------------------------------
(T)|Column Vector {3 x 1}|(kN).
====================================================================================================
USER-DEFINED FUNCTIONS:
(Guidance.m)|This function calculates the rocket's thrust force vector in Earth-centered inertial
coordinates.
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

function [m,T] = MassThrust(t,R,V,hcg,C)

    if (t <= C.t(2))

        m = C.M(1) + C.S1.mdot * t;
        % [kg]Rocket mass.

            if hcg < 20
                
                Tmag = C.S1.To + C.S1.Tdot * t;
                % [kg]Rocket thrust.
            
            else
                
                Tmag = C.S1.Tf;
                % [kg]Rocket thrust.
            
            end

    elseif (t > C.t(2)) && (t < C.t(3))

        m = C.M(2);
        % [kg]Rocket mass.

        Tmag = 0;
        % [kN]Rocket thrust.

    elseif (t >= C.t(3)) && (t < C.t(4))

        m = C.M(3);
        % [kg]Rocket mass.

        Tmag = 0;
        % [kN]Rocket thrust.

    elseif (t >= C.t(4)) && (t <= C.t(6))

        m = C.M(4) + C.S2.mdot * (t - C.t(4));
        % [kg]Rocket mass.

        Tmag = C.S2.T;
        % [kN]Rocket thrust.

    elseif (t > C.t(6)) && (t < C.t(7))

        m = C.M(4)+C.S2.mdot * (C.S2.tb);
        % [kg]Rocket mass.

        Tmag = 0;
        % [kN]Rocket thrust.

    elseif (t >= C.t(7))

        m = C.M(4)+C.S2.mdot * (C.S2.tb);
        % [kg]Rocket mass.

        Tmag = 0;
        % [kN]Rocket thrust.

    end

    %-----------------------------------------------------------------------------------------------

    if (hcg > 100)

        m = m - C.S3.Mplf;
        % [kg]Adjusted rocket mass.

    end

    %-----------------------------------------------------------------------------------------------

    T = Guidance(t,R,V,Tmag);
    % [kN]Thurst force in ECI coordinates.

end
%===================================================================================================
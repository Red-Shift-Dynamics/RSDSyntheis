%{
====================================================================================================
FUNCTION NAME: Guidance.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the rocket's thrust force vector in Earth-centered inertial coordinates.
====================================================================================================
INPUT VARIABLES:
(t)|Time.
----------------------------------------------------------------------------------------------------
(R)|Position vector.
----------------------------------------------------------------------------------------------------
(V)|Velocity vector.
----------------------------------------------------------------------------------------------------
(Tmag)|Thrust force magnitude.
====================================================================================================
OUTPUT VARIABLES:
(T)|Thrust force vector.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(t)|Scalar {1 x 1}|(s).
----------------------------------------------------------------------------------------------------
(R)|Column Vector {3 x 1}|(km).
----------------------------------------------------------------------------------------------------
(V)|Column Vector {3 x 1}|(km/s).
----------------------------------------------------------------------------------------------------
(Tmag)|Scalar {1 x 1}|(kN).
----------------------------------------------------------------------------------------------------
(T)|Column Vector {3 x 1}|(kN).
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

function T = Guidance(t,R,V,Tmag)

    if (t <= 120)
%150 Real Flight 7

        theta = deg2rad(t / 2.2);
        %theta = deg2rad(t / 2.71); %Real Flight 7
        % [rad]Thrust angle.

        H = cross(R,V);
        % [km^2/s]Rocket specific angular momentum WRT the Earth in ECI coordinates.

        Rhat = R / norm(R);
        % []Rocket radial direction WRT the Earth in ECI coordinates.

        Nhat = cross(R,V) / norm(cross(R,V));
        %[]Rocket normal direction WRT the Earth in ECI coordinates.

        That = cross(Nhat,Rhat);
        % []Rocket tangential direction WRT the Earth in ECI coordinates.

        T = Tmag * (cos(theta) * Rhat + sin(theta) * That);
        % [kN]Thrust force in ECI coordinates.

    elseif (t > 120) && (t <= 370)

        T = Tmag * V / norm(V);
        % [kN]Thrust force in ECI coordinates.

    elseif (t > 370)

        Rhat = R / norm(R);
        %[]Radial direction WRT the Earth in ECI coordinates.

        Nhat = cross(R,V) / norm(cross(R,V));
        %[]Normal direction WRT the Earth in ECI coordinates.

        That = cross(Nhat,Rhat);
        %[]Tangential direction WRT the Earth in ECI coordinates.

        vr = dot(V,Rhat);
        %[km/s]Radial speed.

        if (vr < 0)

            alpha = (90 - 19) * pi / 180;
            %[rad]Alpha angle.

        elseif (vr == 0)

            alpha = 90 * pi / 180;
            %[rad]Alpha angle.

        elseif (vr > 0)

            alpha = (90 + 19) * pi / 180;
            %[rad]Alpha angle.

        end

        T = Tmag * (cos(alpha) * Rhat + sin(alpha) * That);
        %[kN]Thrust vector in ECI coordinates.

    end

end
%===================================================================================================
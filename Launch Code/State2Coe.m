%{
====================================================================================================
FUNCTION NAME: State2Coe.m
AUTHOR: Julio César Benavides, Ph.D.
EFFECTED: 06/17/2005
REVISED: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function calculates the classical orbital elements for a set of inertial state vectors with
respect to a central body.
====================================================================================================
INPUT VARIABLES:
(S)|State vectors.
----------------------------------------------------------------------------------------------------
(Gm)|Central body gravitational parameter.
----------------------------------------------------------------------------------------------------
(Units)|Output classical orbital elements angle units string.  Options are 'Degrees' or 'Radians'.
====================================================================================================
OUTPUT VARIABLES:
(Coe)|Classical orbital elements.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(S)|Matrix {6 x n}|(km,km/s).
----------------------------------------------------------------------------------------------------
(Gm)|Scalar {1 x 1}|(km^3/s^2).
----------------------------------------------------------------------------------------------------
(Units)|String {-}|(-).
----------------------------------------------------------------------------------------------------
(Coe)|Matrix {6 x n}|(km,-,degrees or radians)
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
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

function Coe = State2Coe(S,Gm,Units)

    I = [1; 0; 0];
    % []Inertial X-axis vector.

    K = [0; 0; 1];
    % []Inertial Z-axis vector.

    %-----------------------------------------------------------------------------------------------

    s = size(S);
    % []Returns the dimensions of the state matrix.

    Coe = zeros(s);
    % []Allocates memory for the classical orbital elements matrix.

    %-----------------------------------------------------------------------------------------------

    for k = 1:s(2)

        R = S(1:3,k);
        % [km]Position WRT the central body in inertial coordinates.

        r = norm(R);
        % [km]Range WRT the central body.

        Rhat = R / r;
        % []Position direction WRT the central body in inertial coordinates.

        %-------------------------------------------------------------------------------------------

        V = S(4:6,k);
        % [km/s]Velocity WRT the central body in inertial coordinates.

        v = norm(V);
        % [km/s]Speed WRT the central body.

        %-------------------------------------------------------------------------------------------

        H = cross(R,V);
        % [km^2/s]Specific angular momentum WRT the central body in inertial coordinates.

        h = norm(H);
        % [km^2/s]Specific angular momentum magnitude WRT the central body.

        Hhat = H / h;
        % []Specific angular momentum direction WRT the central body in inertial coordinates.

        %-------------------------------------------------------------------------------------------

        N = cross(K,H);
        % [km^2/s]Ascending node vector WRT the central body in inertial coordinates.

        n = norm(N);
        % [m^2/s]Ascending node vector magnitude WRT the central body.

        %-------------------------------------------------------------------------------------------

        E = cross(V,H) / Gm - Rhat;
        % []Eccentricity vector WRT the central body in inertial coordinates.

        e = norm(E);
        % []Eccentricity WRT the central body.

        if (e > -eps) && (e < eps)

            e = 0;
            % []Eccentricity WRT the central body.

        end

        %-------------------------------------------------------------------------------------------

        energy = v^2 / 2 - Gm / r;
        % [km^2/s^2]Specific mechanical energy WRT the central body.

        %-------------------------------------------------------------------------------------------

        Coe(1,k) = -Gm / (2 * energy);
        % [km]Semimajor axis.

        %-------------------------------------------------------------------------------------------

        Coe(2,k) = e;
        % []Eccentricity.

        %-------------------------------------------------------------------------------------------

        Coe(3,k) = acos(dot(K,Hhat));
        % [rad]Inclination.

        if (Coe(3,k) > -eps) && (Coe(3,k) < eps)

            Coe(3,k) = 0;
            % [rad]Inclination.

        end

        %-------------------------------------------------------------------------------------------

        if (Coe(3,k) == 0)

            Coe(4,k) = 0;
            % [rad]Right ascension of the ascending node.

        else

            Nhat = N / n;
            % []Line of nodes direction WRT the central body in inertial coordinates.

            Coe(4,k) = acos(dot(I,Nhat));
            % [rad]Right ascension of the ascending node.

            if Nhat(2) < 0

                Coe(4,k) = 2 * pi - Coe(4,k);
                % [rad]Right ascension of the ascending node quadrant check.

            end

        end

        %-------------------------------------------------------------------------------------------

        if (e == 0) || (Coe(3,k) == 0)

            Coe(5,k) = 0;
            % [rad]Argument of periapsis.

        else

            Nhat = N / n;
            % []Line of nodes direction WRT the central body in inertial coordinates.

            Ehat = E / e;
            % []Eccentricity direction WRT the central body in inertial coordinates.

            Coe(5,k) = acos(dot(Nhat,Ehat));
            % [rad]Argument of periapsis.

            if Ehat(3) < 0

                Coe(5,k) = 2 * pi - Coe(5,k);
                % [rad]Argument of periapsis quadrant check.

            end

        end

        %-------------------------------------------------------------------------------------------

        if (e == 0)

            Coe(6,k) = 0;
            % [rad]True anomaly.

        else

            Ehat = E / e;
            % []Eccentricity direction WRT the central body in inertial coordinates.

            Coe(6,k) = acos(dot(Ehat,Rhat));
            % [rad]True anomaly.

            if dot(R,V) < 0

                Coe(6,k) = 2 * pi - Coe(6,k);
                % [rad]True anomaly angle quadrant check.

            end

        end

    end

    %-----------------------------------------------------------------------------------------------

    if strcmpi(Units,'Degrees')

        Coe(3:6,:) = Coe(3:6,:) * 180 / pi;
        % [deg]Converts all angles from radians to degrees.

    end

end
%===================================================================================================
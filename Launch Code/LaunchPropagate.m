%{
====================================================================================================
FUNCTION NAME: LaunchPropagate.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function propagates the launch problem and returns a structure containing the orbital data
purtaining to the launch.
====================================================================================================
INPUT VARIABLES:
(to)|Modeling time vector.
----------------------------------------------------------------------------------------------------
(So)|Initial state.
----------------------------------------------------------------------------------------------------
(C)|Launch constants and parameters structure.
====================================================================================================
OUTPUT VARIABLES:
(S)|Launch data structure.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(to)|Row Vector {1 x n}|(s).
----------------------------------------------------------------------------------------------------
(So)|Column Vector {6 x 1}|(km,km/s).
----------------------------------------------------------------------------------------------------
(C)|Stucture {-}|(-).
----------------------------------------------------------------------------------------------------
(S)|Structure {-}|(-).
====================================================================================================
USER-DEFINED FUNCTIONS:
(LaunchEom.m)|This function calculates the equations of motion for the launch problem.
----------------------------------------------------------------------------------------------------
(State2Coe.m)|This function calculates the classical orbital elements for a set of inertial state
vectors with respect to a central body.
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

function S = LaunchPropagate(to,So,C)

    [S.t,S.S] = ode45(@(t,S)LaunchEom(t,S,C),to,So,C.Options);
    %[s,km,km/s]Numerically integrates the equations of motion for the launch problem.

    S.t = transpose(S.t);
    % [s]Transpose of the time vector.

    S.S = transpose(S.S);
    % [km,km/s]Transpose of the state matrix.

    S.R = S.S(1:3,:);
    % [km]Rocket position vectors WRT the Earth in ECI coordinates.

    S.V = S.S(4:6,:);
    % [km/s]Rocket velocity vectors WRT the Earth in ECI coordinates.

    S.JD = C.JD + S.t / 86400;
    % [solar days]Julian date vector.

    UTC = datetime(S.JD,'ConvertFrom','JulianDate','Format','yyyy:MM:dd:HH:dd:ss');
    % [yyyy,MM,dd,HH,dd,ss]Coordinated universal time as a datetime value.

    S.UTC = datevec(UTC);
    % [yyyy,MM,dd,HH,dd,ss]Coordinated universal time as a 1 x 6 row vector.

    S.Coe = State2Coe(S.S,C.Gm,'Degrees');
    % [km,-,deg,deg,deg,deg]Rocket classical orbital elements.

    %-----------------------------------------------------------------------------------------------

    Tu = S.JD - 2451545;
    % [solar days]Number of solar days since the J2000 epoch.

    ERA = 2 * pi * (0.7790572732640 + 1.00273781191135448 * Tu);
    % [rad]Earth rotation angles for all modeling times.

    %-----------------------------------------------------------------------------------------------

    n = numel(S.t);
    % []Number of elements in the time vector.

    S.r = zeros(1,n);
    % []Allocates memory for the range vector.

    S.v = zeros(1,n);
    % []Allocates memory for the speed vector.

    S.h = zeros(1,n);
    % []Allocates memory for the altitude above mean equator vector.

    S.Lat = zeros(1,n);
    % []Allocates memory for the latitude vector.

    S.Long = zeros(1,n);
    % []Allocates memory for the longitude vector.

    for k = 1:n

        S.r(k) = norm(S.R(:,k));
        % [km]Range WRT the Earth.

        S.v(k) = norm(S.V(:,k));
        % [km/s]Speed WRT the Earth.

        S.h(k) = S.r(k) - C.Re;
        % [km]Altitude above mean equator.

        EciToEcef = [ ...
             cos(ERA(k)), sin(ERA(k)), 0; ...
            -sin(ERA(k)), cos(ERA(k)), 0; ...
                       0,           0, 1];
        % []Matrix that transforms vectors from ECI coordinates to ECEF coordinates.
        
        R = EciToEcef * S.R(:,k);
        % [km]Position WRT the Earth in ECEF coordinates.
        
        S.Lat(k) = asin(R(3) / norm(R)) * 180 / pi;
        % [deg]Latitude.
        
        S.Long(k) = atan2(R(2),R(1)) * 180 / pi;
        % [deg]Longitude.

    end

    %-----------------------------------------------------------------------------------------------

    S = orderfields(S,{'UTC','JD','t','h','r','v','Lat','Long','R','V','S','Coe'});
    % []Reorders the output structure fields.

end
%===================================================================================================
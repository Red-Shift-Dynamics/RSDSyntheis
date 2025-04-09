%{
====================================================================================================
FUNCTION NAME: PlotSpeed.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function plots the rocket's radial, tangential, and total speed with respect to the Earth as a
function of time.
====================================================================================================
INPUT VARIABLES:
(S)|Launch data structure.
----------------------------------------------------------------------------------------------------
(C)|Launch constants and parameters structure.
====================================================================================================
OUTPUT VARIABLES:
None.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(S)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(C)|Structure {-}|(-).
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

function PlotSpeed(S,C)

    n = numel(S.t);
    % []Number of elements in the time vector.

    vr = zeros(1,n);
    % []Allocates memory for the rocket radial speed WRT the Earth vector.

    vt = zeros(1,n);
    % []Allocates memory for the tangential speed WRT the Earth vector.

    v = zeros(1,n);
    % []Allocates memory for the circular orbit speed WRT the Earth vector.

    for k = 1:n

        r = norm(S.R(:,k));
        % [km]Rocket range WRT the Earth.

        Rhat = S.R(:,k) / r;
        % []Rocket radial direction WRT the Earth in ECI coordinates.

        H = cross(S.R(:,k),S.V(:,k));
        % [km^2/s]Rocket specific angular momentum WRT the Earth in ECI coordinates.

        Nhat = H / norm(H);
        % []Rocket normal direction WRT the Earth in ECI coordinates.

        That = cross(Nhat,Rhat) / norm(cross(Nhat,Rhat));
        % []Rocket tangential direction WRT the Earth in ECI coordinates.

        vr(k) = dot(S.V(:,k),Rhat);
        % [km/s]Rocket radial speed WRT the Earth.

        vt(k) = dot(S.V(:,k),That);
        % [km/s]Rocket tangential speed WRT the Earth.

        v(k) = sqrt(C.Gm / r);
        % [km/s]Rocket circular orbit speed WRT the Earth at the current altitude above mean
        % equator.

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Speed Analysis', ...
        'NumberTitle','Off');
    % []Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Axes = axes( ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'Parent',Window, ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',[0,550], ...
        'YLim',[0,8], ...
        'XTick',linspace(0,550,11), ...
        'YTick',linspace(0,8,11));
    % []Adds an axes to the specified window and adjusts its properties.

    title( ...
        'Speed Analysis', ...
        'FontSize',20, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel( ...
        'Time (s)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.

    ylabel( ...
        'Speed (km/s)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    plot(S.t,vr, ...
        'Color','r', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes);
    % []Adds a plot to the specified axes and adjusts its properties.

    plot(S.t,vt, ...
        'Color','b', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes);
    % []Adds a plot to the specified axes and adjusts its properties.

    plot(S.t,v, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes);
    % []Adds a plot to the specified axes and adjusts its properties.

    legend( ...
        {'Radial','Tangential','Circular'}, ...
        'Location','East', ...
        'Parent',Window);
    % []Adds a legend to the specified axes and adjusts its properties.

end
%===================================================================================================
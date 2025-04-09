%{
====================================================================================================
FUNCTION NAME: PlotAltitude.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function plots the rocket's altitude above mean equator as a function of time.
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

function PlotAltitude(S,C)

    n = numel(S.t);
    % []Number of elements in the time vector.

    h = zeros(1,n);
    % []Allocates memory for the altitude above mean equator vector.

    for k = 1:n

        h(k) = norm(S.R(:,k)) - C.Re;
        % [km]Altitude above mean equator.

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Altitude Above Mean Equator Analysis', ...
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
        'XLim',[0,600], ...
        'YLim',[0,500], ...
        'XTick',linspace(0,600,11), ...
        'YTick',linspace(0,500,11));
    % []Adds an axes to the specified window and adjusts its properties.

    title( ...
        'Altitude Above Mean Equator', ...
        'FontSize',20, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel( ...
        'Time (s)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.

    ylabel( ...
        'Altitude (km)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    plot(S.t,h, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes);
    % []Adds a plot to the specified axes and adjusts its properties.

end
%===================================================================================================
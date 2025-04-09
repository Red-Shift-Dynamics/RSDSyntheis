%{
====================================================================================================
FUNCTION NAME: PlotGroundTrack.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function plot's the vehicle's ground track with respect to the Earth.
====================================================================================================
INPUT VARIABLES:
(S)|Launch data structure.  Options are 'White' or 'Black'.
----------------------------------------------------------------------------------------------------
(String)|Color string.
====================================================================================================
OUTPUT VARIABLES:
None.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(S)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(String)|String {-}|(-).
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
====================================================================================================
ABBREVIATIONS:
'ECEF' = "Earth-centered, Earth-fixed".
----------------------------------------------------------------------------------------------------
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

function PlotGroundTrack(S,String,Color)

    n = numel(S);
    % []Number of mission segments.

    %-----------------------------------------------------------------------------------------------
    
    Window = figure;
    % []Opens a new window.
    
    Axes = axes('Parent',Window);
    % []Adds an axes to the specified window.
    
    Earth = imread('Earth.png');
    % []Loads the groundtrack image data.
    
    GroundTrack = image(Earth);
    % []Adds the Earth to the current axes.
    
    ScreenSize = get(0,'ScreenSize');
    % []Determines the location and dimensions of the current monitor.
    
    set(GroundTrack, ...
        'XData',[-180,180], ...
        'YData',[-90,90]);
    % []Adjusts the properties of the groundtrack image.
    
    set(Window, ...
        'Color','k', ...
        'NumberTitle','Off', ...
        'Name','Ground Track', ...
        'OuterPosition',ScreenSize);
    % []Adjusts the properties of the specified window.

    %-----------------------------------------------------------------------------------------------
    
    Longitude = { ...
        '180W','165W','150W','135W','120W','105W','90W','75W','60W','45W','30W','15W', ...
        '0','15E','30E','45E','60E','75E','90E','105E','120E','135E','150E','165E','180E'};
    % []Longitude string.
    
    Latitude = {'90N','75N','60N','45N','30N','15N','0','15S','30S','45S','60S','75S','90S'};
    % []Latitude string.

    %-----------------------------------------------------------------------------------------------
    
    set(Axes, ...
        'DataAspectRatio',[1,1,1], ...
        'FontName','Arial', ...
        'FontSize',8, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'XColor','w', ...
        'YColor','w', ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',[-180,180], ...
        'YLim',[-90,90], ...
        'XTick',-180:15:180, ...
        'YTick',-90:15:90, ...
        'XTickLabel',Longitude, ...
        'YTickLabel',Latitude);
    % []Adjusts the properties of the specified axis.

    Title = title('Groundtrack','Color','w','FontSize',20,'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel('Longitude (\circ)','FontSize',16,'Parent',Axes);
    % []Adds a label to the x-axis and adjusts its properties.
    
    ylabel('Latitude (\circ)','FontSize',16,'Parent',Axes);
    % []Adds a label to the y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    if strcmpi(String,'White')

        set(Window,'Color','w');
        % []Sets the window background color to white.

        set(Axes,'GridColor','w','XColor','k','YColor','k');
        % []Sets the axes background color to white.

        set(Title,'Color','k');
        % []Sets the axes title color to black.

    end

    %-----------------------------------------------------------------------------------------------

    for k = 1:n

        plot(S(k).Long,-S(k).Lat, ...
            'Color',Color{k}, ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes);
        % []Plots the satellite ground track.

    end
    
end
%===================================================================================================
%{
====================================================================================================
FUNCTION NAME: PlotOrbit.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function plot's the vehicle's orbit with respect to the Earth in Earth-centered inertial
coordinates.
====================================================================================================
INPUT VARIABLES:
(S)|Launch data structure.
----------------------------------------------------------------------------------------------------
(String)|Color string.  Options are 'White' or 'Black'
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

function PlotOrbit(S,String,Color)

    Re = 6378.137;
    % [km]Mean equatorial radius of the Earth.

    Rp = 6356.752;
    % [km]Mean polar radius of the Earth.

    %-----------------------------------------------------------------------------------------------

    n = numel(S);
    % []Number of mission segments.
    
    r = zeros(1,n);
    % []Allocates memory for the maximum ranges.

    for k = 1:n

        S(k).R = S(k).R / Re;
        % [Earth radii]Converts all positions from kilometers to Earth radii.

        S(k).r = S(k).r / Re;
        % [Earth radii]Converts all ranges from kilometers to Earth radii.

        r(k) = max(S(k).r);
        % [Earth radii]Maximum range for the current segment.

    end

    Extent = ceil(max(r));
    % [Earth radii]Axes extents.

    %-----------------------------------------------------------------------------------------------
    
    [x,y,z] = ellipsoid(0,0,0,1,1,Rp / Re,50);
    % [Earth radii]Determines the coordinates of the Earth.
    
    Earth = imread('Earth.png');
    % []Loads the image of the Earth.
    
    %-----------------------------------------------------------------------------------------------
    
    ScreenSize = get(0,'ScreenSize');
    % []Determines the location and the dimensions of the current monitor.
    
    Window = figure( ...
        'Color','k', ...
        'Name','Orbit in Earth-Centered Inertial Coordinates', ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize);
    % []Opens a new window and adjusts its properties.
    
    %-----------------------------------------------------------------------------------------------
    
    Axes = axes( ...
        'Color','k', ...
        'DataAspectRatio',[1,1,1], ...
        'Parent',Window, ...
        'NextPlot','Add', ...
        'View',[135,45], ...
        'XColor','k', ...
        'YColor','k', ...
        'ZColor','k');
    % []Adds an axes to the specified window and adjusts its properties.
    
    %-----------------------------------------------------------------------------------------------
    
    surface(x,y,-z, ...
        'CData',Earth, ...
        'EdgeColor','None', ...
        'FaceColor','TextureMap', ...
        'Parent',Axes);
    % []Adds the Earth to the specified axes and adjusts its properties.
    
    %-----------------------------------------------------------------------------------------------
    
    XAxis = plot3([0,Extent],[0,0],[0,0], ...
        'Color','w', ...
        'Linestyle','-', ...
        'LineWidth',3, ...
        'Marker','None', ...
        'Parent',Axes);
    % []Adds the X-axis to the specified axes and adjusts its properties.
    
    YAxis = plot3([0,0],[0,Extent],[0,0], ...
        'Color','w', ...
        'Linestyle','-', ...
        'LineWidth',3, ...
        'Marker','None', ...
        'Parent',Axes);
    % []Adds Y-axis to the specified axes and adjusts its properties.
    
    ZAxis = plot3([0,0],[0,0],[0,Extent], ...
        'Color','w', ...
        'Linestyle','-', ...
        'LineWidth',3, ...
        'Marker','None', ...
        'Parent',Axes);
    % []Adds the Z-axis to the specified axes and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    XAxisEnd = plot3(Extent,0,0, ...
        'Color','w', ...
        'Linestyle','None', ...
        'Marker','o', ...
        'MarkerSize',15, ...
        'MarkerFaceColor','w', ...
        'Parent',Axes);
    % []Adds the X-axis to the specified axes and adjusts its properties.
    
    YAxisEnd = plot3(0,Extent,0, ...
        'Color','w', ...
        'Linestyle','None', ...
        'Marker','o', ...
        'MarkerSize',15, ...
        'MarkerFaceColor','w', ...
        'Parent',Axes);
    % []Adds Y-axis to the specified axes and adjusts its properties.
    
    ZAxisEnd = plot3(0,0,Extent, ...
        'Color','w', ...
        'Linestyle','None', ...
        'Marker','o', ...
        'MarkerSize',15, ...
        'MarkerFaceColor','w', ...
        'Parent',Axes);
    % []Adds the Z-axis to the specified axes and adjusts its properties.
    
    %-----------------------------------------------------------------------------------------------
    
    XLabel = text( ...
        'BackGroundColor','None', ...
        'Color','k', ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','Center', ...
        'LineStyle','None', ...
        'Parent',Axes, ...
        'Position',[Extent,0,0], ...
        'String','X', ...
        'VerticalAlignment','Middle');
    % []Adds the X-label to the specified axes and adjusts its properties.
    
    YLabel = text( ...
        'BackGroundColor','None', ...
        'Color','k', ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','Center', ...
        'LineStyle','None', ...
        'Parent',Axes, ...
        'Position',[0,Extent,0], ...
        'String','Y', ...
        'VerticalAlignment','Middle');
    % []Adds Y-label to the specified axes and adjusts its properties.
    
    ZLabel = text( ...
        'BackGroundColor','None', ...
        'Color','k', ...
        'FontName','Arial', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'HorizontalAlignment','Center', ...
        'LineStyle','None', ...
        'Parent',Axes, ...
        'Position',[0,0,Extent], ...
        'String','Z', ...
        'VerticalAlignment','Middle');
    % []Adds Z-label to the specified axes and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    if strcmpi(String,'White') == 1

        set(Window,'Color','w');
        % []Sets the window background color to white.

        set(Axes,'Color','w','XColor','w','YColor','w','ZColor','w');
        % []Sets the axes background color to white.

        set(XAxis,'Color','k');
        % []Sets the x-axis color to black.

        set(YAxis,'Color','k');
        % []Sets the y-axis color to black.

        set(ZAxis,'Color','k');
        % []Sets the z-axis color to black.

        set(XAxisEnd,'Color','k');
        % []Sets the x-axis ending color to black.

        set(YAxisEnd,'Color','k');
        % []Sets the y-axis ending color to black.

        set(ZAxisEnd,'Color','k');
        % []Sets the z-axis ending color to black.

        set(XLabel,'Color','k');
        % []Sets the x-axis label color to white.

        set(YLabel,'Color','k');
        % []Sets the y-axis label color to white.

        set(ZLabel,'Color','k');
        % []Sets the z-axis label color to white.

    end

    %-----------------------------------------------------------------------------------------------
    
    for k = 1:n

        plot3(S(k).R(1,:),S(k).R(2,:),S(k).R(3,:), ...
            'Color',Color{k}, ...
            'LineStyle','None', ...
            'Marker','.', ...
            'Parent',Axes);
        % []Adds the orbit to the specified axes and adjusts its properties.

    end

end
%===================================================================================================
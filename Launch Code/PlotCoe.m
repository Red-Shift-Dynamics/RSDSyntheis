%{
====================================================================================================
FUNCTION NAME: PlotGroundTrack.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/19/2024
LAST REVISION: 01/19/2025
====================================================================================================
FUNCTION DESCRIPTION:
This function plot's the vehicle's classical orbital elements as a function of time.
====================================================================================================
INPUT VARIABLES:
(S)|Launch data structure.
----------------------------------------------------------------------------------------------------
(Time)|Time string.  Options are 'Seconds','Minutes','Hours','Days', or 'Years'.
----------------------------------------------------------------------------------------------------
(Unit)|Length string.  Options are 'Kilometers', 'Earth Radii', or 'Astronomical Units'
====================================================================================================
OUTPUT VARIABLES:
None.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(S)|Structure {-}|(-).
----------------------------------------------------------------------------------------------------
(Time)|String {-}|(-).
----------------------------------------------------------------------------------------------------
(Unit)|String {-}|(-).
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

function PlotCoe(S,Time,Unit,Color)

    n = numel(S);
    % []Number of mission segments.

    %-----------------------------------------------------------------------------------------------
    
    switch(Time)

        case('Minutes')

            for k = 1:n

                S(k).t = S(k).t / 60;
                % [minuntes]Converts the time vector from seconds to minutes.

            end

        case('Hours')

            for k = 1:n

                S(k).t = S(k).t / 3600;
                % [hours]Converts the time vector from seconds to hour.

            end

        case('Days')

            for k = 1:n

                S(k).t = S(k).t / 86400;
                % [solar days]Converts the time vector from seconds to solar days.

            end

        case('Years')

            for k = 1:n

                S(k).t = S(k).t / 86400 / 365.25;
                % [Julian years]Converts the time vector from seconds to Julian years.

            end

    end

    %-----------------------------------------------------------------------------------------------
    
    switch(Unit)

        case('Earth Radii')

            for k = 1:n

                S(k).Coe(1,:) = S(k).Coe(1,:) / 6378.137;
                % [Earth radii]Converts semimajor axes from kilometers to Earth radii.

            end

        case('Astronomical Units')

            for k = 1:n

                S(k).Coe(1,:) = S(k).Coe(1,:) / 149597870.700;
                % [AU]Converts semimajor axes from kilometers to astronomical units.

            end

    end

    %-----------------------------------------------------------------------------------------------
    
    Titles = { ...
        'Semimajor Axis', ...
        'Eccentricity', ...
        'Inclination', ...
        'RAAN', ...
        'Argument of Periapsis', ...
        'True Anomaly'};
    % []Plot title strings.

    switch(Time)
        
        case('Seconds')
            
            XLabel = 'Time (s)';
            % []X-axis label.

        case('Minutes')
            
            XLabel = 'Time (min)';
            % []X-axis label.
            
        case('Hours')
            
            XLabel = 'Time (hr)';
            % []X-axis label.
            
        case('Days')
            
            XLabel = 'Time (days)';
            % []X-axis label.
            
    end
    
    YLabel = { ...
        'a (km)', ...
        'e', ...
        'i (\circ)', ...
        '\Omega (\circ)', ...
        '\omega (\circ)', ...
        '\theta (\circ)'};
    % []Y-axis strings.

    switch(Unit)
        
        case('Earth Radii')

            YLabel{1} = 'a (R_e)';
            % []Semimajor axis y-label adjustment.
            
        case('Astronomical Units')

            YLabel{1} = 'a (AU)';
            % []Semimajor axis y-label adjustment.
            
    end

    %-----------------------------------------------------------------------------------------------
    
    ScreenSize = get(0,'ScreenSize');
    % []Determines the location and dimensions of the current monitor.
    
    Window = figure( ...
        'Color','w', ...
        'Name','Classical Orbital Elements', ...
        'NumberTitle','Off', ...
        'OuterPosition',ScreenSize);
    % []Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------
    
    Axes = zeros(1,6);
    % []Allocates memory for the axes properties.
    
    for k = 1:6
        
        Axes(k) = subplot(2,3,k, ...
            'FontName','Times', ...
            'FontSize',8, ...
            'FontWeight','Bold', ...
            'Parent',Window, ...
            'NextPlot','Add', ...
            'XGrid','On', ...
            'YGrid','On', ...
            'XLim',[0,ceil(max(S(end).t))], ...
            'YLim',[0,360], ...
            'XTick',linspace(0,ceil(max(S(end).t)),11), ...
            'YTick',0:30:360);
        % []Adds an axes to the specified window and adjusts its properties.
                
        title(Titles{k}, ...
            'FontSize',12, ...
            'Parent',Axes(k));
        % []Adds a title to the specified axes and adjusts its properties.

        xlabel(XLabel, ...
            'FontSize',12, ...
            'Parent',Axes(k));
        % []Adds a label to the specified x-axis and adjusts its properties.
        
        ylabel(YLabel{k}, ...
            'FontSize',12, ...
            'Parent',Axes(k));
        % []Adds a label to the specified y-axis and adjusts its properties.

        for x = 1:n

            plot(S(x).t,S(x).Coe(k,:), ...
                'Color',Color{x}, ...
                'LineStyle','None', ...
                'Marker','.', ...
                'Parent',Axes(k));
        end
        
    end

    %-----------------------------------------------------------------------------------------------

    Limits = zeros(n,2);
    % []Allocates memory for the extent matrix.

    for k = 1:n

        Limits(k,:) = [floor(min(S(k).Coe(1,:))), ceil(max(S(k).Coe(1,:)))];
        % []Semimajor axis limits.

    end

    Extent = [min(min(Limits)), max(max(Limits))];
    % []Semimajor axis y-axis extents.
    
    set(Axes(1),'YLim',Extent,'YTick',linspace(Extent(1),Extent(2),11));
    % []Adjusts the properties of the specified axes.

    %-----------------------------------------------------------------------------------------------

    Eccentricity = zeros(n);
    % []Allocates memory for the eccentricity limits.

    for k = 1:n

        Eccentricity(k) = max(S(k).Coe(2,:));
        % []Maximum eccentricity for the current segment.

    end
    
    if max(Eccentricity) < 1
        
        set(Axes(2),'YLim',[0,1],'YTick',0:0.1:1);
        % []Adjusts the properties of the specified axes.
        
    else
        
        set(Axes(2), ...
            'YLim',[0,ceil(max(Eccentricity))], ...
            'YTick',linspace(0,ceil(max(Eccentricity)),11));
        % []Adjusts the properties of the specified axes.
        
    end

    %-----------------------------------------------------------------------------------------------
    
    set(Axes(3),'YLim',[0,180],'YTick',0:15:180);
    % []Adjusts the properties of the specified axes.
   
end
%===================================================================================================
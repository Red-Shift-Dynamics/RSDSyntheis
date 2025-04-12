function PlotFlightPath(S,C)

    n = numel(S.t);
    % []Number of elements in the time vector.

    gamma = zeros(1,n);
    % []Allocates memory for the parameters.

    for k = 1:n

        R = S.R(:,k);
        % [km]Absolute vehicle position WRT the Earth in ECI coordinates.

        V = S.V(:,k) - C.Vgse;
        % [km/s]Absolute vehicle velocity WRT the Earth in ECI coordinates.

        Rhat = R / norm(R);
        %[]Radial direction WRT the Earth in ECI coordinates.

        %Nhat = cross(R,V) / norm(cross(R,V));
        %[]Normal direction WRT the Earth in ECI coordinates.


        Nhat = [0.0594822666328589;
                0.434118577948849;
                0.898889826528194];

        That = cross(Nhat,Rhat);
        %[]Tangential direction WRT the Earth in ECI coordinates.

        gamma(k) = acosd(dot(V,That)/norm(V));
        % [deg]Vehicle Flight Path Angle.

        if dot(cross(V,That),Nhat) < 0

            gamma(k) = -gamma(k);
            % [deg]Vehicle Flight Path Angle.

        end

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Relative Flight Path Angle', ...
        'NumberTitle','Off');
    % []Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Titles = 'Relative Flight Path Angle';
    % []Axes titles.

    YLabels = 'Relative Flight Path Angle (deg)';
    % []Axes subplot y-axis labels.

    Xtick = 50;

    Ytick = 10;
   

    Xmax = ceil(max(S.t/Xtick))*Xtick;

    Ymax = ceil(max(gamma/Ytick))*Ytick;
   
    YLimits = [-10, Ymax];
    % []Axes subplot y-axis limits.

    Axes = axes(...
        'FontName','Times', ...
        'FontSize',8, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'Parent',Window, ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',[0,Xmax], ...
        'YLim',YLimits, ...
        'XTick',0:Xtick:Xmax, ...
        'YTick',-10:Ytick:Ymax);
    % []Adds an axes to the specified window and adjusts its properties.

    title( ...
        Titles, ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel( ... 
        'Time (s)', ...
        'FontSize',12, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.

    ylabel( ...
        YLabels, ...
        'FontSize',12, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.

    

    %-----------------------------------------------------------------------------------------------

    plot(S.t,gamma(1,:), ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes(1));
    % []Adds a plot to the specified axes and adjusts its properties.



end
%===================================================================================================
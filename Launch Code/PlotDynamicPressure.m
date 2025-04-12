function PlotDynamicPressure(S,C)

    n = numel(S.t);
    % []Number of elements in the time vector.

    q = zeros(1,n);
    % []Allocates memory for the parameters.

    for k = 1:n

        Rcge = S.R(:,k);
        % [km]Absolute vehicle position WRT the Earth in ECI coordinates.

        Vcge = S.V(:,k);
        % [km/s]Absolute vehicle velocity WRT the Earth in ECI coordinates.

        [~,~,rho] = StandardAtmosphere(S.h(k)*1000);
        % [kg/m^3]Atmospheric density.
    
        Vatm = cross(C.We,Rcge);
        % [k/s]Atmosphere velocity WRT the Earth in ENZ coordinates.
        
        Vinf = Vcge - Vatm;
        % [km/s]True air velocity.

        vinf = norm(Vinf) * 1000;
        % [m/s]True air speed.

        q(k) = .5 * rho * vinf^2 / 1000;
        % [kPa]Vehicle dynamic pressure.

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Dynamic Pressure', ...
        'NumberTitle','Off');
    % []Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Titles = 'Dynamic Pressure';
    % []Axes titles.

    YLabels = 'Pressure (kPa)';
    % []Axes subplot y-axis labels.

    tick = 50;
    % [s]Pl

    Xmax = ceil(max(S.t/tick))*tick;

    Ymax = ceil(max(q/tick))*tick;
    
    YLimits = [0, Ymax];
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
        'XTick',0:tick:Xmax, ...
        'YTick',0:tick/10:Ymax);
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

    plot(S.t,q(1,:), ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes(1));
    % []Adds a plot to the specified axes and adjusts its properties.



end
%===================================================================================================
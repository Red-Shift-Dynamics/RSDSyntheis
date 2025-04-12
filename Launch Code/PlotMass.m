function dv = PlotMass(S,C)

    n = numel(S.t);
    % []Number of elements in the time vector.

    m = zeros(1,n);
    % []Allocates memory for the rocket mass.

    for k = 1:n

        hcg = norm(S.R(:,k)) - C.Re;
        % [km]Altitude above mean equator.

        [m(k),~] = MassThrust(S.t(k),S.R(:,k),S.V(:,k),hcg,C);
        % [kg]Rocket mass.

        m(k) = m(k) / 1000;
        % [MT]Converts the mass to metric tons.

    end

    %-----------------------------------------------------------------------------------------------

    Window = figure( ...
        'Color','w', ...
        'Name','Mass Profile During Launch', ...
        'NumberTitle','Off');
    % []Opens a new window and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Xtick = 50;

    Ytick = 500;
   

    Xmax = ceil(max(S.t/Xtick))*Xtick;

    Ymax = ceil(max(m/Ytick))*Ytick;

    YLimits = [0, Ymax];
    % []Axes subplot y-axis limits.
    
    Axes = axes( ...
        'FontName','Times', ...
        'FontSize',12, ...
        'FontWeight','Bold', ...
        'NextPlot','Add', ...
        'Parent',Window, ...
        'XGrid','On', ...
        'YGrid','On', ...
        'XLim',[0,Xmax], ...
        'YLim',YLimits, ...
        'XTick',0:Xtick:Xmax, ...
        'YTick',0:Ytick:Ymax);
    % []Adds an axes to the specified window and adjusts its properties.

    title( ...
        'Rocket Mass Profile', ...
        'FontSize',20, ...
        'Parent',Axes);
    % []Adds a title to the specified axes and adjusts its properties.

    xlabel( ...
        'Time (s)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified x-axis and adjusts its properties.

    ylabel( ...
        'Mass (MT)', ...
        'FontSize',16, ...
        'Parent',Axes);
    % []Adds a label to the specified y-axis and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    plot(S.t,m, ...
        'Color','k', ...
        'LineStyle','None', ...
        'Marker','.', ...
        'Parent',Axes);
    % []Adds a plot to the specified axes and adjusts its properties.

    %-----------------------------------------------------------------------------------------------

    Mo = m(end) * 1000;
    % [kg]Launch vehicle mass at orbit insertion.

    Mf = C.M(6);
    % [kg]Launch vehicle mass at SECO.

    dv = C.S2.Isp * C.g * log(Mo / Mf);
    % [km/s]Delta-v remaining in stage 2.

end
%===================================================================================================
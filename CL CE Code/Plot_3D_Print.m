%% 3D Analyzed Solution Space Function
function Plot_3D_Print(Spln, TOGW, TW0, NumVehiclePass, ChosenVehicle, P)

    % Axis Parameters
    xAll = Spln;       % [m^2]
    yAll = TOGW;       % [Ton]
    zAll = TW0;        % [~]
    Data = [xAll, yAll, zAll];

    % Axis Parameters
    % x = Spln(NumVehiclePass);       % [m^2]
    % y = TOGW(NumVehiclePass);       % [Ton]
    y = Spln(NumVehiclePass);       % [m^2]
    x = TOGW(NumVehiclePass);       % [Ton]
    z =  TW0(NumVehiclePass);       % [~]
    
    P.y_Label = 'Planform Area, Spln (m^2)';
    P.x_Label = 'Takeoff Gross Weight, TOGW (Tons)';
    P.y_Tick_I = 20;                        % [m^2]
    P.x_Tick_I = 100;                       % [kg -> Ton]

    % % Axis Parameters
    % x = Spln;       % [m^2]
    % y = TOGW;       % [Ton]
    % z = TW0;        % [~]
    % Data = [x, y, z];
    
    % Create Figure
    figure( ...
        'Color', 'w', ...
        'Name',  P.Title, ...
        'NumberTitle', 'Off');
    
    % Axis Properties
    P.x_Domain = [floor(min(x) / P.x_Tick_I) * P.x_Tick_I, ceil(max(x) / P.x_Tick_I) * P.x_Tick_I];
    P.y_Domain = [floor(min(y) / P.y_Tick_I) * P.y_Tick_I, ceil(max(y) / P.y_Tick_I) * P.y_Tick_I];
    P.z_Domain = [floor(min(z) / P.z_Tick_I) * P.z_Tick_I, ceil(max(z) / P.z_Tick_I) * P.z_Tick_I];
    if P.z_Domain(1) == P.z_Domain(2)
        P.z_Domain = [floor(min(z - 10) / P.z_Tick_I) * P.z_Tick_I, 
            ceil(max(z + 10) / P.z_Tick_I) * P.z_Tick_I];
    end

    % Graph Resolution
    NGrid = 1000;
    % NGrid = 50;

    % Interpolate X and Y values onto a Grid
    [Xgrid, Ygrid] = meshgrid(linspace(min(x),max(x),NGrid), linspace(min(y),max(y),NGrid));
    
    % Interpolate Z values onto the grid
    Zgrid = griddata(x, y, z, Xgrid, Ygrid);

    % invalidValues = isnan(Zgrid) | isinf(Zgrid);
    % if any(invalidValues(:))
    % 
    %     % Or simply remove those points (may cause holes)
    %     Zgrid(invalidValues) = min(Zgrid(~invalidValues));
    % end

    % Common Plot Properties
    P.MarkerSize = 15;
    P.Marker     = '.';
    P.Color      = 'black';
    P.LineStyle  = 'none';
    
    % Now plot with the gridded data
    Plot_3D_Function(x, y, z, P);
    % Create Figure
    figure( ...
        'Color', 'w', ...
        'Name',  P.Title, ...
        'NumberTitle', 'Off');

    [sh] = Plot_Surf_3D_Function(Xgrid, Ygrid, Zgrid, P);
    hold on;

    % Surf Plot Gradient
    colormap(copper);
    
    % Design Point ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Plot Design Point Properties
    P.MarkerSize = 40;
    P.Marker     = '.';
    P.Color      = 'black';
    
    % [kg, m^2] Plot Data
    Plot_3D_Function(Data(ChosenVehicle,1), Data(ChosenVehicle,2), Data(ChosenVehicle,3),P);

    % Export as STL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Create Figure
    % figure( ...
    %     'Color', 'w', ...
    %     'Name',  'STL', ...
    %     'NumberTitle', 'Off');

    % Create surface
    % sh = surf(Xgrid, Ygrid, Zgrid);
    
    % Get faces and vertices from the surface
    [F, V] = surf2patch(sh, 'triangles');
    
    % Remove invalid vertices
    isValidVertex = all(isfinite(V), 2);
    newIndexMap = zeros(size(isValidVertex));
    newIndexMap(isValidVertex) = 1:nnz(isValidVertex);
    
    Vclean = V(isValidVertex, :);
    
    % Remove faces that use any invalid vertex
    validFaceMask = all(isValidVertex(F), 2);
    Fclean = F(validFaceMask, :);
    
    % Reindex faces to cleaned vertex list
    Fclean = newIndexMap(Fclean);
    
    % Create triangulation
    TR = triangulation(Fclean, Vclean);
    
    % Export to STL
    stlwrite(TR, 'surf_model.stl');
    
end
%% ~~~
%}
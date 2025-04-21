clear all, clc, close all, format compact, format longG, tic;
%% Title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Equal = strcat(repelem('=', 100));      % Creates Equal String
Tilda = strcat(repelem('~', 100));      % Creates Tilda String
fprintf('Vehicle Analysis \n%s\n', Equal);
%{
%}
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% % Import HC Code
% addpath('C:\Users\Taquito-Mini\Documents\GitHub\Synthesis\HC Code');

% Import Propulsion Diameter Code
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Propulsion\EngineConfiguration');

% Import Geometry Sizing Code
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Geometry');

% Import Trajectory Analysis Codes
% addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\(1) Launch Code and Orbit Raising');
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\Mars_Descent_Update');
% addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\(6) Mars Launch');

% Import Structural Analysis Codes
addpath( ...
     'C:\Users\Taquito-Mini\Documents\GitHub\RSD\Structures\Center of Gravity\FullStackCGLocation');
addpath( ...
      'C:\Users\Taquito-Mini\Documents\GitHub\RSD\Structures\Center of Gravity\StarshipCGLocation');
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Structures\MaxQAnalysis');

% Import Stability Analysis Code
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Controls');
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Controls\ControlRatio\StarshipPitch');
addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Controls\ControlRatio\StarshipYaw');

%% Constants and Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Import Converge Vehicle Data
% addpath('C:\Users\Taquito-Mini\Documents\GitHub\Synthesis\CL CE Code\658 Vehicles 33 Raptor 3');
load('Data VA', 'VehicleData', 'SS', 'SH', 'VehicleNo');
load('Calculated Data VA', 'CalculatedData');
% rmpath('C:\Users\Taquito-Mini\Documents\GitHub\Synthesis\CL CE Code\658 Vehicles 33 Raptor 3');

% Vehicle Table
% Vehicle = CombTable.Wpay;
% Vehicle = CombTable.v_sep;
Vehicle = CalculatedData;

% [int#] Vehicle Counter
VehCount = 1;

% Format Data Error Table
columnNames = {'Pass', 'Geo_Fail', 'Struc_Fail', 'Struc_Mars_Fail', 'Mars_G_Fail', 'Pitch_Fail', ...
               'Yaw_Fail', 'Earth_Capture_Fail'};
VehicleResults = nan(VehicleNo, length(columnNames));

% Convert the numeric array to a table
VehicleResults = array2table(VehicleResults, 'VariableNames', columnNames);

%% Parametric Model ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Engine Type
Raptor = 3;

% [~] Non Dimensional Locations of Flaps from Nose
SS.xbar.FF = 0.179471074;
SS.xbar.AF = 0.8557107;

% [m] Wall Thickness of Starship
FS.t = 4 * 10^-3;

% [%] Allowable Error Tolerance
tol = 12;

% [mt -> kg] Mars Launch Payload
MarsWpay = 100 * 1000;

% [Gs] Max Vehicle G loading
Max_Gs = 6.3;

% Full Stack ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m] Diameter of Rocket
[FS.D] = MinSHDiameter(SH.N_eng);

% Starship ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Starship Engines
SS_N_eng_SL  = 3;
SS_N_eng_VAC = 3;  

% [% -> deg] Starship Flap Area Ratio to Total Planform Area
% SS.Flap_Percent_Area = 5 / 100;
% SS.Flap_Percen t_Area = 9 / 100;
SS.Flap_Percent_Area = 12.5 / 100;
% SS.Flap_Percent_Area = 13.5 / 100;
% SS.Flap_Percent_Area = 16 / 100;

% Cone Sizes for L_cone = 13.650
SS.H_Cone = 13.650;
Str.d_Cone    = [8.1;8.2;8.3;8.4;8.5;8.6;8.7;8.8;8.9;9.0;9.1;9.2;9.3;9.4];
Str.Spln_Cone = [93.14;93.28;93.42;94.18;94.94;95.7;96.46;97.22;97.98; ...
                                                                    98.74;99.5;100.28;101.04;101.8];
Str.Swet_Cone = [304.91;305.36;305.84;308.46;311.08;313.72; ...
                                             316.36;319.01;321.67;324.34;327.02;329.71;332.4;335.1];
Str.V_Cone    = [528.84;530.59;532.36;541.32;550.37;559.51; ...
                                           568.73;578.05;587.46;596.95;606.54;616.21;625.97;635.83];

% Super Heavy ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m^2] Area per Grid Fin        
SH.Spln.GF = 11.9072;

% [m] Grid Fin Span
SH.b.GF = 9;

%% Computation ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Starship Engine Check
if SS_N_eng_SL + SS_N_eng_VAC ~= SS.N_eng
    error('Too # SS engines inputs don''t meet solution engines');
end

% Grab Cone Dimensions Given Rocket Diameter
SS.Spln.Cone = Str.Spln_Cone(FS.D == Str.d_Cone);       % [m^2] Planform Area - Cone
SS.Swet.Cone = Str.Swet_Cone(FS.D == Str.d_Cone);       % [m^2] Wetted Area   - Cone
SS.V.Cone    = Str.V_Cone   (FS.D == Str.d_Cone);       % [m^3] Volume        - Cone

for i = 1: 1: VehicleNo

    % Parametric Model ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   
    % Parametric Model Funciton Inputs
    VecIn.SS_Vtot = Vehicle.SS_Vtot(i);         % [m^3] Total Volume        - SS
    VecIn.SS_Spln = VehicleData.SS_Spln(i);     % [m^2] Total Planform Area - SS
    VecIn.SS_Swet = VehicleData.SS_Swet(i);     % [m^2] Total Wetted Area   - SS
    VecIn.SS_tau  = Vehicle.SS_tau(i);
    VecIn.SH_Vtot = Vehicle.SH_Vtot(i);
    VecIn.SH_Spln = VehicleData.SH_Spln(i);
    VecIn.SH_Swet = VehicleData.SH_Swet(i);
    VecIn.SH_tau  = Vehicle.SH_tau(i);
    
    % Generate Parametric Model
    [SS, SH, FS] = ParametricModelCode(SS, SH, FS, VecIn);
    
    % Calculate Geometry Vehicle Error
    Error      = zeros(8, 1);
    Error(1,1) = (SS.V_tot    - VecIn.SS_Vtot)/VecIn.SS_Vtot * 100;
    Error(2,1) = (SS.Spln_tot - VecIn.SS_Spln)/VecIn.SS_Spln * 100;
    Error(3,1) = (SS.Swet_tot - VecIn.SS_Swet)/VecIn.SS_Swet * 100;
    Error(4,1) = (SS.tau      - VecIn.SS_tau )/VecIn.SS_tau  * 100;
    Error(5,1) = (SH.V_tot    - VecIn.SH_Vtot)/VecIn.SH_Vtot * 100;
    Error(6,1) = (SH.Spln_tot - VecIn.SH_Spln)/VecIn.SH_Spln * 100;
    Error(7,1) = (SH.Swet_tot - VecIn.SH_Swet)/VecIn.SH_Swet * 100;
    Error(8,1) = (SH.tau      - VecIn.SH_tau )/VecIn.SH_tau  * 100;
    
    % Checks for Geometry Error
    if max(abs(Error)) < tol
        % fprintf('--- STARSHIP OVERALL TOTALS ---\n');
        fprintf('  SS CylL = %.3f m\n',   SS.H_Fuse);
        % fprintf('  SS V    = %.3f%%\n',   Error(1,1));
        % fprintf('  SS Spln = %.3f%%\n',   Error(2,1));
        % fprintf('  SS Swet = %.3f%%\n',   Error(3,1));
        % fprintf('  SS Tau  = %.3f%%\n\n', Error(4,1));
        % fprintf('--- SUPER HEAVY (BOOSTER) ---\n');
        fprintf('  SH FusL = %.3f m\n',   SH.H_Fuse);
        % fprintf('  SH V    = %.3f%%\n',   Error(5,1));
        % fprintf('  SH Spln = %.3f%%\n',   Error(6,1));
        % fprintf('  SH Swet = %.3f%%\n',   Error(7,1));
        % fprintf('  SH Tau  = %.3f%%\n\n', Error(8,1));
    else
        % fprintf('Geo Error Too High %0.3f%%\n%s\n', max(abs(Error)), Tilda);
        VehicleResults.Geo_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % Print Current Vehicle Number
    fprintf('Vehicle %d \n', i);

    % Geometry Inputs
    Geometry.SS.D        = FS.D;            % [m]   Starship Fuselage diameter
    Geometry.SS.Lnose    = SS.H_Cone;       % [m]   Tangent Ogive Nose Length
    Geometry.SS.Lcyl     = SS.H_Fuse;       % [m]   Cylindrical Section Length - SS
    Geometry.SS.ForeSpan = SS.b.FF;         % [m]   Span per fore flap 
    Geometry.SS.ForeArea = SS.Spln.FF;      % [m^2] Planform Area - FF
    Geometry.SS.AftSpan  = SS.b.AF;         % [m]   Span per aft flap
    Geometry.SS.AftArea  = SS.Spln.AF;      % [m^2] Planform Area - AF
    Geometry.SH.D        = FS.D;            % [m]   Super Heavy Fuselage diameter
    Geometry.SH.Lcyl     = SH.H_Fuse;       % [m]   Cylindrical Section Length - SH
    Geometry.SH.GridFinArea = SH.Spln.GF;   % [m^2] Area per Grid Fin  
    Geometry.SH.GridFinSpan = SH.b.GF;      % [m] Grid Fin Span

    % Vehicle Simulation Common Variable Inputs
    SS.OEW  = VehicleData.SS_OEW(i);
    SH.OEW  = VehicleData.SH_OEW(i);
    SS.Mppl = VehicleData.SS_mppl(i);
    SH.Mppl = VehicleData.SH_mppl(i);
    Wpay    = VehicleData.Wpay(i);
    SS.TOGW = VehicleData.SS_TOGW(i);       % Not Needed for Launch
    SH.TOGW = VehicleData.SH_TOGW(i);       % Not Needed for Launch
    
    % [m] CG Location of Payload from Nose
    SS.V.PayCyl  = Vehicle.SS_Vpay(i) - SS.V.Cone;
    SS.H_Pay_Cyl = SS.V.PayCyl / [pi*(FS.D/2)^2];
    SS.x.Cone = 3/4 * SS.H_Cone;
    SS.x.Pay  = SS.H_Cone + SS.H_Pay_Cyl/2;
    Nose_Lpay = (SS.V.Cone*SS.x.Cone + SS.V.PayCyl*SS.x.Pay)/Vehicle.SS_Vpay(i);

    % Starship Mars Descent ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Starship Descent Inputs
    Descent.hi = 100 * 10^3;                    % [km -> m]     Inital Altitude of Starship on Mars
    Descent.Vi = 3.3 * 10^3;                    % [(km -> m)/s] Inital Velocity of Starship
    Descent.W  = SS.OEW + Wpay + SS.Mppl*0.025; % [kg]          Starship Weight During Descent
    
    % [~, m/s, Pa, Gs] Starship Mars Descent Analysis
    [DescentC] = DescentConstants(SS.Spln_tot, Descent.W);
    [~,SSDescent.dv,SSDescent.DP,SSDescent.gs,SSDescent.CD] = Descent_Landing_Function_Segment( ...
                                                        Descent.hi, Descent.Vi, DescentC, Geometry);
    
    % [kg] Mass of Vehicle at Mars Max Q
    iMaxQ = find(SSDescent.DP == max(SSDescent.DP));
    if length(iMaxQ) > 1
        iMaxQ = iMaxQ(1);
    end
    StrMaxQ.QMax = SSDescent.DP(iMaxQ);
    StrMaxQ.CD   = SSDescent.CD(iMaxQ);

    % Mars Descent G loading Check
    Max_MarsDescentG = max(SSDescent.gs);
    if Max_MarsDescentG > Max_Gs;
        fprintf('Mars Descent G Loading too High %0.3f G''s \n%s\n', Max_MarsDescentG, Tilda);
        VehicleResults.Mars_G_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % [m/s] Delta-v Needed for Mars Landing
    fprintf('[m/s] dv Needed for Mars Landing \n\t%f \n', SSDescent.dv);

    % [kg, m] CG Location of Propellant Tanks from Base - SS
    [SS.Wppl, SS.Lppl] = TankSizesPropWeightLocations(Vehicle.SS_Vppl(i), ...
                                                      Vehicle.SS_Vppl(i)*0.1, FS.D);
    
    % Starship CG Location Inputs - Mars Descent
    LVeh    = SS.H_Cone + SS.H_Fuse;    % [m]   Vehicle Length - SS
    DVeh    = FS.D;                     % [m]   Starship Diameter
    mVehDry = SS.OEW;                   % [kg]  Dry Weight     - SS
    LloxSS_rest = SS.Lppl.LOX_Base;     % [m]   Location of LOX Base WRT Rocket Base
    mLoxSS      = SS.Wppl.LOX;          % [kg]  Mass of LOX
    LmetSS_rest = SS.Lppl.Meth_Base;    % [m]   Location of Meth Base WRT Rocket Base
    mMetSS      = SS.Wppl.Meth;         % [kg]  Mass of Meth
    SS.x.FF = LVeh * SS.xbar.FF;        % [m]   Location from Rocket Nose - SS FF
    Lfore   = LVeh - SS.x.FF;           % [m]   Locaiton from Rocket Base - SS FF
    Sfore   = SS.Spln.FF;               % [m^2] Planform Area             - SS FF
    SS.x.AF = LVeh * SS.xbar.AF;        % [m]   Location from Rocket Nose - SS AF
    Laft    = LVeh - SS.x.AF;           % [m]   Locaiton from Rocket Base - SS AF
    Saft    = SS.Spln.AF;               % [m^2] Planform Area             - SS AF
    Lpay    = LVeh - Nose_Lpay;         % [m]   CG Location of Payload WRT Rocket Base
    mPay = Wpay;                        % [kg]  Payload Weight
    
    % [m] Starship CG Location from Base of Rocket - Mars Descent
    [Bottom_SS_Lcg] = StarshipCGLocation(LVeh, DVeh, mVehDry, LloxSS_rest, mLoxSS, LmetSS_rest, ...
                                         mMetSS, Lfore, Sfore, Laft, Saft, Lpay, mPay);

    % Structural Analysis Inputs
    LVeh     = LVeh;                            % [m]   Length of Vehicle        - SS
    Nose_SS_Lcg = LVeh - Bottom_SS_Lcg;         % [m]   FS CG Location From Nose - SS
    VehTh    = 90 * pi/180;                     % [deg -> rad] Flight Path Angle at MaxQ
    mVeh     = Descent.W;                       % [kg]  Weight of Vehicle at MaxQ - SS
    qMax     = StrMaxQ.QMax;                    % [Pa]  Descent Max Q
    S        = pi*(FS.D/2)^2;                   % [m^2] Planform Area - SS
    CD       = StrMaxQ.CD;                      %       Drag Coeff    - SS
    Tmax     = 0;                               % [N]   Descent Thrust
    throttle = 0;                               %       Throttle Setting
    ROutVeh  = FS.D/2;                          % [kg]  Radius of Vehicle
    ThVeh    = FS.t;                            % [m]   Wall Thickness - SS
    
    % Structural Analysis
    [Out] = MaxQPassFailFunction(LVeh, Nose_SS_Lcg, VehTh, mVeh, qMax, S, CD, Tmax, throttle, ...
                                 ROutVeh, ThVeh);
    
    % Structural Check
    if strcmp(Out, 'fails') == 1
        fprintf('Mars Descent Structural Failure!\n%s\n', Tilda);
        VehicleResults.Struc_Mars_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end
    
    % Stability Inputs 
    Nose_SS_Lcg = LVeh - Bottom_SS_Lcg;     % [m] SS CG Location from Rocket Nose
    Lcp   = LVeh/2;                         % [m] CP Location from Rocket Nose
    Laft  = SS.x.AF;                        % [m] AF Root Chord Location WRT Rocket Nose
    Lfore = SS.x.FF;                        % [m] FF Root Chord Location WRT Rocket Nose
    RVeh  = FS.D/2;                         % [m] Vehicle Radius
    bfore = SS.b.FF;                        % [m] FF Span
    baft  = SS.b.AF;                        % [m] AF Span
    
    % Perform Descent Pitch Stability Analysis
    [CR] = StarshipPitchControlRatio(Nose_SS_Lcg, Lcp, Laft, Geometry);

    % Pitch Stability Check
    if strcmp(CR, 'fail') == 1
        fprintf('Pitch Stability Failure!\n%s\n', Tilda);
        VehicleResults.Pitch_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % Perform Descent Yaw Stability Analysis
    [CR] = StarshipYawControlRatio(Nose_SS_Lcg, Lcp, Laft, Lfore, RVeh, bfore, baft, Geometry);

    % Yaw Stability Check
    if strcmp(CR, 'fail') == 1
        fprintf('Yaw Stability Failure!\n%s\n', Tilda);
        VehicleResults.Yaw_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % Launch ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Earth Launch Simulation
    addpath(['C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\' ...
             '(1) Launch Code and Orbit Raising']);
    [Launch.S, Launch.C] = LAUNCH_FUNCTION(Raptor, SS_N_eng_SL, SS_N_eng_VAC, SH.N_eng, SS.OEW, ...
                                           SH.OEW, SS.Mppl, SH.Mppl, Wpay, Geometry);
    rmpath(['C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\' ...
            '(1) Launch Code and Orbit Raising']);

    % [kg] Mass of Vehicle at Launch Max Q
    iMaxQ        = find(Launch.S.q == max(Launch.S.q));
    StrMaxQ.QMax = Launch.S.q(iMaxQ);
    StrMaxQ.Tmag = Launch.S.Tmag(iMaxQ);
    StrMaxQ.W    = Launch.S.m(iMaxQ);
    StrMaxQ.SS_Wppl = SS.Mppl;
    StrMaxQ.SH_Wppl = StrMaxQ.W - SH.OEW - SS.TOGW;
    StrMaxQ.gamma   = Launch.S.gamma(iMaxQ);

    % [kg, m] CG Location of Propellant Tanks from Base - SH
    [SH.Wppl, SH.Lppl] = TankSizesPropWeightLocations(Vehicle.SH_Vppl(i), ...
                                                      StrMaxQ.SH_Wppl/SH.rho_ppl, FS.D);

    % [kg, m] CG Location of Propellant Tanks from Base - SS
    [SS.Wppl, SS.Lppl] = TankSizesPropWeightLocations(Vehicle.SS_Vppl(i), Vehicle.SS_Vppl(i), FS.D);

    % CG Location Inputs
    LVeh        = SS.H_Fuse + SS.H_Cone + SH.H_Fuse;    % [m]  Length of Vehicle - FS
    DVeh        = FS.D;                                 % [m]  Vehicle Diameter  - FS
    mVehDry     = SS.OEW + SH.OEW;                      % [kg] Dry Weight        - FS
    LloxSH_rest = SH.Lppl.LOX_Base;         % [m]  Location LOX  Tank Base WRT Rocket Base - SH 
    mLoxSH      = SH.Wppl.LOX;              % [kg] LOX  Weight                             - SH
    LmetSH_rest = SH.Lppl.Meth_Base;        % [m]  Location Meth Tank Base WRT Rocket Base - SH
    mMetSH      = SH.Wppl.Meth;             % [kg] Meth Weight                             - SH
    LloxSS_rest = SH.H_Fuse + SS.Lppl.LOX_Base;  % [m]  Location LOX  Tank Base WRT Rocket Base - SS
    mLoxSS      = SS.Wppl.LOX;                   % [kg] LOX  Weight                             - SS
    LmetSS_rest = SH.H_Fuse + SS.Lppl.Meth_Base; % [m]  Location Meth Tank Base WRT Rocket Base - SS
    mMetSS      = SS.Wppl.Meth;                  % [kg] Meth Weight                             - SS
    SS.x.FF = LVeh * SS.xbar.FF;            % [m]   Location from Nose - SS FF
    Lfore   = LVeh - SS.x.FF;               % [m]   Locaiton from Base - SS FF
    Sfore   = SS.Spln.FF;                   % [m^2] Planform Area      - SS FF
    SS.x.AF = LVeh * SS.xbar.AF;            % [m]   Location from Nose - SS AF
    Laft    = LVeh - SS.x.AF;               % [m]   Locaiton from Base - SS AF
    Saft    = SS.Spln.AF;                   % [m^2] Planform Area      - SS AF
    Lpay    = LVeh - Nose_Lpay;             % [m]   CG Location of Payload
    mPay    = Wpay;                         % [kg]  Payload Weight

    % [m] Full Stack of CG Location From Bottom of Vehicle
    [Bottom_Lcg] = FullStackCGLocation(LVeh, DVeh, mVehDry, LloxSH_rest, mLoxSH, LmetSH_rest, ...
                                       mMetSH, LloxSS_rest, mLoxSS, LmetSS_rest, mMetSS, Lfore, ...
                                       Sfore, Laft, Saft, Lpay, mPay);

    % Structural Analysis Inputs
    LVeh     = LVeh;                            % [m]  Length of Vehicle        - FS
    Nose_Lcg = LVeh - Bottom_Lcg;               % [m]  FS CG Location From Nose - FS
    VehTh    = StrMaxQ.gamma * pi/180;          % [deg -> rad] Flight Path Angle at MaxQ
    mVeh     = StrMaxQ.W;                       % [kg]        Weight of Vehicle at MaxQ - FS
    qMax     = StrMaxQ.QMax * 10^3;             % [kPa -> Pa] Launch Max Q
    S        = pi*(FS.D/2)^2;                   % [m^2]     Planform Area - FS
    CD       = 1.16;                            %           Drag Coeff    - FS
    Tmax     = StrMaxQ.Tmag * 10^3;             % [kN -> N] Max Launch Thrust
    throttle = 1;                               %           Throttle Setting
    ROutVeh  = FS.D/2;                          % [kg]      Radius of Vehicle
    ThVeh    = FS.t;                            % [m]       Wall Thickness - FS

    % Structural Analysis
    [Out] = MaxQPassFailFunction(LVeh, Nose_Lcg, VehTh, mVeh, qMax, S, CD, Tmax, throttle, ...
                                 ROutVeh, ThVeh);

    % Structural Check
    if strcmp(Out, 'fails') == 1,
        fprintf('Structural Failure!\n%s\n', Tilda);
        VehicleResults.Struc_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % [km/s] Delta-v Remaining After Launch
    fprintf('[km/s] dv Remaming After Launch\n\t%f \n', Launch.S.dv_remaining);

    % % [kg -> MT] Weight of Propellant After Launch
    % fprintf('[MT] Propellant Remaming After Launch\n\t%f \n', Launch.S.Mppl_remaining/1000);

    % Earth-Mars Transfer ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Trajectory Analysis
    EarthMarsTransfer.dv = 3.561;       % [km/s] Transfer dv
    EarthMarsTransfer.dt = 177.69;      % [days] Transfer Time of Flight

    % Mars Launch ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Mars Launch Analysis
    addpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\(6) Mars Launch');
    [MarsLaunch.S, MarsLaunch.C] = LAUNCH_FUNCTION_MARS(Raptor, SS_N_eng_SL, SS_N_eng_VAC, ...
                                                        SS.OEW, SS.Mppl, MarsWpay);
    rmpath('C:\Users\Taquito-Mini\Documents\GitHub\RSD\Trajectory\(6) Mars Launch');
    
    % [kg] Mass of Vehicle at Mars Launch Max Q
    iMaxQ        = find(MarsLaunch.S.q == max(MarsLaunch.S.q));
    StrMaxQ.QMax = MarsLaunch.S.q(iMaxQ);
    StrMaxQ.Tmag = MarsLaunch.S.Tmag(iMaxQ);
    StrMaxQ.W    = MarsLaunch.S.m(iMaxQ);
    StrMaxQ.SS_Wppl = StrMaxQ.W - SS.OEW - MarsWpay;
    StrMaxQ.gamma   = MarsLaunch.S.gamma(iMaxQ);

    % [kg, m] CG Location of Propellant Tanks from SS Base - SS
    [SS.Wppl, SS.Lppl] = TankSizesPropWeightLocations(Vehicle.SS_Vppl(i), ...
                                                                  StrMaxQ.SS_Wppl/SS.rho_ppl, FS.D);

    % Starship CG Location Inputs - Mars Launch
    LVeh    = SS.H_Cone + SS.H_Fuse;    % [m]   Vehicle Length - SS
    DVeh    = FS.D;                     % [m]   Starship Diameter
    mVehDry = SS.OEW;                   % [kg]  Dry Weight     - SS
    LloxSS_rest = SS.Lppl.LOX_Base;     % [m]   Location of LOX Base WRT Rocket Base
    mLoxSS      = SS.Wppl.LOX;          % [kg]  Mass of LOX
    LmetSS_rest = SS.Lppl.Meth_Base;    % [m]   Location of Meth Base WRT Rocket Base
    mMetSS      = SS.Wppl.Meth;         % [kg]  Mass of Meth
    SS.x.FF = LVeh * SS.xbar.FF;        % [m]   Location from Rocket Nose - SS FF
    Lfore   = LVeh - SS.x.FF;           % [m]   Locaiton from Rocket Base - SS FF
    Sfore   = SS.Spln.FF;               % [m^2] Planform Area             - SS FF
    SS.x.AF = LVeh * SS.xbar.AF;        % [m]   Location from Rocket Nose - SS AF
    Laft    = LVeh - SS.x.AF;           % [m]   Locaiton from Rocket Base - SS AF
    Saft    = SS.Spln.AF;               % [m^2] Planform Area             - SS AF
    Lpay    = LVeh - Nose_Lpay;         % [m]   CG Location of Payload WRT Rocket Base
    mPay = MarsWpay;                    % [kg]  Payload Weight
    
    % [m] Starship CG Location from Base of Rocket - Mars Launch
    [Bottom_SS_Lcg] = StarshipCGLocation(LVeh, DVeh, mVehDry, LloxSS_rest, mLoxSS, LmetSS_rest, ...
                                         mMetSS, Lfore, Sfore, Laft, Saft, Lpay, mPay);

    % Structural Analysis Inputs
    LVeh     = LVeh;                            % [m]  Length of Vehicle        - SS
    Nose_SS_Lcg = LVeh - Bottom_SS_Lcg;         % [m]  FS CG Location From Nose - SS
    VehTh    = StrMaxQ.gamma * pi/180;          % [deg -> rad] Flight Path Angle at MaxQ
    mVeh     = StrMaxQ.W;                       % [kg]        Weight of Vehicle at MaxQ - SS
    qMax     = StrMaxQ.QMax * 10^3;             % [kPa -> Pa] Launch Max Q
    S        = pi*(FS.D/2)^2;                   % [m^2]     Planform Area - SS
    CD       = 1.16;                            %           Drag Coeff    - SS
    Tmax     = StrMaxQ.Tmag * 10^3;             % [kN -> N] Max Launch Thrust
    throttle = 1;                               %           Throttle Setting
    ROutVeh  = FS.D/2;                          % [kg]      Radius of Vehicle
    ThVeh    = FS.t;                            % [m]       Wall Thickness - SS

    % Structural Analysis
    [Out] = MaxQPassFailFunction(LVeh, Nose_SS_Lcg, VehTh, mVeh, qMax, S, CD, Tmax, throttle, ...
                                 ROutVeh, ThVeh);

    % Structural Check
    if strcmp(Out, 'fails') == 1
        fprintf('Mars Launch Structural Failure!\n%s\n', Tilda);
        VehicleResults.Struc_Mars_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % [km/s] Delta-v Remaining After Mars Launch
    fprintf('[km/s] dv Remaming After Mars Launch\n\t%f\n', MarsLaunch.S.dv_remaining);

    % % [kg -> MT] Weight of Propellant After Mars Launch
    % fprintf('[MT] Propellant Remaming After Mars Launch\n\t%f\n', MarsLaunch.S.Mppl_remaining/1000);
    
    % Mars-Earth Transfer ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Trajectory Analysis
    MarsEarthTransfer.dv = 2.2534;       % [km/s] Transfer dv
    MarsEarthTransfer.dt = 198.288;      % [days] Transfer Time of Flight

    % Earth Capture ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % [km/s] Required dv for Earth Capture for 100 MT Payload LEO Orbit
    EarthCapture.dv = 0.9;

    % Earth Capture dv Check
    dvRemain = MarsLaunch.S.dv_remaining -  MarsEarthTransfer.dv;
    if dvRemain < EarthCapture.dv
        fprintf('Not Enough dv for Capture! %0.3f km/s\n%s\n', dvRemain, Tilda);
        VehicleResults.Earth_Capture_Fail(VehCount) = i;
        VehCount = VehCount + 1;
        continue;
    end

    % Vehicle Feasible Counter ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Save Vehicle if Pass
    VehicleResults.Pass(VehCount) = i;
    VehCount = VehCount + 1;

    % % Format Data Error Table
    % columnNames = {'Pass', 'Geo_Fail', 'Struc_Fail', 'Struc_Mars_Fail', 'Mars_G_Fail', 'Pitch_Fail', ...
    %                'Yaw_Fail', 'Earth_Capture_Fail'};
    % VehiclePerformance = ;

    % Print Tilda
    fprintf('%s\n', Tilda);
    
end

% Print Number of Passed Vehicles
IntPass = length(VehicleResults.Pass(isnan(VehicleResults.Pass) == 0));
fprintf('%d Feasible Vehicles\n%s\n', IntPass, Equal);

% Save Positions of Vehicles That Pass and Fail
save('Vehicle Results', 'VehicleResults', 'IntPass');

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%}
% Prints the Simulation Time
fprintf('Program Complete! (%0.3f seconds)\n', toc);
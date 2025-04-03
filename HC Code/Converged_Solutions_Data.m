clear all, clc, close all, format compact, format longG, tic;
%% Imports ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Constant Parameters
[C, SS, SH] = Constant_Parameters();

% Imported Data File
load('Reduced Data.mat');
VehicleData       = Reduce_Data;        clear Reduce_Data
VehicleChartTable = Reduce_Chart;       clear Reduce_Chart
VehicleNo = length(VehicleData.Wpay);

%% Vehicle Calculations ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Loop and Calculate
for i = 1: 1: VehicleNo

    % Starship Calculated Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Sea Level Thrust to Weight - Starship
    SS.TW0(i, 1) = (SS.N_eng * SS.ET0) / VehicleData.SS_TOGW(i);
    
    % [kg] Structure Weight - Starship
    SS.Wstr(i, 1) = SS.Istr * VehicleData.SS_Swet(i);
    
    % [kg] Engine Weight - Starship
    SS.Weng(i, 1) = SS.TW0(i) * VehicleData.SS_WR(i)/SS.E_TW * (VehicleData.SS_OEW(i) + VehicleData.Wpay(i));
    
    % [kg] Constant Systems Weight - Starship
    SS.Csys(i, 1) = SS.Cun;
    
    % [kg] Systems Weight - Starship
    SS.Wsys(i, 1) = SS.Csys(i) + SS.fsys*VehicleData.SS_OEW(i);
    
    % [m^3] Total Volume - Starship
    SS.Vtot(i, 1) = VehicleData.SS_tau(i) * VehicleData.SS_Spln(i)^1.5;
    
    % [m^3] Fix Systems Volume - Starship
    SS.Vfix(i, 1) = SS.Vun;
    
    % [m^3] Propellant Volume - Starship
    SS.Vppl(i, 1) = VehicleData.SS_OWEv(i) * (VehicleData.SS_WR(i) - 1) / SS.rho_ppl;
    
    % [m^3] Systems Volume - Starship
    SS.Vsys(i, 1) = SS.Vfix(i) + SS.kvs*SS.Vtot(i);
    
    % [m^3] Engine Volume - Starship
    SS.Veng(i, 1) = SS.kve * SS.TW0(i) * VehicleData.SS_WR(i) * VehicleData.SS_OWEv(i);
    
    % [m^3] Void Volume - Starship
    SS.Vvv(i, 1) = SS.kvv * SS.Vtot(i);
    
    % [m^3] Payload Volume - Starsip
    SS.Vpay(i, 1) = VehicleData.Wpay(i) / C.rho_pay;
    
    % Superheavy Calculated Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Sea Level Thrust to Weight - Superheavy
    SH.TW0(i, 1) = (SH.N_eng * SH.ET0) / VehicleData.SH_TOGW(i);
    
    % [kg] Structure Weight - Superheavy
    SH.Wstr(i, 1) = SH.Istr * VehicleData.SH_Swet(i);
    
    % [kg] Engine Weight - Superheavy
    SH.Weng(i, 1) = SH.TW0(i) * VehicleData.SH_WR(i)/SH.E_TW * (VehicleData.SH_OEW(i));
    
    % [kg] Constant Systems Weight - Superheavy
    SH.Csys(i, 1) = SH.Cun;
    
    % [kg] Systems Weight - Superheavy
    SH.Wsys(i, 1) = SH.Csys(i) + SH.fsys*VehicleData.SH_OEW(i);
    
    % [m^3] Total Volume - Superheavy
    SH.Vtot(i, 1) = VehicleData.SH_tau(i) * VehicleData.SH_Spln(i)^1.5;
    
    % [m^3] Fix Systems Volume - Superheavy
    SH.Vfix(i, 1) = SH.Vun;
    
    % [m^3] Propellant Volume - Superheavy
    SH.Vppl(i, 1) = VehicleData.SH_OWEv(i) * (VehicleData.SH_WR(i) - 1) / SH.rho_ppl;
    
    % [m^3] Systems Volume - Superheavy
    SH.Vsys(i, 1) = SH.Vfix(i) + SH.kvs*SH.Vtot(i);
    
    % [m^3] Engine Volume - Superheavy
    SH.Veng(i, 1) = SH.kve * SH.TW0(i) * VehicleData.SH_WR(i) * VehicleData.SH_OWEv(i);
    
    % [m^3] Void Volume - Superheavy
    SH.Vvv(i, 1) = SH.kvv * SH.Vtot(i);

end
clear i

%% Calculated Data Table ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Save Calculated Data
CalcData = [VehicleData.Wpay/1000, VehicleData.v_sep, VehicleData.SS_tau, VehicleData.SH_tau, VehicleData.FS_tau, ...
            SS.TW0, SS.Wstr/1000, SS.Weng/1000, SS.Wsys/1000, SS.Vtot, SS.Vfix, SS.Vppl, SS.Vsys, SS.Veng, SS.Vvv, SS.Vpay, ...
            SH.TW0, SH.Wstr/1000, SH.Weng/1000, SH.Wsys/1000, SH.Vtot, SH.Vfix, SH.Vppl, SH.Vsys, SH.Veng, SH.Vvv,        ];

% Define the table column names
columnNames = {'Wpay (Ton)', 'v_sep (km/s)' , 'SS_tau',        'SH_tau',        'FS_tau',  ...
		       'SS_TW0',     'SS_Wstr (Ton)', 'SS_Weng (Ton)', 'SS_Wsys (Ton)', 'SS_Vtot (m^3)', 'SS_Vfix (m^3)', 'SS_Vppl (m^3)', 'SS_Vsys (m^3)', 'SS_Veng (m^3)', 'SS_Vvv (m^3)', 'SS_Vpay (m^3)', ...
               'SH_TW0',     'SH_Wstr (Ton)', 'SH_Weng (Ton)', 'SH_Wsys (Ton)', 'SH_Vtot (m^3)', 'SH_Vfix (m^3)', 'SH_Vppl (m^3)', 'SH_Vsys (m^3)', 'SH_Veng (m^3)', 'SH_Vvv (m^3)',                };

% Convert the numeric array to a table
CalculatedData = array2table(CalcData, 'VariableNames', columnNames);

% Output txt File of Tables
writetable(CalculatedData, 'CalculatedData.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);
writetable(DATA_Error, 'DATA_Error.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);
writetable(VehicleChartTable, 'VehicleChartTable.txt', ...
           'Delimiter', '\t', ...
           'WriteRowNames', true);

%% ~~~
%}
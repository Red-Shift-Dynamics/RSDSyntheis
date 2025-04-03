clear all, clc, close all, format compact, format longG, tic;
%% Inputs

% [m] Diameter and Radius
D = 9;      
R = D/2;

% [m] Nose Cone Height - Starship
SS.H_Nose = 13.65;

% [m] Fuselage Height - Starship
SS.H_Fuse = 56.52;

% [m] Fuselage Height - Superheavy
SH.H_Fuse = 71;

% [m] Fore and Aft Flaps Span - Starship
SS.b_FF = 4.21;
SS.b_AF = 4.30;

% [m] Fore and Aft Mean Aero Cord - Starship
SS.cbar_FF = 5.57;
SS.cbar_AF = 4.05;

% [m] Fore and Aft Flaps Thickness - Starship
SS.t.FF = 0.53;
SS.t.AF = 0.53;

%% Calculation

% Nose Cone ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m^2] Cone - Planform Area
SS.Spln.Cone = R * SS.H_Nose / 2;

% [m^2] Cone - Wetted Area
SS.Swet.Cone = pi * R * sqrt(R^2 + SS.H_Nose^2);

% [m^3] Cone - Volume
SS.V.Cone = pi * D^2 * SS.H_Nose / 6;

% Fuselage ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m^2] Fuselage - Starship - Planfrom Area
SS.Spln.Fuse = D * SS.H_Fuse;

% [m^2] Fuselage - Starship - Wetted Area
SS.Swet.Fuse = pi * D * SS.H_Fuse;

% [m^3] Fuselage - Starship - Volume
SS.V.Fuse = pi * (D/2)^2 * SS.H_Fuse;

% [m^2] Fuselage - Superheavy - Planfrom Area
SH.Spln.Fuse = D * SH.H_Fuse;

% [m^2] Fuselage - Superheavy - Wetted Area
SH.Swet.Fuse = pi * D * SH.H_Fuse;

% [m^3] Fuselage - Superheavy - Volume
SH.V.Fuse = pi * (D/2)^2 * SH.H_Fuse;

% Flaps ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m^2] Fore Flap - Planform Area
SS.Spln.FF = SS.b_FF * SS.cbar_FF;

% [m^2] Fore Flap - Wetted Area
SS.Swet.FF = 2*(SS.Spln.FF + SS.b_FF*SS.t.FF);

% [m^3] Fore Flap - Volume
SS.V.FF = SS.t.FF * SS.Spln.FF;

% [m^2] Aft Flap - Planform Area
SS.Spln.AF = SS.b_AF * SS.cbar_AF;

% [m^2] Aft Flap - Wetted Area
SS.Swet.AF = 2*(SS.Spln.AF + SS.b_AF*SS.t.AF);

% [m^3] Aft Flap - Volume
SS.V.AF = SS.t.AF * SS.Spln.AF;

% [m^2] Fore and Aft Flaps - Planform Area
SS.Spln.Flaps = 2*(SS.Spln.FF + SS.Spln.AF);

% [m^2] Fore and Aft Flaps - Wetted Area
SS.Swet.Flaps = 2*(SS.Swet.FF + SS.Swet.AF);

% [m^3] Fore and Aft Flaps - Volume
SS.V.Flaps = 2*(SS.V.FF + SS.V.AF);

% Grid Fins ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m^2] Grid fins - Planform Area
SH.Spln.GF = 0;

% [m^2] Grid fins - Wetted Area
SH.Swet.GF = 0;

% [m^3] Grid fins - Volume
SH.V.GF = 0;

% Full Stack ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% [m^2] Starship - Planform Area
SS.Spln = SS.Spln.Cone + SS.Spln.Fuse + SS.Spln.Flaps;

% [m^2] Superheavy - Planform Area
SH.Spln = SH.Spln.Fuse + SH.Spln.GF;

% [m^2] Starship - Planform Area
SS.Swet = SS.Swet.Cone + SS.Swet.Fuse + SS.Swet.Flaps;

% [m^2] Superheavy - Planform Area
SH.Swet = SH.Swet.Fuse + SH.Swet.GF;

% [m^3] Starship - Planform Area
SS.V = SS.V.Cone + SS.V.Fuse + SS.V.Flaps;

% [m^3] Superheavy - Planform Area
SH.V = SH.V.Fuse + SH.V.GF;

% [m^2] Full Stack - Planform Area
FS.Spln = SS.Spln + SH.Spln;

% [m^2] Full Stack - Wetted Area
FS.Swet = SS.Swet + SH.Swet;

% [m^3] Full Stack - Volume
FS.V = SS.V + SH.V;

%% ~~~
%}
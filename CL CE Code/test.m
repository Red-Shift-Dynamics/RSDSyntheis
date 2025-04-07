clear all, clc, close all, format compact, format longG, tic;
%% Inputs

% [m] Diameter and Radius
D = 9;      
R = D/2;

% [m] Nose Cone Height - Starship
SS.H_Nose = 13.65;

% Nose Cone Equation - Starship
syms x
n = 0.6;
f(x) = R * (x / SS.H_Nose)^n;       
% f(x)  = R * x / SS.H_Nose;
% f(x) = sqrt((SS.H_Nose/2)^2 - (x - SS.H_Nose/2)^2);
df(x) = diff(f, x);

%% Calculations

% [m^2] Cone - Planform Area
SS.Spln.Cone = 2 * double(int(f(x), x, 0, SS.H_Nose));

% [m^2] Cone - Wetted Area
SS.Swet.Cone = 2*pi * double(int([f(x)*sqrt(1 + (df(x))^2)], x, 0, SS.H_Nose));

% [m^3] Cone - Volume
SS.V.Cone = pi * double(int([(f(x))^2], x, 0, SS.H_Nose));

SS.Spln.Cone
SS.Swet.Cone
SS.V.Cone

%% ~~~
%}

%{
syms x
n = 0.6;
f(x) = R * (x / SS.H_Nose)^n;       
% f(x)  = R * x / SS.H_Nose;
% f(x) = sqrt((SS.H_Nose/2)^2 - (x - SS.H_Nose/2)^2);
df(x) = diff(f, x);

%% Calculations

% [m^2] Cone - Planform Area
SS.Spln.Cone = 2 * double(int(f(x), x, 0, SS.H_Nose));

% [m^2] Cone - Wetted Area
SS.Swet.Cone = 2*pi * double(int([f(x)*sqrt(1 + (df(x))^2)], x, 0, SS.H_Nose));

% [m^3] Cone - Volume
SS.V.Cone = pi * double(int([(f(x))^2], x, 0, SS.H_Nose));

%}
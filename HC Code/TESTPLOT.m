clear all, clc, close all, format compact, format longG, tic
%%

P.Color = 'Black';

Spln = [1: 2: 100];
OEW  = [1: 1: 50];

% [kg, m^2] Plot OEW vs Planform Area
Plot_Spln_vs_OEW(Spln, OEW, P);

%% ~~~
%}
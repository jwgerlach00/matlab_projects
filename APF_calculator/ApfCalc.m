% Jacob Gerlach
% jwgerlac@ncsu.edu
% 8/19/2020
% ApfCalc.m
%
% This script calculates atomic packing factor (apf) and density based on
% user input along with associated error based on input uncertainty values.

clear
clc
close all


%% Declarations

% Variables

atmNum = 4; % number of atoms per 1 unit cell
atmWeight = 63.5; % atomic weight (g/mol)
rad = 1.28e-10; % radius of atom (m)
drad = 1.28e-12; % radius uncertainty (m)
a = 3.62e-10; % 1st unit cell side length (m)
da = 3.60e-12; % 1st side length uncertainty (m)
b = 3.62e-10; % 2nd unit cell side length (m)
db = 3.60e-12; % 2nd side length uncertainty (m)
c = 3.62e-10; % 3rd unit cell side length (m)
dc = 3.60e-12; % 3rd side length uncertainty (m)

% Anonymous functions

APFError = @(r,dr,a,da,b,db,c,dc,apf) apf*sqrt((3*(dr/r))^2 + (da/a)^2 + (db/b)^2 + (dc/c)^2); % APF error formula
RhoError = @(rho,a,da,b,db,c,dc) rho*sqrt((da/a)^2 + (db/b)^2 + (dc/c)^2); % density error formula
VolConv = @(mVol) mVol*(1e3); % unit conversion formula: kg/m^3 to g/cm^3


%% Calculations

atmVol = SphVol(rad); % calculates/assigns volume of atom (m^3)
cellVol = RecVol(a,b,c); % calculates/assigns volume of unit cell (m^3)
cellVolCm = VolConv(cellVol); % converts/assigns volume to cm^3


[apf,density] = APFDens(atmVol, cellVol, atmNum, atmWeight); % calculates atomic packing factor (APF), density (kg/m^3)
[~,densityCm] = APFDens(atmVol, cellVolCm, atmNum, atmWeight); % calculates density (g/cm^3)

apfError = APFError(rad,drad,a,da,b,db,c,dc,apf); % calculates the APF error
rhoError = RhoError(density,a,da,b,db,c,dc); % calculates the density error in kg/m^3
rhoErrorCm = RhoError(densityCm,a,da,b,db,c,dc); % calculates the density error in g/cm^3

%% Output

% Command window

fprintf('APF = %.3f %c %.3f\n',apf,177,apfError); % APF, apf error
fprintf('%.1f%% of space is occupied\n',apf*100); % space occupied
fprintf('rho = %.0f %c %.0f kg/m%c\n',density,177,rhoError,179); % density (kg/m^3), density error
fprintf('rho = %.3f %c %.3f g/cm%c\n',densityCm,177,rhoErrorCm,179); % density (g/cm^3), density error

% Message box: assigns above print commands to vars and displays in msgbox

msg1 = sprintf('APF = %.3f %c %.3f\n',apf,177,apfError);
msg2 = sprintf('%.1f%% of space is occupied\n',apf*100);
msg3 = sprintf('rho = %.0f %c %.0f kg/m%c\n',density,177,rhoError,179);
msg4 = sprintf('rho = %.3f %c %.3f g/cm%c\n',densityCm,177,rhoErrorCm,179);
msgbox({msg1,msg2,msg3,msg4},'RESULTS'); % create message box w/ 4 output lines

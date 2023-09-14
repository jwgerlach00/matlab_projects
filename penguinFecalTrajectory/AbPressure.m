function p = AbPressure(v0,theta,h)
% Jacob Gerlach
% jwgerlac@ncsu.edu
% 8/28/2020
% AbPressure.m
%
% Calculates penguin abdominal pressure (Pa).

g = 9.81; % acceleration due to gravity (m/s^2)
c = 0.611; % coefficient of contraction
rho = 1141; % mass density of faeces (kg/m^3)
rHole = 0.004; % radius of bottom hole (m)
rStom = 0.1; % radius of stomach (m)

v0x = v0*cosd(theta); % x velocity component
v0y = v0*sind(theta); % y velocity component

t = (v0*sin(theta))/g + sqrt(((v0^2)*((sin(theta))^2))...
    /g^2 + (2*h)/g); % grounding time (s)
volume = ((c*pi*rHole^2)/(2*g))*(v0y*v0 - (v0y - g*t)*...
    sqrt((g*t - v0y)^2 + v0x^2) - v0x^2*log((sqrt((g*t - v0y)^2 + v0x^2)...
    - g*t + v0y)/(v0 + v0y))); % fluid volume (m^3)
p = (0.5*rho*v0^2 - ((rho*g)/(pi*rStom^2))*volume); % pressure (Pa)
end

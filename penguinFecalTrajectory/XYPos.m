function [xPos, yPos] = XYPos(v0, theta, y0, t)
% Jacob Gerlach
% jwgerlac@ncsu.edu
% 8/28/2020
% XYPos.m
%
% Calculates the x and y trajectory postion in relation to time.

g = 9.81; % gravitational constant (m/s^2)
xPos = v0.*t.*cosd(theta);
yPos = y0 + v0.*t.*sind(theta) - .5*g.*t.^2;
end

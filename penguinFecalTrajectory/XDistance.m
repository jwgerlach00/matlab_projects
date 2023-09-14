function x = XDistance(v0, theta, y0)
% Jacob Gerlach
% jwgerlac@ncsu.edu
% 8/28/2020
% XDistance.m
%
% Calculates x distance (m) traveled given initial kinematics parameters.

g = 9.81; % acceleration due to gravity (m/s^2)
x = v0.*cosd(theta).*((v0.*sind(theta))./g + sqrt((v0.^2*...
    (sind(theta)).^2)./g^2 + 2*y0/g));
end

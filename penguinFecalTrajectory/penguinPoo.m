% Jacob Gerlach
% jwgerlac@ncsu.edu
% 8/28/2020
% penguinPoo.m
%
% Calculates ideal penguin poop velocity, launch angle, and abdominal
% pressure required to reach a desired target.

clear
clc
close all

%% Declarations
g = 9.81; % acceleration due to gravity (m/s^2)
angFixed = 45; % fixed angle (degrees)
vRange = linspace(0,3,1000); % velocity range (m/s)
height = 1; % initial height (m)
target = 0.9; % target distance (m)
horizontal = linspace(target,target,1000); % horizontal plot line
angRange = linspace(-90,90,1000); % angle range (degrees) 
vFixed = 2; % fixed velocity (m/s)

%% Anonymous Functions
Time = @(v0,theta,y0) (v0.*sind(theta))./g + sqrt((v0.^2.*(sind(theta))...
    .^2)./g^2 + 2*y0/g);

%% Calculations
% Distance
distOfV = XDistance(vRange, angFixed, height); % function of velocity
distOfAng = XDistance(vFixed, angRange, height); % function of angle

% Automated ideal velocity
[~,x1] = min(abs(distOfV - target));
vIdeal = vRange(x1);
[~,x2] = min(abs(distOfAng - target));

% Automated ideal angles
ang1 = angRange(x2);
distOfAng2 = distOfAng; % makes a copy
distOfAng2(x2) = []; % deletes first angle to find second
[~,x3] = min(abs(distOfAng2 - target));
ang2 = angRange(x3);

% Time (s) to hit target
tMinus = Time(vFixed,ang1,height);
tPlus = Time(vFixed,ang2,height);
tV = Time(vIdeal,angFixed,height);

% X/Y position
[xVInt,yVInt] = XYPos(vIdeal,angFixed,height,linspace(0,tV,1000));
[xMinus,yMinus] = XYPos(vFixed,ang1,height,linspace(0,tMinus,1000));
[xPlus,yPlus] = XYPos(vFixed,ang2,height,linspace(0,tPlus,1000));

% Abdominal pressure
pV = AbPressure(vIdeal,angFixed,height);
pAng1 = AbPressure(vFixed,ang1,height);
pAng2 = AbPressure(vFixed,ang2,height);

% Converts Pa to pKa
pV = pV/1000;
pAng1 = pAng1/1000;
pAng2 = pAng2/1000;

%% Output
% Ideal velocity/angles
fprintf('At a launch angle of %.2f degrees, the ideal initial velocity is %.3f m/s\n',angFixed,vIdeal);
fprintf('At an initial velocity of %.3f m/s, the ideal launch angles are %.2f degrees and %.2f degrees\n',vFixed,ang1,ang2);

% Abdominal pressure
fprintf('\nAbdominal pressure to reach the target with the %.3f initial velocity is %.4f kPa\n',vIdeal,pV);
fprintf('Abdominal pressure to reach the target at the %.2f degree launch angle: %.4f kPa\n',ang1,pAng1);
fprintf('Abdominal pressure to reach the target at the %.2f degree launch angle: %.4f kPa\n',ang2,pAng2);

% Plot: Function of Velocity
figure('Name','As a Function of Velocity Magnitude');
plot(vRange,distOfV,vRange,horizontal);
xlabel('Velocity (m/s)');
ylabel('Distance (m)');
title('Penguin Poo Distance as a Function of Velocity Magnitude');
legend('Distance Traveled','Target Distance');

% Plot: Function of Launch Angle
figure('Name','As a Function of Lanch Angle');
plot(angRange,distOfAng,angRange,horizontal);
xlabel('Launch Angle (degrees)');
ylabel('Distance (m)');
title('Penguin Poo Distance as a Function of Launch Angle');
legend('Distance Traveled','Target Distance');

% Plot: X,Y Position
figure('Name','Verticle vs. Horizontal Displacement')
plot(xVInt,yVInt,xMinus,yMinus,xPlus,yPlus);
xlabel('Horizontal Displacement (m)');
ylabel('Vertical Displacement (m)');
title('Penguin Poo Vertical Displacement vs. Horizontal Displacement');
legend('Ideal Velocity','Ideal Negative Angle','Ideal Positive Angle'); 

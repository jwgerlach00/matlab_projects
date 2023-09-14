% Jacob Gerlach
% jwgerlac@ncsu.edu
% 9/30/2020
% marathon.m
%
% Generates race time statistics based on a time table

clear
clc
close all

%% Declarations
timeData = fopen('timeData.dat','w'); % New table
times = xlsread('raceTimes.xlsx'); % Time table input
miles = size(times,1); % Number of miles
milesPlot = (1:miles)';

%% Calculations
pace(1) = (times(1,1)*60 + times(1,2) + times(1,3)/60);
for k = 2:miles
    pace(k) = (times(k,1)*60 + times(k,2) + times(k,3)/60) - ...
        (times(k-1,1)*60 + times(k-1,2) + times(k-1,3)/60);
end
pace = pace';
speed = 60./pace; % miles/hour

for k = 1:miles
     paceMin(k) = fix(pace(k));
     paceSec(k) = round(rem(pace(k),1)*60);
     if paceSec(k) == 60
         paceMin(k) = paceMin(k) + 1;
         paceSec(k) = 0;
     end
end
paceSec = paceSec';
paceMin = paceMin';

% Average Pace (min/hr)
avgPace = sum(pace)/miles;
avgPaceMin = fix(avgPace);
avgPaceSec = rem(avgPace,1)*60;
if avgPaceSec == 60
    avgPaceMin = paceMin(k) + 1;
    avgPaceSec = 0;
end
fprintf('Average pace over entire run: %2.2i:%2.2i\n',avgPaceMin,...
    round(avgPaceSec));

% Fastest Pace
% fast = min(pace);
% fastSec = rem(fast,1)*60;
% fastMin = fix(fast);
% fastMile = find((pace==fast));
% fprintf('Fastest mile: %2.2i:%2.2i at mile %i\n',fastMin,...
%     round(fastSec),fastMile);

% Fast/Slow Mile (mph)
fast = max(speed);
fastMile = find((speed==fast));
slow = min(speed);
slowMile = find((speed==slow));
fprintf('Fastest mile: %.2f mph at mile %i\n',fast,fastMile);
fprintf('Slowest mile: %.2f mph at mile %i\n',slow,slowMile);

%% Output
% Plots
subplot(2,1,1)
plot(milesPlot,pace)
title('Pace as a Function of Mile')
xlabel('Mile');
ylabel('Pace (min/mile)');
subplot(2,1,2)
plot(milesPlot,speed)
title('Speed as a Function of Mile')
xlabel('Mile');
ylabel('Speed (mph)');
saveas(gcf,'figure1.png'); % Export figure1
figure
yyaxis left
plot(milesPlot,pace)
ylabel('Pace (min/mile)');
yyaxis right
plot(milesPlot,speed)
ylabel('Speed (mph)');
title('Pace and Speed as a Function of Mile')
xlabel('Mile Number');
saveas(gcf,'figure2.png'); % Export figure2

% Excel Sheet Output
paceOut = [milesPlot,paceMin,paceSec];
paceHead = {'Mile','Pace (min)','Pace(sec)'};
speedOut = [milesPlot,speed];
speedHead = {'Mile', 'Speed (mph)'};
xlswrite('paceData.xlsx',paceHead,'Sheet1','A1');
xlswrite('paceData.xlsx',paceOut,'Sheet1','A2');
xlswrite('speedData.xlsx',speedHead,'Sheet1','A1');
xlswrite('speedData.xlsx',speedOut,'Sheet1','A2');

% New Table .dat
for k = 1:miles
    fprintf(timeData,'%2.i %2.2i:%2.2i:%2.2i\n',milesPlot(k),times(k,1),...
        times(k,2),times(k,3));
end
fclose(timeData);

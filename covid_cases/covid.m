% Jacob Gerlach
% jwgerlac@ncsu.edu
% 10/14/2020
% covid.m
% 
% Displays stats related to covid 19 cases

clc
clear
close all

%% Declarations
dataTotal = xlsread('CV19cases.xlsx');
tTest = 90; % day number
dTot = 245; % days to extrapolate to
dFit = 92; % days to use for fit
yMax = 5000; % max y for plot
linNum = 10000; % extrapolation linspace size

daysTot = (1:dTot)';
daysFit = (1:dFit)';
daysExt = linspace(min(daysTot),max(daysTot),linNum);
dataFit = dataTotal(1:dFit); % data used to fit

%% Calculations
lineFit = polyfit(daysFit,dataFit,1); % linear fit
lineVal = polyval(lineFit, daysTot);
quadFit = polyfit(daysFit,dataFit,2); % quadratic fit
quadVal = polyval(quadFit, daysTot);

[expFit,gofExp] = fit(daysFit,dataFit,'exp1'); % exponential fit
[gaussFit,gofGauss] = fit(daysFit,dataFit,'gauss1'); % gaussian fit

extrapL = interp1(daysFit,dataFit,daysExt,'linear','extrap'); %linear
extrapS = interp1(daysFit,dataFit,daysExt,'spline','extrap'); % spline

% R^2 Values: Calculated using the first 92(dataFit) data points
corrVals(1) = (corr(dataFit,lineVal(1:dFit)))^2;
corrVals(2) = (corr(dataFit,quadVal(1:dFit)))^2;
corrVals(3) = gofExp.rsquare;
corrVals(4) = gofGauss.rsquare;

%% Output
plot((1:length(dataTotal)),dataTotal,'k.',daysTot,lineVal,'g',daysTot,...
    quadVal,'r',daysExt,extrapL,'m',daysExt,extrapS,'b');
axis([0 daysTot(end) 0 yMax]); % size axis
hold on
plot(expFit,'c');
plot(gaussFit,'k');
title('Confirmed COVID-19 cases in NC from 3/1 until 9/30');
legend('Data', 'Linear', 'Quadratic', 'Linear Extrap', 'Spline Extrap',...
    'Exponential', 'Gauss');
xlabel('days from 3/1');
ylabel('cases');
hold off

fprintf('Number of cases on day %i was\n',tTest);
fprintf('   %.1f (linear fit)\n',lineVal(tTest));
fprintf('   %.1f (quadratic fit)\n',quadVal(tTest));
fprintf('   %.1f (exponential fit)\n',expFit(tTest));
fprintf('   %.1f (gaussian fit)\n',gaussFit(tTest));
fprintf('   %.1f (linear interpolation)\n',...
    extrapL(round((tTest/max(daysTot))*linNum)));
fprintf('   %.1f (spline fit)\n',...
    extrapS(round((tTest/max(daysTot))*linNum)));
fprintf('Actual number of cases was %i\n\n',dataTotal(tTest));

fprintf('R%c values (based on up to %i day data):\n',178,dFit);
fprintf('   Linear R%c: %.4f\n',178,corrVals(1));
fprintf('   Quadratic R%c: %.4f\n',178,corrVals(2));
fprintf('   Exponential R%c: %.4f\n',178,corrVals(3));
fprintf('   Gaussian R%c: %.4f\n',178,corrVals(4));
if max(corrVals) == corrVals(1)
    fprintf('Linear has the highest R%c\n',178);
elseif max(corrVals) == corrVals(2)
    fprintf('Quadratic has the highest R%c\n',178);
elseif max(corrVals) == corrVals(3)
    fprintf('Exponential has the highest R%c\n',178);
elseif max(corrVals) == corrVals(4)
    fprintf('Gaussian has the highest R%c\n',178);
end

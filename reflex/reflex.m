% Jacob Gerlach
% jwgerlac@ncsu.edu
% 10/14/2020
% reflex.m
% 
% Displays stats regarding reflex data in relation to age given an excel
% file input

clc
clear
close all

%% Declarations
reflexData = xlsread('reflexData.xlsx'); % import excel file
age = reflexData(1, :); % age row (1st row of excel)
reflexData(1, :) = []; % delete age row
histoAge = 10; % specific age (must be in age)
skewVal = 0.02; % skew test

%% Calculations
avgReflex = mean(reflexData); % average reflex
error = std(reflexData); % standard deviation
ageIndex = find(age == histoAge);
medReflex = median(reflexData(:, ageIndex)); % median reflex
reflexAge = reflexData(:, ageIndex); % reflex for specific age

if abs(medReflex - avgReflex) <= skewVal % skew test
    skewed = 'No skewness\n';
elseif avgReflex > medReflex
    skewed = 'Skewed right\n';
else
    skewed = 'Skewed left\n';
end

iqr = iqr(reflexAge); % interquartile range
outRange = quantile(reflexAge, [0.25 0.75]);
outliers = reflexAge((reflexAge < (outRange(1) - 1.5*iqr)) |...
    (reflexAge > (outRange(2) + 1.5*iqr)));

%% Output
errorbar(age, avgReflex, error, 'o');
title('Reflex Times');
xlabel('Age (years)');
ylabel('Reflex Time (s)');

figure
sgtitle('Reflex Times'); 
subplot(1,2,1);
bar(age, avgReflex);
xlabel('Age (years)');
ylabel('Reflex Time (s)');
hold on
er = errorbar(age, avgReflex, -error, error);
er.LineStyle = 'none';
hold off
subplot(1,2,2);
boxplot(reflexData, age);
xlabel('Age (years)');
ylabel('Reflex Time (s)');

figure
histogram(reflexAge);
title(['Reflex Times for Age ', num2str(age(ageIndex))]);
xlabel('Reflex Time (s)');
ylabel('Count');

fprintf('Age %i:\n--------\n', histoAge);
fprintf('Mean: %.2f %c %.2f\n', avgReflex(ageIndex), 177, error(ageIndex));
fprintf('Median: %.2f\n', medReflex);
fprintf(skewed);

if isempty(outliers)
    fprintf('No outliers\n');
else
    fprintf('Outliers:\n');
    fprintf(' %.2f\n',outliers);
end

f4 = figure;
    sgtitle('Reflex Times');
for k = 1:size(reflexData,1)
    figure(f4); % animates on only the 4th figure
    newReflex = reflexData((1:k),:);
    avgReflex = mean(newReflex,1);
    error = std(newReflex,0,1);
    
    subplot(1,2,1);
    bar(age, avgReflex);
    xlabel('Age (years)');
    ylabel('Reflex Time (s)');
    hold on
    er = errorbar(age, avgReflex, -error, error);
    er.LineStyle = 'none';
    hold off
    subplot(1,2,2);
    boxplot(newReflex, age);
    pause(0.05);
end
figure(f4);
xlabel('Age (years)');
ylabel('Reflex Time (s)');

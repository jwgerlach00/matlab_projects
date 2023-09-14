% Jacob Gerlach
% jwgerlac@ncsu.edu
% 10/21/2020
% tuner.m
%
% Records input audio file and compares it to all possible notes. Tell user
% whether they are within a reasonable distance from the desired note using
% color indication.

clc
clear
close all
clearvars -except myPi

%% Declarations
audioLength = 1; % duration of recorded audio file (sec)
maxFreq = 10000; % largest expected frequency
minFreq = 30; % smallest expected frequency

fileName = 'audio_high.wav'; % Audio file name as a string

% Anonymous functions (if any)
Cents = @(f0, fNote) log2(f0/fNote)*1200;
Note = @(f, r) sin(linspace(0,2*pi*f,r));
% Note = @(t,freq,oct,rate) sin(linspace(0,2*pi*t*freq*2^oct,round(t*rate)));

%% Load and FFT data
% Use audioread() to import the signal and rate. See its help file and use
% the variable names signal and rate (or change the names in the myFFT. Be
% sure that the filename is the variable defined above
[signal, rate] = audioread(fileName);

% Transform your data using myFFT
[freq,power] = myFFT(signal,minFreq,maxFreq,rate);

%% Plot frequency spectra
subplot(2,1,1);
semilogy(freq/1000, power); % semilog
subtitle('Frequency spectrum');
xlabel('Frequency (kHz)');
ylabel('Power (AU)');

subplot(2,1,2);
plot(freq/1000, power); % linear
subtitle('Frequency spectrum');
xlabel('Frequency (kHz)');
ylabel('Power (AU)');

%% Find what note is closest using NoteFinder
% Find frequency that has maximum magnitude
[~, maxIndex] = max(power);
f0 = freq(maxIndex); % frequency with greatest power

% Determine what note is closest to max frequency
[note, noteFreq, octave] = NoteFinder(f0);

% Display max frequency, closest note and its frequency, and cents diff
fprintf('Frequency is %i Hz\n', f0);
fprintf('Closest to %s located at %.2f Hz\n', note, noteFreq);

% fprintf('Off by %.2f cents',);
cents = Cents(f0, noteFreq);
fprintf('Off by %.2f cents\n', cents);

%% Polar Plot
figure;
lineLoc = (90 - cents)*pi/180;
polarplot([65 90 115; 65 90 115]*pi/180, [0 0 0; 1 1 1], 'k--',...
    [40 140; 40 140]*pi/180, [0 0; 1 1], 'k');
hold on;
polarplot([lineLoc; lineLoc], [0; 1], 'r', 'linewidth', 2);
hold off;
set(gca,'rtick',[]);
set(gca,'thetatick',[]);
grid off;
thetalim([40 140]);
text(40*pi/180,1.05,'50','HorizontalAlignment','center','rotation',-40);
text(65*pi/180,1.05,'25','HorizontalAlignment','center','rotation',-25);
text(90*pi/180,1.05,'0','HorizontalAlignment','center');
text(115*pi/180,1.05,'-25','HorizontalAlignment','center','rotation',25);
text(140*pi/180,1.05,'-50','HorizontalAlignment','center','rotation',40);
text(lineLoc,-.05,num2str(round(cents,2)),'color','r',...
    'HorizontalAlignment','center');

%% Hear Frequencies
hear = input('Would you like to hear the frequencies? [yes/no]\n','s');
while strcmpi(hear,'yes') == 0 && strcmpi(hear,'no') == 0 
    hear = input('Would you like to hear the frequencies? [yes/no]\n','s');
end
if strcmpi(hear,'yes') % play sounds
    sound(Note(f0, rate), rate);
    pause(audioLength);
    sound(Note(noteFreq, rate), rate);
    pause(audioLength);
    sound(Note(f0, rate), rate);
    sound(Note(noteFreq, rate), rate);
end
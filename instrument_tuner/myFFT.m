function [freqFFT,powerFFT] = myFFT(data,lowCutoff,highCutoff,rate)
% Naji Husseini
% nshussei@ncsu.edu
% 6/1/2016
% myFFT.m
%
% Runs fast Fourier transform on data set. Converts x axis to frequency and
% y axis to power.
%   Inputs:  data -- audio data in real space
%            lowCutoff -- low frequency cutoff; no results below this
%            highCutoff -- high frequency cutoff; no results above this
%            rate -- sampling rate for data
%   Outputs: freqFFT -- frequency spectrum
%            powerFFT -- power spectrum corresponding to each frequency

duration = length(data)/rate; % duration of signal in seconds
freq = (0:length(data)-1)./duration; % frequency along x axis
freqFFT = freq(freq>lowCutoff & freq<highCutoff); % truncates frequency 

dataFFT = abs(fft(data));
powerFFT = dataFFT(freq>lowCutoff & freq<highCutoff); % truncates power
powerFFT = powerFFT/max(powerFFT); % normalizes power to 1
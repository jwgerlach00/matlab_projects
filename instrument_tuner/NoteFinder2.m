function [note, noteFreq, octave, scale] = NoteFinder2(maxFreq)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
c0 = 16.3516;
notes = ["C0", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];

x = log2(maxFreq/c0);
octave = floor(x);
scale = round(mod(x,1)*12 + 1);
noteFreq = c0*2^(octave + (scale - 1)/12);
note = sprintf(notes(scale) + octave);
end


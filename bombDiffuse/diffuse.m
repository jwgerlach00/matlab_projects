% Jacob Gerlach
% jwgerlac@ncsu.edu
% 9/2/2020
% diffuse.m
%
% Bomb defuse simulation with various wires to cut.

clear
clc
close all

%% Declarations
bombTime = 15; % time to defuse bomb (s)
tries = 5; % number of tries
randBlack = 2; % 1/randBlack chance of defuse w/ black wire
beepNum = 3; % number of beeps on detonation
[y,Fs] = audioread('defused.wav'); % defused audio

%% Output
% Plot
% delete axes
set(gca,'XTick',[])
set(gca,'YTick',[])
% creates borders
xline(1);xline(8);
% wires
redW = xline(2,'r','red');
blueW = xline(3,'b','blue');
yellowW = xline(4,'y','yellow');
greenW = xline(5,'g','green');
cyanW = xline(6,'c','cyan');
blackW = xline(7,'k','black');

tic
fprintf('red\nblue\nyellow\ngreen\nblack\ncyan\n\n');
wire = input('Type a color listed above to cut the associated wire:\n','s');
k = 1;
cyan = 1; % measures whether cyan has not been cut(1) or has been cut(0)
while strcmpi(wire,'red') == 0 && strcmpi(wire,'blue') == 0 && strcmpi...
        (wire,'yellow') == 0 && strcmpi(wire,'green') == 0 && strcmpi...
        (wire,'black') == 0 && k < tries && toc <= bombTime
    if strcmpi(wire,'cyan') == 1 && cyan == 1
        delete(cyanW);
        wire = input('No effect, cut another wire.\n','s');
        cyan = 0; % cyan is cut
    else
        if strcmpi(wire,'cyan') == 1
           wire = input('You''ve already cut this wire.\n','s');
        else
            fprintf('You have %.0f tries left and %.2f seconds\n'...
                ,tries - k, bombTime - toc);
            wire = input('Type the color wire you wish to cut:\n','s');
            k = k + 1;
        end
    end
end

WireDelete(wire,redW,blueW,greenW,yellowW,cyanW,blackW); % deletes plot
%% Output
if toc > bombTime || strcmpi(wire,'red') == 1 || strcmpi(wire,'blue')...
        == 1 || k == tries || (randi(randBlack) ~= 1 &&...
        strcmpi(wire,'black') == 1)
    pause(bombTime - toc);
    fprintf('GLITTER\n');
    for k = 1:beepNum
        beep;pause(.5);
    end
elseif strcmpi(wire,'yellow') == 1 || (randi(randBlack) == 1 &&...
        strcmpi(wire,'black') == 1)
    pause(bombTime - toc);
    sound(y,Fs);
    fprintf('DISARMED\n');
elseif strcmpi(wire,'green') == 1
    delete(greenW);
    wire = input('Time has reset, select again\n','s');
    WireDelete(wire,redW,blueW,greenW,yellowW,cyanW,blackW); % deletes plot
    tic
    if strcmpi(wire,'yellow') == 1
        pause(bombTime - toc);
        sound(y,Fs);
        fprintf('DISARMED\n');
    else
        pause(bombTime - toc);
        fprintf('GLITTER\n');
        for k = 1:beepNum
            beep;pause(.5);
        end
    end
end
    
    
    
    

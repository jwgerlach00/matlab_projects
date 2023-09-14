% Jacob Gerlach
% jwgerlac@ncsu.edu
% 9/9/2020
% jukeboxCellArray.m
%
% virtual jukebox with song selection

clear
clc
close all

%% Declarations
octave = 0; % default octave
speed = 0; % speed of playback
rate = 32768; % sampling frequency (Hz)
originalRate = rate; % to revert rate after speeding up/down
increase = 10; % volume up scalar
decrease = 0.1; % volume down scalar
rateUp = 2; % speed increase scalar
rateDown = 0.5; % speed decrease scalar
fadeLength = 2; % length of fade (s)
random = randi(9); % random song
song = 1; % selected song
roundTime = 1; % time between rounds (s)
vol = 1; % scalar
originalVol = 1;
% Song Names
songName(1) = "House of the Rising Sun";
songName(2) = 'Paint it Black';
songName(3) = 'Never Gonna Give You Up';
songName(4) = 'Fly Me To The Moon';
songName(5) = 'Africa';
songName(6) = 'Legend of Zelda Theme';
songName(7) = 'Here Comes the Sun';
songName(8) = 'NCSU Fight Song';
songName(9) = 'Stairway to Heaven';
songName(10) = songName(random);
% Song Cell Array
songsCell{1} = HouseOfTheRisingSun(octave,speed,rate);
songsCell{2} = PaintItBlack(octave,speed,rate);
songsCell{3} = NeverGonna(octave,speed,rate);
songsCell{4} = FlyMeToTheMoon(octave,speed,rate);
songsCell{5} = AfricaToto(octave,speed,rate);
songsCell{6} = LegendOfZelda(octave,speed,rate);
songsCell{7} = HereComesTheSun(octave,speed,rate);
songsCell{8} = NCSUFightSong(octave,speed,rate);
songsCell{9} = StairwayToHeaven(octave,speed,rate);
songsCell{10} = songsCell{random}; % assigns to random index
%% Output
while song ~= 0
    % Song Menu
    fprintf('Song List:\n-----------\n1: %s \n2: %s \n3: %s \n4: %s \n5: %s \n6: %s \n7: %s \n8: %s \n9: %s \n10: I''M FEELING LUCKY (random)\n0: QUIT :( (enter at any point)\n',...
        songName(1),songName(2),songName(3),songName(4),songName(5),...
        songName(6),songName(7),songName(8),songName(9))
    song = input('\nEnter your song selection number\n');
    while mod(song,1)~=0 || song < 0 || song > length(songsCell)
        song = input('Enter the number next to the song\n');
    end
    if song == 0
        break
    end
    fprintf('\nYou''ve selected %s!\n================================================\n'...
        ,songName(song));
    
    songMat = cell2mat(songsCell(song)); % converts chosen cell to matrix
    % Volume
    volume = input('Would you like to adjust the volume? [up/down/no]\n','s');
    if strcmpi(volume,'up') == 1
        vol = increase;
    elseif strcmpi(volume,'down') == 1
        vol = decrease;
    elseif strcmpi(volume,'0') == 1
        break
    end
    songMat = vol*songMat;
    vol = originalVol; % resets vol value to 1
    % Reverse
    reverse = input(sprintf('Would you like to play %s in reverse? [yes/no]\n',...
        songName(song)),'s');
    if strcmpi(reverse,'yes') == 1
        songMat = fliplr(songMat);
    elseif strcmpi(reverse,'0') == 1
        break
    end
    % Speed
    songSpeed = input(sprintf('Would you like to change the speed of %s? [up/down/no]\n',...
        songName(song)),'s');
    if strcmpi(songSpeed,'up') == 1
        rate = rate*rateUp;
    elseif strcmpi(songSpeed,'down') == 1
        rate = rate*rateDown;
    elseif strcmpi(songSpeed,'0') == 1
        break
    end
    % Fade
    fade = input(sprintf('Would you like %s to fade out? [yes/no]\n',...
        songName(song)),'s');
    if strcmpi(fade,'yes') == 1
        fadeIndex = ((length(songMat)/rate) - fadeLength)*rate;...
            % index x seconds b4 end
        t = linspace(1,0,(length(songMat) - fadeIndex));
        for n = 1:(length(songMat) - fadeIndex)
            songMat(fadeIndex + n) = t(n)*songMat(fadeIndex + n);
        end
    elseif strcmpi(fade,'0') == 1
        break
    end
    % Round
    round = input(sprintf('Would you like to play %s as a two part round? [yes/no]\n',...
        songName(song)),'s');
    if strcmpi(round,'yes')
        sound(songMat,rate);
        pause(roundTime);
    elseif strcmpi(round,'0') == 1
        break
    end
    
    sound(songMat,rate);
    pause(length(songMat)/rate); % pause for length of song
    rate = originalRate; % reverts to original rate after speed up/down
    % Random reset
    random = randi(9);
    songsCell{10} = songsCell{random};
    songName(10) = songName(random);
end

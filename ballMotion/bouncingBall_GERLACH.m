% Jacob Gerlach
% jwgerlac@ncsu.edu
% 11/5/2020
% bouncingBall_GERLACH.m
%
% Records video of bouncing ball and calculates the energy and coefficient
% of restitution

clear
close all
clc

%% Declarations
% You will probably add many more variables to this section. Remember:
% avoid numbers in later sections of your code, so include parameters
% like threshold limits, crop values, etc., in this section.

% Constant
G = -9.81; % gravity (m/s^2)

% Ball properties
ballMass = 0.03;    % ball mass (kg)
ballDIn = 4;        % ball diameter (in)
ballDM = 0.0254*ballDIn; % converts inches to meters
ballDPx = 130; % ball diameter (px)
px2m = ballDM/ballDPx; % pixel to meter conversion factor
bounceCount = 5; % number of good bounces

% Video information
vidFile = 'bounce.avi'; % with extension
frameStart = 17;
frameStop = 75;

% Threshold
rLTh = 130; % red lower threshold

% Crop
cropX1 = 750;
cropY1 = 1;
cropX2 = 1090 - cropX1;
cropY2 = 720;

% Load video
vid = VideoReader(vidFile);    % reads in .avi file
timeTot = get(vid,'NumFrames')/get(vid,'FrameRate');
time = linspace(0,((frameStop - frameStart)/get(vid,'NumFrames'))...
    *timeTot,frameStop-frameStart+1);

%% Threshold Video
% Step through each frame 
k = 1;
for frame = frameStart:frameStop
    frameSlice = read(vid,frame); % loads current frame into frameSlice

    % Crop image
    frameSlice = imcrop(frameSlice, [cropX1 cropY1 cropX2 cropY2]);
    
    % Threshold
    imgBinary = frameSlice(:,:,1) > rLTh;
    
    % Uses custom function centroid to return row and col of centroid
    % centroid returns the x and y coordinates of the centroid given a
    % binary image file
    [centRow(k), centCol(k)] = Centroid(imgBinary);
    
    % Display the thresholded image and plot centroid movement dynamically
    % Make sure image and plot are same size, and no change in axes from
    % plot to plot
    subplot(1,2,1);
    imshow(imgBinary);
    title('Binary');
    subplot(1,2,2);
    plot(centCol(k), cropY2 - centRow(k), 'x');
    hold on;
    plot(centCol(1:1:k), cropY2 - centRow(1:1:k));
    title('Centroid');
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    hold off;
    xlim([1 cropX2]);
    ylim([cropY1 cropY2]);
    pbaspect([cropX2 cropY2 1]);
    
    drawnow % forces figure to appear, which may not happen in loops 
    
    k = k + 1;
end



%% Plot position, velocity, and acceleration
% Correct centroid position, then calculate velocity and acceleration
position = (cropY2-centRow)*px2m;
position = position - position(end); % offsets position
velocity = gradient(position, time);
acceleration = gradient(velocity, time);

% Plot pos/vel/acc versus time
figure;
subplot(3,1,1);
plot(time,position);
title('Ball position');
xlabel('time (s)');
ylabel('position (m)');
subplot(3,1,2);
plot(time,velocity);
title('Ball velocity');
xlabel('time (s)');
ylabel('velocity (m/s)');
subplot(3,1,3);
plot(time, acceleration);
title('Ball acceleration');
xlabel('time (s)');
ylabel('acceleration (m/s/s)');

%% Calculate coefficient of restitution
% Find heights of bounces, compare heights, calculate average excluding
% last bounces without much height
ballHeight = [position(1) findpeaks(position)];

% Plot peak heights as a stem plot (use stem() )
figure;
stem(0:length(ballHeight)-1, ballHeight);
title('Bounce Height');
xlabel('peak number');
ylabel('height (m)');

% only includes bounces in bounceCount as well as initial height
excludeHeight = ballHeight(1:bounceCount+1);
coeffRes = mean(sqrt(excludeHeight(2:end)./excludeHeight(1:end-1)));
fprintf('Average coefficient of restitution: %.4f\n', coeffRes);

%% Plot of energies as function of time
% Calculate total, potential, and kinentic energy from position and
% velocity
potential = ballMass*abs(G)*position;
kinetic = (1/2)*ballMass*(velocity.^2);
total = potential + kinetic;

% Plot them
figure
plot(time, potential, time, kinetic, time, total);
title('Energy');
xlabel('time (s)');
ylabel('energy (J)');
legend('potential energy (J)', 'kinetic energy (J)', 'total energy (J)');

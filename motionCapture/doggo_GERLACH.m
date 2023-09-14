% Jacob Gerlach
% jwgerlac@ncsu.edu
% 11/9/2020
% doggo_GERLACH.m
% motion capture of Lucy the dog walking

clc
clear
close all

%% Declarations
rate = 10; % video record frame rate
sub = 100; % linspace subdivisions

frameStart = 88;
frameStop = 125;

cropX1 = 1;
cropX2 = 1725;
cropY1 = 250;
cropY2 = 750 - cropY1;

% Video Input
vidFile = 'doggo.mov';
vid = VideoReader(vidFile);

% Threshold
rLTh1 = 100;
gBTh1 = 30;
gLTh2 = 170;
rUTh2 = 180;
bUTh2 = 145;
rGTh3 = 65;
bUTh3 = 140;
rLTh3 = 85;
rUTh3 = 98;
gLTh3 = 90;
gUTh3 = 110;
bLTh3 = 80;
bUTh32 = 92;
rLTh4 = 120;
gLTh4 = 130;
bUTh4 = 70;

notice = 'NOTICE: The subject was fairly compensated with treaties';
noticeFrames = 20; % number of frames to display notice

%% Output
k = 1;

newVid1 = VideoWriter('lucyWantsTreaties.avi');
newVid1.FrameRate = rate;
open(newVid1)

for frame = frameStart:frameStop
    frameSlice = read(vid,frame); % loads current frame into frameSlice

    % Crop image
    frameSlice = imcrop(frameSlice, [cropX1 cropY1 cropX2 cropY2]);
    
    % Threshold
    imgBinR = frameSlice(:,:,1) > rLTh1 & frameSlice(:,:,2) < gBTh1 &...
        frameSlice(:,:,3) < gBTh1;
    [rCentRow(k), rCentCol(k)] = Centroid(imgBinR);
    
    imgBinG = frameSlice(:,:,2) > gLTh2 & frameSlice(:,:,1) < rUTh2 &...
        frameSlice(:,:,3) < bUTh2;
    [gCentRow(k), gCentCol(k)] = Centroid(imgBinG);
    
    imgBinC = ((frameSlice(:,:,2) > rGTh3 & (frameSlice(:,:,1) < rGTh3 &...
        frameSlice(:,:,3) < bUTh3))) | ((frameSlice(:,:,1) > rLTh3) &...
        (frameSlice(:,:,1) < rUTh3) & (frameSlice(:,:,2) > gLTh3) &...
        (frameSlice(:,:,2) < gUTh3) & (frameSlice(:,:,3) > bLTh3) &...
        (frameSlice(:,:,3) < bUTh32));
    [cCentRow(k), cCentCol(k)] = Centroid(imgBinC);

    imgBinY = frameSlice(:,:,1) > rLTh4 & frameSlice(:,:,2) > gLTh4 &...
        frameSlice(:,:,3) < bUTh4;
    [yCentRow(k), yCentCol(k)] = Centroid(imgBinY);
    
    imgBinary = imgBinR + imgBinG + imgBinC + imgBinY;
    
    subplot(3,1,1);
    imshow(frameSlice);
    title('Color cropped image');
    subplot(3,1,2);
    imshow(imgBinary);
    title('Thresholded image');
    subplot(3,1,3);
    plot(rCentCol(k), cropY2 - rCentRow(k), 'rx',...
        gCentCol(k), cropY2 - gCentRow(k), 'gx',...
        cCentCol(k), cropY2 - cCentRow(k), 'cx',...
        yCentCol(k), cropY2 - yCentRow(k), 'yx', 'LineWidth', 2);
    hold on;
    plot(rCentCol(1:1:k), cropY2 - rCentRow(1:1:k), 'r',...
        gCentCol(1:1:k), cropY2 - gCentRow(1:1:k), 'g',...
        cCentCol(1:1:k), cropY2 - cCentRow(1:1:k), 'c',...
        yCentCol(1:1:k), cropY2 - yCentRow(1:1:k), 'y', 'LineWidth', 2);
    title('Joint centroids');
%     set(gca,'xtick',[]);
%     set(gca,'ytick',[]);
    hold off;
    xlim([cropX1 cropX2]);
    ylim([1 cropY2]);
    pbaspect([cropX2 cropY2 1]);
    
    drawnow
    
    k = k + 1;
    
    currentFrame = getframe(gcf);
    writeVideo(newVid1, currentFrame);
end

close(newVid1);

figure;
k = 1;

newVid2 = VideoWriter('doggoStick.avi');
newVid2.FrameRate = rate;
open(newVid2)

for frame = frameStart:frameStop
    frameSlice = read(vid,frame); % loads current frame into frameSlice

    % Crop image
    frameSlice = imcrop(frameSlice, [cropX1 cropY1 cropX2 cropY2]);
    
    % Threshold
    imgBinR = frameSlice(:,:,1) > rLTh1 & frameSlice(:,:,2) < gBTh1 &...
        frameSlice(:,:,3) < gBTh1;
    [rCentRow(k), rCentCol(k)] = Centroid(imgBinR);
    
    imgBinG = frameSlice(:,:,2) > gLTh2 & frameSlice(:,:,1) < rUTh2 &...
        frameSlice(:,:,3) < bUTh2;
    [gCentRow(k), gCentCol(k)] = Centroid(imgBinG);
    
    imgBinC = ((frameSlice(:,:,2) > rGTh3 & (frameSlice(:,:,1) < rGTh3 &...
        frameSlice(:,:,3) < bUTh3))) | ((frameSlice(:,:,1) > rLTh3) &...
        (frameSlice(:,:,1) < rUTh3) & (frameSlice(:,:,2) > gLTh3) &...
        (frameSlice(:,:,2) < gUTh3) & (frameSlice(:,:,3) > bLTh3) &...
        (frameSlice(:,:,3) < bUTh32));
    [cCentRow(k), cCentCol(k)] = Centroid(imgBinC);

    imgBinY = frameSlice(:,:,1) > rLTh4 & frameSlice(:,:,2) > gLTh4 &...
        frameSlice(:,:,3) < bUTh4;
    [yCentRow(k), yCentCol(k)] = Centroid(imgBinY);
    
    imgBinary = imgBinR + imgBinG + imgBinC + imgBinY;
    
    subplot(2,1,1);
    imshow(frameSlice);
    subplot(2,1,2);
    plot(linspace(rCentCol(k), gCentCol(k), sub), cropY2 -...
        linspace(rCentRow(k), gCentRow(k), sub), 'g',...
        linspace(rCentCol(k), yCentCol(k), sub), cropY2 -...
        linspace(rCentRow(k), yCentRow(k), sub), 'r',...
        linspace(cCentCol(k), yCentCol(k), sub), cropY2 -...
        linspace(cCentRow(k), yCentRow(k), sub),'y');
    hold on;
    
    plot(rCentCol(k), cropY2 - rCentRow(k), 'r.',...
        gCentCol(k), cropY2 - gCentRow(k), 'g.',...
        cCentCol(k), cropY2 - cCentRow(k), 'c.',...
        yCentCol(k), cropY2 - yCentRow(k), 'y.', 'MarkerSize', 25);
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    hold off;
    xlim([cropX1 cropX2]);
    ylim([1 cropY2]);
    pbaspect([cropX2 cropY2 1]);
    
    drawnow
    
    currentFrame = getframe(gcf);
    writeVideo(newVid2, currentFrame);
    
    k = k + 1;
end
clf('reset');
xlim([0 2]);
ylim([0 2]);
set(gca, 'visible', 'off');
set(text(1,1,notice), 'visible', 'on', 'HorizontalAlignment', 'center',...
    'VerticalAlignment', 'middle');
for k = 1:noticeFrames
    currentFrame = getframe(gcf);
    writeVideo(newVid2, currentFrame);
end

close(newVid2);



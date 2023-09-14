% Jacob Gerlach
% jwgerlac@ncsu.edu
% 11/9/2020
% mocap_GERLACH.m
% motiion capture of Naji walking

clc
clear
close all

%% Declarations
rate = 20; % video record frame rate
vidFile = 'walkVid.mov';
vid = VideoReader(vidFile);

frameStart = 123;
frameStop = 197;

cropX1 = 1;
cropX2 = 1920;
cropY1 = 500;
cropY2 = 1080 - cropY1;

% Threshold
low = 180;
high = 80;
lowB = 120;

k = 1;

newVid1 = VideoWriter('najiWalk.avi');
newVid1.FrameRate = rate;
open(newVid1);

for frame = frameStart:frameStop
    frameSlice = read(vid,frame); % loads current frame into frameSlice

    % Crop image
    frameSlice = imcrop(frameSlice, [cropX1 cropY1 cropX2 cropY2]);
    
    % Threshold
    imgBinR = frameSlice(:,:,1) > low & frameSlice(:,:,2) < high &...
        frameSlice(:,:,3) < high;
    [rCentRow(k), rCentCol(k)] = Centroid(imgBinR);
    
    imgBinG = frameSlice(:,:,2) > low & frameSlice(:,:,1) < high &...
        frameSlice(:,:,3) < high;
    [gCentRow(k), gCentCol(k)] = Centroid(imgBinG);
    
    imgBinC = frameSlice(:,:,3) > low & frameSlice(:,:,1) < high &...
        frameSlice(:,:,2) > high & frameSlice(:,:,2) < low;
    [cCentRow(k), cCentCol(k)] = Centroid(imgBinC);
    
    imgBinY = frameSlice(:,:,1) > low & frameSlice(:,:,2) > low &...
        frameSlice(:,:,3) < high;
    [yCentRow(k), yCentCol(k)] = Centroid(imgBinY);
    
    imgBinary = imgBinR+imgBinG+imgBinC+imgBinY;
    
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

newVid2 = VideoWriter('najiStick.avi');
newVid2.FrameRate = rate;
open(newVid2);

for frame = frameStart:frameStop
    frameSlice = read(vid,frame); % loads current frame into frameSlice

    % Crop image
    frameSlice = imcrop(frameSlice, [cropX1 cropY1 cropX2 cropY2]);
    
    % Threshold
    imgBinR = frameSlice(:,:,1) > low & frameSlice(:,:,2) < high &...
        frameSlice(:,:,3) < high;
    [rCentRow(k), rCentCol(k)] = Centroid(imgBinR);
    
    imgBinG = frameSlice(:,:,2) > low & frameSlice(:,:,1) < high &...
        frameSlice(:,:,3) < high;
    [gCentRow(k), gCentCol(k)] = Centroid(imgBinG);
    
    imgBinC = frameSlice(:,:,3) > low & frameSlice(:,:,1) < high &...
        frameSlice(:,:,2) > high & frameSlice(:,:,2) < low;
    [cCentRow(k), cCentCol(k)] = Centroid(imgBinC);
    
    imgBinY = frameSlice(:,:,1) > low & frameSlice(:,:,2) > low &...
        frameSlice(:,:,3) < high;
    [yCentRow(k), yCentCol(k)] = Centroid(imgBinY);
    
    imgBinary = imgBinR+imgBinG+imgBinC+imgBinY;
    
    subplot(2,1,1);
    imshow(frameSlice);
%     title('Color cropped image');
    subplot(2,1,2);
    plot(linspace(gCentCol(k), rCentCol(k),100), cropY2 -...
        linspace(gCentRow(k), rCentRow(k), 100), 'r',...
        linspace(cCentCol(k), gCentCol(k),100), cropY2 -...
        linspace(cCentRow(k), gCentRow(k), 100), 'g',...
        linspace(yCentCol(k), cCentCol(k),100), cropY2 -...
        linspace(yCentRow(k), cCentRow(k), 100),'c');
    hold on;
    plot(rCentCol(k), cropY2 - rCentRow(k), 'r.',...
        gCentCol(k), cropY2 - gCentRow(k), 'g.',...
        cCentCol(k), cropY2 - cCentRow(k), 'c.',...
        yCentCol(k), cropY2 - yCentRow(k), 'y.', 'MarkerSize', 25);
%     title('Joint centroids');
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    hold off;
    xlim([cropX1 cropX2]);
    ylim([1 cropY2]);
    pbaspect([cropX2 cropY2 1]);
    
    drawnow
    
    k = k + 1;
    
    currentFrame = getframe(gcf);
    writeVideo(newVid2, currentFrame);
end

close(newVid2);

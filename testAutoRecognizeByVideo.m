clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess1.avi';

rectFilePathName = 'rect_anno.txt';
rotateFilePathName = 'angle_rotate.txt';

messTagFilePathName = 'data_2.txt';

if exist(rectFilePathName, 'file')
    rectWinding = dlmread(rectFilePathName);
    rectWinding = round(rectWinding);
else
    error(['couldn''t find ' rectFilePathName]);
end

if exist(rotateFilePathName, 'file')
    theta = dlmread(rotateFilePathName);
else
    error(['couldn''t find ' rotateFilePathName]);
end

bestParaMat = 'bestPara.mat';
load(bestParaMat,'bestPara','gaussianParaOutput','dataMLOutput');

dimInd = bestPara{1, 4};

heightBias = 0;
widthBias = 0;

hogSize = bestPara{1, 5};
imgEdge = bestPara{1, 6};
heightImgEdge = round(heightBias + imgEdge);
widthImgEdge = round(widthBias + imgEdge);

featureType = 'gaborsBinHog';

vidObj = VideoReader(videoPathName);
numFrames = ceil(vidObj.Duration * vidObj.FrameRate);

i = 1;
while hasFrame(vidObj)
    progressbar(i, numFrames);
    vidFrame = readFrame(vidObj);
    
    imgRected = fun_rotateRect(vidFrame, theta, rectWinding);
    featureData = fun_realFrameFeatureGen(imgRected,hogSize,heightImgEdge,widthImgEdge,featureType,dataMLOutput);
    messTag = fun_recognizeByGaussian(featureData,dimInd,gaussianParaOutput);
    dlmwrite(messTagFilePathName,messTag,'delimiter','\t');
    
    % play-----------------
    if i == 1
        fig_handle = figure('Name', 'frame');
        imagesc(vidFrame);
        if messTag
            hold on;
            text(10, 10, int2str(i), 'color', [0 1 1]);
            hold off;
            axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
        else
            hold on;
            text(10, 10, 'rope messing', 'color', [1 0 0],'FontSize',25);
            hold off;
            axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
        end
    else
        figure(fig_handle);
        imagesc(vidFrame);
        if messTag
            hold on;
            text(10, 10, int2str(i), 'color', [0 1 1]);
            hold off;
            axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
        else
            hold on;
            text(10, 10, 'rope messing', 'color', [1 0 0],'FontSize',25);
            hold off;
            axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
        end
    end
    drawnow;
    % ---------------------    
    i = i + 1;
end

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
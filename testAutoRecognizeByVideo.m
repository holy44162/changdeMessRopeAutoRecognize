clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess3_20181121160809.mp4';
videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess2_20181130160541.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess1.avi';

rectFilePathName = 'rect_anno.txt';
rotateFilePathName = 'angle_rotate.txt';

messTagFilePathName = 'data_1.txt';

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
% load(bestParaMat,'bestPara','gaussianParaOutput','dataMLOutput'); % hided by Holy 1811301516
load(bestParaMat,'bestPara','dataMLOutput','GMModelOutput','epsilonOutput');

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
    tStartFrame = tic;
    progressbar(i, numFrames);
    vidFrame = readFrame(vidObj);
    
    % added by Holy 1812251650
    if i == 1
        bwRef = zeros(size(vidFrame,1),size(vidFrame,2));
    end
    % end of addition 1812251650
    
    imgRected = fun_rotateRect(vidFrame, theta, rectWinding);
    [featureData,bwImg] = fun_realFrameFeatureGen(imgRected,hogSize,heightImgEdge,widthImgEdge,featureType,dataMLOutput,dimInd);
    
%     % added by Holy 1812270818
%     % debug procedure
%     if i == 244
%         j = 1;
%     end
%     % end of addition 1812270818
    
    % added by Holy 1812251651
    bwOutputImg = fun_rotateRectBack(bwRef, bwImg, theta, rectWinding);
    outputBW_LC = fun_BWLargestConnectedRegion(bwOutputImg);
    stats = regionprops(logical(outputBW_LC), 'ConvexHull');
    
    % added by Holy 1812270828
    if ~isempty(stats)
        tn = [];
        for j = 1:length(stats)
            tn = [tn;round(stats(j).ConvexHull);];
        end
    % end of addition 1812270828
        
        %     if ~isempty(stats) % hided by Holy 1812270837
%         tn = round(stats.ConvexHull); % hided by Holy 1812270837
%         tn = round(tn); % hided by Holy 1812270837
        messPos = [min(tn(:, 1)), min(tn(:, 2)),min(tn(:, 1)), max(tn(:, 2)),max(tn(:, 1)), max(tn(:, 2)),max(tn(:, 1)), min(tn(:, 2))];
    end
    % end of addition 1812251651
    
    messTag = fun_recognizeByGaussian(featureData,GMModelOutput,epsilonOutput);
    dlmwrite(messTagFilePathName,messTag,'delimiter','\t','newline','pc');
    if messTag && ~isempty(stats)
        dlmwrite(messTagFilePathName,messPos,'-append','delimiter','\t','newline','pc'); % added by Holy 1812251736
    end
    frameElapsedTime = toc(tStartFrame);
    fps = 1/frameElapsedTime;
    % play-----------------
    if i == 1
        fig_handle = figure('Name', 'frame');
        imagesc(vidFrame);
        if ~messTag
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
        if ~messTag
            hold on;
            text(10, 10, num2str(fps), 'color', [0 1 1]);
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
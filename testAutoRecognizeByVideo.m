clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess3_20181121160809.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess2_20181130160541.mp4';
% videoPathName = 'd:\data\windingRope\fromSongjingtao\new_data_1811050807\light_mess1.avi';
videoPathName = 'm:\files\computerVision\windingRope\messRope\test2.mp4';

rectFilePathName = 'rect_anno.txt';
rotateFilePathName = 'angle_rotate.txt';

% messTagFilePathName = 'data_1.txt'; % hided by Holy 1901021429
messTagFilePathName = 'm:\files\computerVision\windingRope\messRope\data_1.txt'; % added by Holy 1901021429

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

loopTag = true; % added by Holy 1901021439
while loopTag % added by Holy 1901021437
    vidObj.CurrentTime = 0; % added by Holy 1901021438
    i = 1;
    indDuration = 0;
    messPos = [0 0 0 0 0 0 0 0]; % added by Holy 1812271051
    % added by Holy 1812271102
    dlmwrite(messTagFilePathName,0,'delimiter','\t','newline','pc');
    dlmwrite(messTagFilePathName,messPos,'-append','delimiter','\t','newline','pc');
    % end of addition 1812271102
    entropyPre = 0; % added by Holy 1812271613
    entropyThreshold = 1e-3; % added by Holy 1812271628
    % entropyDiff = []; % just to test entropy difference threshold
    while hasFrame(vidObj)
        tStartFrame = tic;
        progressbar(i, numFrames);
        vidFrame = readFrame(vidObj);
        
        % added by Holy 1812271615
        entropyCurrent = entropy(rgb2gray(vidFrame));
        %     entropyDiff = [entropyDiff;abs(entropyCurrent - entropyPre)];
        entropyDiff = abs(entropyCurrent - entropyPre);
        entropyPre = entropyCurrent;
        % end of addition 1812271615
        
        % added by Holy 1812251650
        if i == 1
            bwRef = zeros(size(vidFrame,1),size(vidFrame,2));
        end
        % end of addition 1812251650
        
        if entropyDiff > entropyThreshold % added by Holy 1812271630
            imgRected = fun_rotateRect(vidFrame, theta, rectWinding);
            [featureData,bwImg] = fun_realFrameFeatureGen(imgRected,hogSize,heightImgEdge,widthImgEdge,featureType,dataMLOutput,dimInd);
            
            %     % added by Holy 1812270818
            %     % debug procedure: largest connected region number is more than 1
            %     if i == 79
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
                    tn = [tn;round(stats(j).ConvexHull)];
                end
                % end of addition 1812270828
                
                %     if ~isempty(stats) % hided by Holy 1812270837
                %         tn = round(stats.ConvexHull); % hided by Holy 1812270837
                %         tn = round(tn); % hided by Holy 1812270837
                messPos = [min(tn(:, 1)), min(tn(:, 2)),min(tn(:, 1)), max(tn(:, 2)),max(tn(:, 1)), max(tn(:, 2)),max(tn(:, 1)), min(tn(:, 2))];
            end
            % end of addition 1812251651
            
            messTag = fun_recognizeByGaussian(featureData,GMModelOutput,epsilonOutput);
            messTagAcute = messTag; % added by Holy 1812271020
            
            % added by Holy 1812271058
            % end of addition 1812271058
            
            %     dlmwrite(messTagFilePathName,messTag,'delimiter','\t','newline','pc'); % hided by Holy 1812271015
            if messTag && ~isempty(stats)
                fun_replaceTxtSpecificLine(messTagFilePathName, 1, num2str(messTag)); % added by Holy 1812271016
                %         dlmwrite(messTagFilePathName,messPos,'-append','delimiter','\t','newline','pc'); % added by Holy 1812251736
                
                % added by Holy 1812271111
                allOneString = sprintf('%.0f\t',messPos);
                allOneString = allOneString(1:end-1);% strip final delimiter
                fun_replaceTxtSpecificLine(messTagFilePathName, 2, allOneString);
                % end of addition 1812271111
                
                indDuration = 0; % added by Holy 1812270951
            else
                % added by Holy 1812271019
                indDuration = indDuration + 1;
                if indDuration < 10
                    messTagAcute = ~messTag;
                else
                    messTagAcute = messTag;
                    fun_replaceTxtSpecificLine(messTagFilePathName, 1, num2str(messTag)); % added by Holy 1812271116
                end
                % end of addition 1812271019
            end
            
            % hided by Holy 1812271632
            %     frameElapsedTime = toc(tStartFrame);
            %     fps = 1/frameElapsedTime;
            % end of hide 1812271632
            
            % added by Holy 1812271412
            fid = fopen(messTagFilePathName,'r');
            if fid ~= -1
                tline = fgetl(fid);
                messTagFromFile = str2double(tline);
                tline = fgetl(fid);
                messPosFromFile = textscan(tline, '%f', 'Delimiter','\t');
                messPosFromFile = cell2mat(messPosFromFile);
                fclose(fid);
            else
                messTagFromFile = 0;
            end
            % end of addition 1812271412
        end % added by Holy 1812271631
        
        % added by Holy 1812271632
        frameElapsedTime = toc(tStartFrame);
        fps = 1/frameElapsedTime;
        % end of addition 1812271632
        
        % play-----------------
        if i == 1
            fig_handle = figure('Name', 'frame');
            imagesc(vidFrame);
            %         if ~messTag % hided by Holy 1812271023
            %         if ~messTagAcute % added by Holy 1812271023
            if ~messTagFromFile % added by Holy 1812271428
                hold on;
                text(10, 10, int2str(i), 'color', [0 1 1]);
                text(10, 90, num2str(vidObj.CurrentTime), 'color', [0 1 1],'FontSize',25); % added by Holy 1901021509
                hold off;
                axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
            else
                hold on;
                text(10, 10, 'rope messing', 'color', [1 0 0],'FontSize',25);
                text(10, 90, num2str(vidObj.CurrentTime), 'color', [1 0 0],'FontSize',25); % added by Holy 1901021509
                %             line([messPos(1) messPos(3) messPos(5) messPos(7) messPos(1)],[messPos(2) messPos(4) messPos(6) messPos(8) messPos(2)], 'color', 'r'); % added by Holy 1812270924
                line(messPosFromFile([1,3,5,7,1]),messPosFromFile([2,4,6,8,2]), 'color', 'r'); % added by Holy 1812271432
                hold off;
                axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
            end
        else
            figure(fig_handle);
            imagesc(vidFrame);
            %         if ~messTag % hided by Holy 1812271023
            %         if ~messTagAcute % added by Holy 1812271023
            if ~messTagFromFile % added by Holy 1812271436
                hold on;
                text(10, 10, num2str(fps), 'color', [0 1 1]);
                text(10, 90, num2str(vidObj.CurrentTime), 'color', [0 1 1],'FontSize',25); % added by Holy 1901021509
                hold off;
                axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
            else
                hold on;
                text(10, 10, 'rope messing', 'color', [1 0 0],'FontSize',25);
                text(10, 90, num2str(vidObj.CurrentTime), 'color', [1 0 0],'FontSize',25); % added by Holy 1901021509
                %             line([messPos(1) messPos(3) messPos(5) messPos(7) messPos(1)],[messPos(2) messPos(4) messPos(6) messPos(8) messPos(2)], 'color', 'r'); % added by Holy 1812270924
                line(messPosFromFile([1,3,5,7,1]),messPosFromFile([2,4,6,8,2]), 'color', 'r'); % added by Holy 1812271432
                hold off;
                axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1]);
            end
        end
        drawnow;
        % ---------------------
        i = i + 1;
    end
    % added by Holy 1901021455
    delete(gca);
    close;
    % end of addition 1901021455
end % end of addition 1901021437

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
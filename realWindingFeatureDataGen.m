function dataML = realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio,featureType,dataMLInput)
% clear;
% hided by Holy 1808131653
% tStart = tic;
% functionPath = 'm:\files\files\phd\functions\';
% addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
% addpath([functionPath 'gda']);
% end of hide 1808131653

% set parameters here
% hogSize = 38; % hog feature cell size
% numDim = 27; % reduced dim in pca
debug = false;
% debug = true;

% hogFeatureType = 'hogOnly';
gaborMaxFeatureType = 'gaborMax';
gaborBWHogFeatureType = 'gaborBWHog'; % added by Holy 1809111558
gaborBWHogNumFeatureType = 'gaborBWNum'; % added by Holy 1811011126
gaborSpecificFeatureType = 'gaborSpecific';
gaborsBinHogFeatureType = 'gaborsBinHog'; % added by Holy 1811081435
% BWDataFeatureType = 'BWData'; % added by Holy 1811050755

% hided by Holy 1808141344
% if debug
%     addpath([functionPath 'toolbox_general']);
% end
% % addpath([functionPath 'toolbox_general']);
% end of hide 1808141344

% folder_name = 'd:\data_seq\sequences\realWindingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\realWindingRopeTest\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
% folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';

% added by Holy 1808131629
if nargin < 6
    dataMLInput = [];
end
% end of addition 1808131629

fileList = getAllFiles(folder_name);

% added by Holy 1807271108
% refImg = imread(fileList{1, 1});
% [rowRefImg, colRefImg, ~] = size(refImg);
% biasHeight = round(rowRefImg/biasHRatio);
% biasWidth = round(colRefImg/biasWRatio);
% end of addition 1807271108

% added by Holy 1810310842
[pathName,~,~] = fileparts(fileList{1, 1});
angleRectPathName = getUpLevelPath(pathName, 2);
rectFilePathName = fullfile(angleRectPathName, 'rect_anno.txt');
rotateFilePathName = fullfile(angleRectPathName, 'angle_rotate.txt');

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

% refImg = fun_rotateRect(refImg, theta, rectWinding); % hided by Holy 1811050840
% end of addition 1810310842

% added by Holy 1808021415
refImg = imread(fileList{1, 1});
refImg = fun_rotateRect(refImg, theta, rectWinding); % added by Holy 1811050841
refImg = refImg(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
% end of addition 1808021415

% added by Holy 1811081448
if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
    if (size(refImg,3) ~= 1)
        refImg = rgb2gray(refImg);
    end    
       
    refImg = adapthisteq(refImg,'NumTiles',[16,16]);
    refImg = adapthisteq(refImg,'NumTiles',[8,8]);
    refImg = adapthisteq(refImg,'NumTiles',[4,4]);
        
    [~, Nc, ~] = size(refImg);
    gamma = 1;
    b = 1;
%     Theta = 0:pi/6:pi-pi/6;
    phi = 0;
    shape = 'valid';
    
    oriUpMin = 0;
    oriUpMax = pi/6;
    oriDownMin = pi-pi/6;
    oriDownMax = pi;
    
    oriStepNum = 1;
    stepSizeUp = (oriUpMax - oriUpMin) / oriStepNum;
    stepSizeDown = (oriDownMax - oriDownMin) / oriStepNum;
    Theta = [oriUpMin:stepSizeUp:oriUpMax oriDownMin:stepSizeDown:oriDownMax];    
    
    % ----------------------------
    J = (2.^(0:log2(Nc/8)) - .5) ./ Nc;
    F = [ (.25 - J) (.25 + J) ]; F = sort(F); Lambda = 1 ./ F;
    Lambda = Lambda(end-1:end);
    % ----------------------------
    hogFeatureRef = GaborTextureSegment(refImg, gamma, Lambda, b, Theta, phi, shape, hogSize);
    lenGaborsBinHogFeature = length(hogFeatureRef);
end
% end of addition 1811081448

if contains(featureType, hogFeatureType,'IgnoreCase',true)
    % added by Holy 1807271328
    % refImg = imread(fileList{1, 1}); % hided by Holy 1808021349
    % hogInputRefImg = refImg(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
    % hogInputRefImg = refImg;
    % hided by Holy 1811050827
%     hogFeature = extractHOGFeatures(refImg,'CellSize',[hogSize hogSize]);
%     lenHogFeature = length(hogFeature);
    % end of hide 1811050827
    % end of addition 1807271328
    
    % added by Holy 1811050825    
    % added by Holy 1807311455
    hogInputRefImg = im2double(refImg);
    hogInputRefImg = rgb2gray(hogInputRefImg);
    % hided by Holy 1809051529
    %             hogInputImg3 = adapthisteq(hogInputImg2);
    %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
    %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
    % end of hide 1809051529
    % end of addition 1807311455
    
    %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
    %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','Sensitivity',1); % added by Holy 1808041457
    hogInputRefImg = imbinarize(hogInputRefImg,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6); % added by Holy 1811050804
    
    hogFeature = extractHOGFeatures(hogInputRefImg,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
    lenHogFeature = length(hogFeature);
    % end of addition 1811050825
end

if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
    % added by Holy 1807311554
    gaborMatrix = gaborFilterBank(5,8,39,39);
    % gaborArray = gaborMatrix(1,2:4); % hided by Holy 1808011143
    % gaborArray = gaborMatrix; % added by Holy 1808011143
    gaborArray = gaborMatrix(2,5); % added by Holy 1809051513
    refImgD = im2double(refImg);
    refImgDG = rgb2gray(refImgD);
    % gaborFeature = gaborFeatures(refImgDG,gaborArray,4,4); % hided by Holy 1808031111
    % lenGaborFeature = length(gaborFeature); % hided by Holy 1808031111
    % end of addition 1807311554
    
    % added by Holy 1808031111
    [~,gaborResult] = gaborFeatures(refImgDG,gaborArray,4,4);
    varValueRef = complexCellAbsVar(gaborResult);
    lenGaborFeature = length(varValueRef);
    % end of addition 1808031111
    
    indBig = 50; % added by Holy 1809060856
end

% added by Holy 1809111609
if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)    
    hogFeature = extractHOGFeatures(refImg,'CellSize',[hogSize hogSize]);
    lenHogFeature = length(hogFeature);
    
    Wavelength = 10; % added by Holy 1810310850
%     Wavelength = 8; % hided by Holy 1810310850
    % added by Holy 1809101054
%     oriUpMin = 0;
%     oriUpMax = 45;
%     oriDownMin = 135;
%     oriDownMax = 180;

%     oriUpMin = 360-45;
%     oriUpMax = 360;
%     oriDownMin = 1;
%     oriDownMax = 30;
    
%     oriUpMin = 165;
%     oriUpMax = 180;
%     oriDownMin = 1;
%     oriDownMax = 15;
    
    oriUpMin = 0;
    oriUpMax = 30;
    oriDownMin = 150;
    oriDownMax = 180;

    oriStepNum = 4;
    stepSizeUp = (oriUpMax - oriUpMin) / oriStepNum;
    stepSizeDown = (oriDownMax - oriDownMin) / oriStepNum;
    Orientations = [oriUpMin:stepSizeUp:oriUpMax oriDownMin:stepSizeDown:oriDownMax];
    % end of addition 1809101054
    
    PhaseOffsets = [0 90];
    % PhaseOffsets = 0;
    AspectRatio = 0.5; % hided by Holy 1810251428
%     AspectRatio = 1; % added by Holy 1810251428
    Bandwidth = 1; % hided by Holy 1810251520
%     Bandwidth = 1.5; % added by Holy 1810251520
    % NumberOfOrientations = 4;
%     NumberOfOrientations = 12; % hided by Holy 1810311541
    NumberOfOrientations = 1; % added by Holy 1810311542
    EnableHWR = 0; % hided by Holy 1810261441
%     EnableHWR = 1; % added by Holy 1810261441
    EnableThinning = 0;
%     EnableHysteresisThresholding = 1; % hided by Holy 1810311542
    EnableHysteresisThresholding = 0; % added by Holy 1810311543
    
    data_orientation = Orientations ./ (180/pi); % convert the numbers to radians
    data_nroriens = NumberOfOrientations;
    data_sigma = 0;
    data_wavelength = Wavelength;
    data_bandwidth = Bandwidth;    
    data_phaseoffset = PhaseOffsets ./ (180/pi); % convert the numbers to radians
    data_aspectratio = AspectRatio;
    data_hwstate = EnableHWR;
    data_halfwave = 0;
    % data_halfwave = 40;
    data_supPhases = 2; % 'L2 norm'
    data_inhibMethod = 1; % 'No surround inhibition'
    % data_inhibMethod = 3; % anisotropic surround inhibition
    % data_inhibMethod = 2; % Isotropic surround inhibition
    data_supIsoinhib = 3; % 'L-infinity norm'
    % data_alpha = 1;
    data_alpha = 1.5;    
    data_k1 = 1;
    data_k2 = 4;
    if size(Orientations,2) == 1
        data_selection = (1:data_nroriens);
    else
        data_selection = 1:size(Orientations,2);
    end
    data_thinning = EnableThinning;
    % data.thinning = 1;
    data_hyst = EnableHysteresisThresholding;    
    data_tlow = 0.21;
    data_thigh = 0.7;
    data_invertOutput = 0;
    
    data.hwstate = data_hwstate;
    data.phaseoffset = data_phaseoffset;
    data.halfwave = data_halfwave;
    data.supPhases = data_supPhases;
    data.inhibMethod = data_inhibMethod;
    data.supIsoinhib = data_supIsoinhib;
    data.alpha = data_alpha;
    data.k1 = data_k1;
    data.k2 = data_k2;
    data.selection = data_selection;
    data.thinning = data_thinning;
    data.hyst = data_hyst;
    data.tlow = data_tlow;
    data.thigh = data_thigh;
    data.invertOutput = data_invertOutput;
end
% end of addition 1809111609

% added by Holy 1811011128
if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)    
    hogFeature = extractHOGFeatures(refImg,'CellSize',[hogSize hogSize]);
    lenHogFeature = length(hogFeature) + 1;
    
    Wavelength = 10; % added by Holy 1810310850
%     Wavelength = 8; % hided by Holy 1810310850
    % added by Holy 1809101054
%     oriUpMin = 0;
%     oriUpMax = 45;
%     oriDownMin = 135;
%     oriDownMax = 180;

%     oriUpMin = 360-45;
%     oriUpMax = 360;
%     oriDownMin = 1;
%     oriDownMax = 30;
    
%     oriUpMin = 165;
%     oriUpMax = 180;
%     oriDownMin = 1;
%     oriDownMax = 15;
    
    oriUpMin = 0;
    oriUpMax = 30;
    oriDownMin = 150;
    oriDownMax = 180;

    oriStepNum = 4;
    stepSizeUp = (oriUpMax - oriUpMin) / oriStepNum;
    stepSizeDown = (oriDownMax - oriDownMin) / oriStepNum;
    Orientations = [oriUpMin:stepSizeUp:oriUpMax oriDownMin:stepSizeDown:oriDownMax];
    % end of addition 1809101054
    
    PhaseOffsets = [0 90];
    % PhaseOffsets = 0;
    AspectRatio = 0.5; % hided by Holy 1810251428
%     AspectRatio = 1; % added by Holy 1810251428
    Bandwidth = 1; % hided by Holy 1810251520
%     Bandwidth = 1.5; % added by Holy 1810251520
    % NumberOfOrientations = 4;
%     NumberOfOrientations = 12; % hided by Holy 1810311541
    NumberOfOrientations = 1; % added by Holy 1810311542
    EnableHWR = 0; % hided by Holy 1810261441
%     EnableHWR = 1; % added by Holy 1810261441
    EnableThinning = 0;
%     EnableHysteresisThresholding = 1; % hided by Holy 1810311542
    EnableHysteresisThresholding = 0; % added by Holy 1810311543
    
    data_orientation = Orientations ./ (180/pi); % convert the numbers to radians
    data_nroriens = NumberOfOrientations;
    data_sigma = 0;
    data_wavelength = Wavelength;
    data_bandwidth = Bandwidth;    
    data_phaseoffset = PhaseOffsets ./ (180/pi); % convert the numbers to radians
    data_aspectratio = AspectRatio;
    data_hwstate = EnableHWR;
    data_halfwave = 0;
    % data_halfwave = 40;
    data_supPhases = 2; % 'L2 norm'
    data_inhibMethod = 1; % 'No surround inhibition'
    % data_inhibMethod = 3; % anisotropic surround inhibition
    % data_inhibMethod = 2; % Isotropic surround inhibition
    data_supIsoinhib = 3; % 'L-infinity norm'
    % data_alpha = 1;
    data_alpha = 1.5;    
    data_k1 = 1;
    data_k2 = 4;
    if size(Orientations,2) == 1
        data_selection = (1:data_nroriens);
    else
        data_selection = 1:size(Orientations,2);
    end
    data_thinning = EnableThinning;
    % data.thinning = 1;
    data_hyst = EnableHysteresisThresholding;    
    data_tlow = 0.21;
    data_thigh = 0.7;
    data_invertOutput = 0;
    
    data.hwstate = data_hwstate;
    data.phaseoffset = data_phaseoffset;
    data.halfwave = data_halfwave;
    data.supPhases = data_supPhases;
    data.inhibMethod = data_inhibMethod;
    data.supIsoinhib = data_supIsoinhib;
    data.alpha = data_alpha;
    data.k1 = data_k1;
    data.k2 = data_k2;
    data.selection = data_selection;
    data.thinning = data_thinning;
    data.hyst = data_hyst;
    data.tlow = data_tlow;
    data.thigh = data_thigh;
    data.invertOutput = data_invertOutput;
end
% end of addition 1811011128

% added by Holy 1811071545
if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
    gaborArray = gaborFilterBankSpecific(5,6,39,39);  % Generates the Gabor filter bank
    featureVector = gaborFeatures(rgb2gray(refImg),gaborArray,4,4);
    featureVector = featureVector';
    
    lenGaborSpecificFeature = length(featureVector);
end
% end of addition 1811071545

% % added by Holy 1807271516
% binary_picture = imbinarize(rgb2gray(refImg),'adaptive','Sensitivity',1);
% gaborArray = gaborFilterBank(5,8,39,39);
% gaborFeature = gaborFeatures(binary_picture,gaborArray,4,4);
% gaborFeature = gaborFeature';
% % end of addition 1807271516

% get up level dir
[dirName,~,~] = fileparts(fileList{1, 1});
upDirName = getUpLevelPath(dirName, 1);

searchKey1 = 'Train';
searchKey2 = 'CV';
searchKey3 = 'Test';

firstFilePathName = fileList{1, 1};

if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
    % added by Holy 1811081502
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), lenGaborsBinHogFeature);
    end
    % end of addition 1811081502
    
%     X = []; % hided by Holy 1807271332
    if contains(featureType, hogFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    end
    
    % added by Holy 1809051555
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), 1);
    end    
    % end of addition 1809051555
    
    % added by Holy 1809111610
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), lenHogFeature);
    end
    % end of addition 1809111610
    
    % added by Holy 1811011130
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), lenHogFeature);
    end
    % end of addition 1811011130
    
    % added by Holy 1811071603
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), lenGaborSpecificFeature);
    end    
    % end of addition 1811071603
    
%     X = zeros(length(fileList), lenGaborFeature); % added by Holy 1807311602
%     X = zeros(length(fileList), 7); % added by Holy 1808011535
    
%     % added by Holy 1807271622
%     trainLabelPathName = fullfile(upDirName, 'imgsTag.txt');
%     trainLabelFileID = fopen(trainLabelPathName);
%     trainLabelCell = textscan(trainLabelFileID,'%d');
%     trainLabel = cell2mat(trainLabelCell);
%     trainLabel = trainLabel';
%     fclose(trainLabelFileID);
%     % end of addition 1807271622
end
if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
    % added by Holy 1811081502
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xval = zeros(length(fileList), lenGaborsBinHogFeature);
    end
    % end of addition 1811081502
    
%     Xval = []; % hided by Holy 1807271335
    if contains(featureType, hogFeatureType,'IgnoreCase',true)        
        Xval = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    end
    
    % added by Holy 1809051555
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        Xval = zeros(length(fileList), 1);
    end    
    % end of addition 1809051555
    
    % added by Holy 1809111610
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
        Xval = zeros(length(fileList), lenHogFeature);
    end
    % end of addition 1809111610
    
    % added by Holy 1811011131
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
        Xval = zeros(length(fileList), lenHogFeature);
    end
    % end of addition 1811011131
    
    % added by Holy 1811071603
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        Xval = zeros(length(fileList), lenGaborSpecificFeature);
    end    
    % end of addition 1811071603
    
%     Xval = zeros(length(fileList), lenGaborFeature); % added by Holy 1807311602
%     Xval = zeros(length(fileList), 7); % added by Holy 1808011535
    yvalPathName = fullfile(upDirName, 'y_CV.txt');
    yvalFileID = fopen(yvalPathName);
    yvalCell = textscan(yvalFileID,'%d');
    yval = cell2mat(yvalCell);
    fclose(yvalFileID);
end
if contains(firstFilePathName, searchKey3,'IgnoreCase',true)
    % added by Holy 1811081502
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), lenGaborsBinHogFeature);
    end
    % end of addition 1811081502
    
%     Xtest = []; % hided by Holy 1807271336
    if contains(featureType, hogFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), lenHogFeature); % added by Holy 1807271334
    end
    
    % added by Holy 1809051555
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), 1);
    end    
    % end of addition 1809051555
    
    % added by Holy 1809111610
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), lenHogFeature);
    end
    % end of addition 1809111610
    
    % added by Holy 1811011132
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), lenHogFeature);
    end
    % end of addition 1811011132
    
    % added by Holy 1811071603
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), lenGaborSpecificFeature);
    end    
    % end of addition 1811071603
    
%     Xtest = zeros(length(fileList), lenGaborFeature); % added by Holy 1807311602
%     Xtest = zeros(length(fileList), 7); % added by Holy 1808011535
    ytestPathName = fullfile(upDirName, 'y_Test.txt');
    ytestFileID = fopen(ytestPathName);
    ytestCell = textscan(ytestFileID,'%d');
    ytest = cell2mat(ytestCell);
    fclose(ytestFileID);
end

% searchKey = 'img';
% searchFileExt = '.jpg';

% % added by Holy 1807271652
% if contains(firstFilePathName, searchKey1)
%     gdaImgPath = fullfile(upDirName, 'imgsTargetGda');
%     fileListGda = getAllFiles(gdaImgPath);
%     XGda = zeros(length(fileListGda), lenHogFeature);
%     poolobj = gcp('nocreate'); % If no pool, do not create new one.
%     if isempty(poolobj)
%         parpool;
%     end
%     
%     ppmGda = ParforProgMon('', length(fileListGda));
%     parfor i = 1:length(fileListGda)
%         windImgN = imread(fileListGda{i, 1});
%         
%         %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%         hogInputImg = windImgN;
%         
%         hogWindRope = extractHOGFeatures(hogInputImg,'CellSize',[hogSize hogSize]);
%         
%         %             X = [X;hogWindRope]; % hided by Holy 1807271336
%         XGda(i,:) = hogWindRope; % added by Holy 1807271337
%         
%         ppmGda.increment();
%     end
% end
% % end of addition 1807271652

if ~debug
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool;
    end
    
%     ppm = ParforProgMon('', length(fileList)); % hided by Holy 1808281434

    if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
        % added by Holy 1808281434
        fprintf('\t Completion: ');
        showTimeToCompletion; startTime=tic;
        p = parfor_progress(length(fileList));
        % end of addition 1808281434
        parfor i = 1:length(fileList)
            % added by Holy 1811081635
            if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
                windImgN = imread(fileList{i, 1});
                
                windImgN = fun_rotateRect(windImgN, theta, rectWinding);
                
                windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
                
                if (size(windImgN,3) ~= 1)
                    windImgN = rgb2gray(windImgN);
                end
                
                windImgN = adapthisteq(windImgN,'NumTiles',[16,16]);
                windImgN = adapthisteq(windImgN,'NumTiles',[8,8]);
                windImgN = adapthisteq(windImgN,'NumTiles',[4,4]);
                
                windImgN = medfilt2(windImgN);
                
                gaborsBinHogFeature = GaborTextureSegment(windImgN, gamma, Lambda, b, Theta, phi, shape, hogSize);
                X(i,:) = gaborsBinHogFeature;
            end
            % end of addition 1811081635
            
            % hided by Holy 1809121609
%             if contains(featureType, hogFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = fun_rotateRect(windImgN, theta, rectWinding); % added by Holy 1811050839
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
%                 
%                 %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 %             hogInputImg = windImgN; % hided by Holy 1807311454
%                 % added by Holy 1807311455
%                 hogInputImg1 = im2double(windImgN);
%                 hogInputImg1 = rgb2gray(hogInputImg1);
%                 % hided by Holy 1809051529
%                 %             hogInputImg3 = adapthisteq(hogInputImg2);
%                 %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
%                 %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
%                 % end of hide 1809051529
%                 % end of addition 1807311455
%                 
%                 %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','Sensitivity',1); % added by Holy 1808041457
%                 % hided by Holy 1811061704
% %                 hogInputImg1 = medfilt2(hogInputImg1); % added by Holy 1811051005
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6); % added by Holy 1811050804
%                 % end of hide 1811061704
%                 
%                 % added by Holy 1811061705
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[16,16]);
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[8,8]);
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[4,4]); % added by Holy 1811080848
%                 hogInputImg1 = medfilt2(hogInputImg1); % hided by Holy 1811080848
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.7); % hided by Holy 1811080848
%                 % end of addition 1811061705
%                 
% %                 % added by Holy 1811050927
% %                 hogInputImg1 = adapthisteq(hogInputImg1);
% %                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[4,4]);
% %                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[2,2]);
% %                 % end of addition 1811050927
%                 
%                 hogWindRope = extractHOGFeatures(hogInputImg1,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
%                 %             gaborFeatureVec = gaborFeatures(hogInputImg,gaborArray,4,4); % hided by Holy 1808011537
%                 %             [~,gaborResult] = gaborFeatures(hogInputImg,gaborArray,4,4); % added by Holy 1808011538
%                 
%                 %             % added by Holy 1808031117
%                 %             varValue = complexCellAbsVar(gaborResult);
%                 %             X(i,:) = varValue;
%                 %             % end of addition 1808031117
%                 
%                 %             X = [X;hogWindRope]; % hided by Holy 1807271336
%                 X(i,:) = hogWindRope; % added by Holy 1807271337
%             end
            
            % added by Holy 1809051555
%             if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
%                 
%                 %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 %             hogInputImg = windImgN; % hided by Holy 1807311454
%                 % added by Holy 1807311455
%                 hogInputImg2 = im2double(windImgN);
%                 hogInputImg2 = rgb2gray(hogInputImg2);
%                 % hided by Holy 1809051529
%                 %             hogInputImg3 = adapthisteq(hogInputImg2);
%                 %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
%                 %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
%                 % end of hide 1809051529
%                 % end of addition 1807311455
%                 
%                 %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
%                 hogInputImg2 = imbinarize(hogInputImg2,'adaptive','Sensitivity',1); % added by Holy 1808041457
%                 
%                 [~,gaborResult] = gaborFeatures(hogInputImg2,gaborArray,4,4);
%                 absValue = abs(gaborResult{1,1});                
% %                 X(i,:) = max(absValue(:)); hided by Holy 1809060851                
%                 
%                 % added by Holy 1809060851
%                 absValue = absValue(:);
%                 absValueSort = sort(absValue, 'descend');
%                 X(i,:) = sum(absValueSort(1:indBig));
%                 % end of addition 1809060851
%             end
            % end of addition 1809051555
            % end of hide 1809121609
            
            % hided by Holy 1811011135
%             % added by Holy 1809111615
%             if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
% %                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
% %                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310858
%                 % added by Holy 1810310901
%                 img = imread(fileList{i, 1});
%                 img = fun_rotateRect(img, theta, rectWinding);
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
%                 % end of addition 1810310901
%                 data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
%                 
%                 hogWindRope = fun_calGaborBWHog(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
%                 X(i,:) = hogWindRope;
%             end
%             % end of addition 1809111615
            % end of hide 1811011135
            
            % hided by Holy 1811050759
%             % added by Holy 1811011135
%             if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
% %                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
% %                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310858
%                 % added by Holy 1810310901
%                 img = imread(fileList{i, 1});
%                 img = fun_rotateRect(img, theta, rectWinding);
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
%                 % end of addition 1810310901
%                 data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
%                 
%                 hogWindRope = fun_calGaborBWHogNum(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
%                 X(i,:) = hogWindRope;
%             end
%             % end of addition 1811011135
            % end of hide 1811050759
    
%             X(i,:) = gaborFeatureVec'; % added by Holy 1807311607
%             % added by Holy 1808011539
%             sumDiff = complexCellAbsSumDiff(gaborResult,6)
%             X(i,:) = sumDiff;
%             % end of addition 1808011539
            
%             ppm.increment(); % hided by Holy 1808281436
            
            % added by Holy 1811071606
%             if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = fun_rotateRect(windImgN, theta, rectWinding);
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
%                 
%                 img = rgb2gray(windImgN);
%                 
%                 img = adapthisteq(img,'NumTiles',[16,16]);
%                 img = adapthisteq(img,'NumTiles',[8,8]);
%                 img = adapthisteq(img,'NumTiles',[4,4]);
%                                 
%                 img = medfilt2(img);
%                 gaborArray = gaborFilterBankSpecific(5,6,39,39);  % Generates the Gabor filter bank
%                 featureVector = gaborFeatures(img,gaborArray,4,4);
%                 featureVector = featureVector';
%                 
%                 X(i,:) = featureVector;
%             end
            % end of addition 1811071606
            
            % added by Holy 1808281436
            p = parfor_progress;
            showTimeToCompletion(p/100, [], [], startTime);
            % end of addition 1808281436
        end
    end

    if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
        % added by Holy 1808281434
        fprintf('\t Completion: ');
        showTimeToCompletion; startTime=tic;
        p = parfor_progress(length(fileList));
        % end of addition 1808281434
        parfor i = 1:length(fileList)
            % added by Holy 1811081635
            if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
                windImgN = imread(fileList{i, 1});
                
                windImgN = fun_rotateRect(windImgN, theta, rectWinding);
                
                windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
                
                if (size(windImgN,3) ~= 1)
                    windImgN = rgb2gray(windImgN);
                end
                
                windImgN = adapthisteq(windImgN,'NumTiles',[16,16]);
                windImgN = adapthisteq(windImgN,'NumTiles',[8,8]);
                windImgN = adapthisteq(windImgN,'NumTiles',[4,4]);
                
                windImgN = medfilt2(windImgN);
                
                gaborsBinHogFeature = GaborTextureSegment(windImgN, gamma, Lambda, b, Theta, phi, shape, hogSize);
                Xval(i,:) = gaborsBinHogFeature;
            end
            % end of addition 1811081635
            
            % hided by Holy 1809121609
%             if contains(featureType, hogFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = fun_rotateRect(windImgN, theta, rectWinding); % added by Holy 1811050839
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
%                 
%                 %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 %             hogInputImg = windImgN; % hided by Holy 1807311457
%                 
%                 % added by Holy 1807311455
%                 hogInputImg1 = im2double(windImgN);
%                 hogInputImg1 = rgb2gray(hogInputImg1);
%                 
%                 % hided by Holy 1809051533
%                 %             hogInputImg3 = adapthisteq(hogInputImg2);
%                 %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
%                 %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
%                 % end of hide 1809051533
%                 % end of addition 1807311455
%                 
%                 %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','Sensitivity',1); % added by Holy 1808041457
%                 % hided by Holy 1811061704
% %                 hogInputImg1 = medfilt2(hogInputImg1); % added by Holy 1811051005
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6); % added by Holy 1811050804
%                 % end of hide 1811061704
%                 
%                 % added by Holy 1811061705
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[16,16]);
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[8,8]);
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[4,4]); % added by Holy 1811080848
%                 hogInputImg1 = medfilt2(hogInputImg1); % hided by Holy 1811080848
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.7); % hided by Holy 1811080848
%                 % end of addition 1811061705
%                 
% %                 % added by Holy 1811050927
% %                 hogInputImg1 = adapthisteq(hogInputImg1);
% %                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[4,4]);
% %                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[2,2]);
% %                 % end of addition 1811050927
%                 
%                 hogWindRope = extractHOGFeatures(hogInputImg1,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
%                 %             gaborFeatureVec = gaborFeatures(hogInputImg,gaborArray,4,4); % hided by Holy 1808011542
%                 %             [~,gaborResult] = gaborFeatures(hogInputImg,gaborArray,4,4); % added by Holy 1808011538
%                 
%                 %             % added by Holy 1808031117
%                 %             varValue = complexCellAbsVar(gaborResult);
%                 %             Xval(i,:) = varValue;
%                 %             % end of addition 1808031117
%                 
%                 %             Xval = [Xval;hogWindRope]; % hided by Holy 1807271336
%                 Xval(i,:) = hogWindRope; % added by Holy 1807271337
%             end
            
            % added by Holy 1809051555
%             if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
%                 
%                 %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 %             hogInputImg = windImgN; % hided by Holy 1807311457
%                 
%                 % added by Holy 1807311455
%                 hogInputImg2 = im2double(windImgN);
%                 hogInputImg2 = rgb2gray(hogInputImg2);
%                 
%                 % hided by Holy 1809051533
%                 %             hogInputImg3 = adapthisteq(hogInputImg2);
%                 %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
%                 %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
%                 % end of hide 1809051533
%                 % end of addition 1807311455
%                 
%                 %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
%                 hogInputImg2 = imbinarize(hogInputImg2,'adaptive','Sensitivity',1); % added by Holy 1808041457
%                 
%                 [~,gaborResult] = gaborFeatures(hogInputImg2,gaborArray,4,4);
%                 absValue = abs(gaborResult{1,1});
% %                 Xvals(i,:) = max(absValue(:)); % hided by Holy 1809060857
%                 
%                 % added by Holy 1809060851
%                 absValue = absValue(:);
%                 absValueSort = sort(absValue, 'descend');
%                 Xval(i,:) = sum(absValueSort(1:indBig));
%                 % end of addition 1809060851
%             end
            % end of addition 1809051555
            % end of hide 1809121609
            
            % hided by Holy 1811011142
%             % added by Holy 1809121544
%             if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
% %                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
% %                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310903
%                 % added by Holy 1810310901
%                 img = imread(fileList{i, 1});
%                 img = fun_rotateRect(img, theta, rectWinding);
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
%                 % end of addition 1810310901
%                 data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
%                 
%                 hogWindRope = fun_calGaborBWHog(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
%                 Xval(i,:) = hogWindRope;
%             end
%             % end of addition 1809121544
            % end of hide 1811011142
            
            % hided by Holy 1811050759
%             % added by Holy 1811011142
%             if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
% %                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
% %                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310903
%                 % added by Holy 1810310901
%                 img = imread(fileList{i, 1});
%                 img = fun_rotateRect(img, theta, rectWinding);
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
%                 % end of addition 1810310901
%                 data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
%                 
%                 hogWindRope = fun_calGaborBWHogNum(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
%                 Xval(i,:) = hogWindRope;
%             end
%             % end of addition 1811011142
            % end of hide 1811050759
            
%             Xval(i,:) = gaborFeatureVec'; % added by Holy 1807311607
%             % added by Holy 1808011539
%             sumDiff = complexCellAbsSumDiff(gaborResult,6)
%             Xval(i,:) = sumDiff;
%             % end of addition 1808011539
            
%             ppm.increment(); % hided by Holy 1808281438
            
            % added by Holy 1811071606
%             if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = fun_rotateRect(windImgN, theta, rectWinding);
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
%                 
%                 img = rgb2gray(windImgN);
%                 
%                 img = adapthisteq(img,'NumTiles',[16,16]);
%                 img = adapthisteq(img,'NumTiles',[8,8]);
%                 img = adapthisteq(img,'NumTiles',[4,4]);
%                                 
%                 img = medfilt2(img);
%                 gaborArray = gaborFilterBankSpecific(5,6,39,39);  % Generates the Gabor filter bank
%                 featureVector = gaborFeatures(img,gaborArray,4,4);
%                 featureVector = featureVector';
%                 
%                 Xval(i,:) = featureVector;
%             end
            % end of addition 1811071606
            
            % added by Holy 1808281436
            p = parfor_progress;
            showTimeToCompletion(p/100, [], [], startTime);
            % end of addition 1808281436
        end
    end
    if contains(firstFilePathName, searchKey3,'IgnoreCase',true)
        % added by Holy 1808281434
        fprintf('\t Completion: ');
        showTimeToCompletion; startTime=tic;
        p = parfor_progress(length(fileList));
        % end of addition 1808281434
        parfor i = 1:length(fileList)
            % added by Holy 1811081635
            if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
                windImgN = imread(fileList{i, 1});
                
                windImgN = fun_rotateRect(windImgN, theta, rectWinding);
                
                windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
                
                if (size(windImgN,3) ~= 1)
                    windImgN = rgb2gray(windImgN);
                end
                
                windImgN = adapthisteq(windImgN,'NumTiles',[16,16]);
                windImgN = adapthisteq(windImgN,'NumTiles',[8,8]);
                windImgN = adapthisteq(windImgN,'NumTiles',[4,4]);
                
                windImgN = medfilt2(windImgN);
                
                gaborsBinHogFeature = GaborTextureSegment(windImgN, gamma, Lambda, b, Theta, phi, shape, hogSize);
                Xtest(i,:) = gaborsBinHogFeature;
            end
            % end of addition 1811081635
            
            % hided by Holy 1809121609
%             if contains(featureType, hogFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = fun_rotateRect(windImgN, theta, rectWinding); % added by Holy 1811050839
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
%                 
%                 %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 %             hogInputImg = windImgN; % hided by Holy 1807311458
%                 
%                 % added by Holy 1807311455
%                 hogInputImg1 = im2double(windImgN);
%                 hogInputImg1 = rgb2gray(hogInputImg1);
%                 
%                 % hided by Holy 1809051536
%                 %             hogInputImg3 = adapthisteq(hogInputImg2);
%                 %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
%                 %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
%                 % end of hide 1809051536
%                 % end of addition 1807311455
%                 
%                 %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','Sensitivity',1); % added by Holy 1808041457
%                 % hided by Holy 1811061704
% %                 hogInputImg1 = medfilt2(hogInputImg1); % added by Holy 1811051005
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.6); % added by Holy 1811050804
%                 % end of hide 1811061704
%                 
%                 % added by Holy 1811061705
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[16,16]);
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[8,8]);
%                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[4,4]); % added by Holy 1811080848
%                 hogInputImg1 = medfilt2(hogInputImg1); % hided by Holy 1811080848
% %                 hogInputImg1 = imbinarize(hogInputImg1,'adaptive','ForegroundPolarity','bright','Sensitivity',0.7); % hided by Holy 1811080848
%                 % end of addition 1811061705
%                 
% %                 % added by Holy 1811050927
% %                 hogInputImg1 = adapthisteq(hogInputImg1);
% %                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[4,4]);
% %                 hogInputImg1 = adapthisteq(hogInputImg1,'NumTiles',[2,2]);
% %                 % end of addition 1811050927
%             
%                 hogWindRope = extractHOGFeatures(hogInputImg1,'CellSize',[hogSize hogSize]); % hided by Holy 1807311605
%                 %             gaborFeatureVec = gaborFeatures(hogInputImg,gaborArray,4,4);
%                 %             [~,gaborResult] = gaborFeatures(hogInputImg,gaborArray,4,4); % added by Holy 1808011538
%                 
%                 %             % added by Holy 1808031117
%                 %             varValue = complexCellAbsVar(gaborResult);
%                 %             Xtest(i,:) = varValue;
%                 %             % end of addition 1808031117
%                 
%                 %             Xtest = [Xtest;hogWindRope]; % hided by Holy 1807271336
%                 Xtest(i,:) = hogWindRope; % added by Holy 1807271337
%             end
            
            % added by Holy 1809051555
%             if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:); % added by Holy 1808021424
%                 
%                 %             hogInputImg = windImgN(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 %             hogInputImg = windImgN; % hided by Holy 1807311458
%                 
%                 % added by Holy 1807311455
%                 hogInputImg2 = im2double(windImgN);
%                 hogInputImg2 = rgb2gray(hogInputImg2);
%                 
%                 % hided by Holy 1809051536
%                 %             hogInputImg3 = adapthisteq(hogInputImg2);
%                 %             hogInputImg4 = adapthisteq(hogInputImg3,'NumTiles',[4,4]);
%                 %             hogInputImg = adapthisteq(hogInputImg4,'NumTiles',[2,2]);
%                 % end of hide 1809051536
%                 % end of addition 1807311455
%                 
%                 %             hogInputImg = imbinarize(hogInputImg,'adaptive','Sensitivity',1); % added by Holy 1808011341
%                 hogInputImg2 = imbinarize(hogInputImg2,'adaptive','Sensitivity',1); % added by Holy 1808041457
%                 
%                 [~,gaborResult] = gaborFeatures(hogInputImg2,gaborArray,4,4);
%                 absValue = abs(gaborResult{1,1});
% %                 Xtest(i,:) = max(absValue(:)); % hided by Holy 1809060858
%                 
%                 % added by Holy 1809060851
%                 absValue = absValue(:);
%                 absValueSort = sort(absValue, 'descend');
%                 Xtest(i,:) = sum(absValueSort(1:indBig));
%                 % end of addition 1809060851
%             end
            % end of addition 1809051555
            % end of hide 1809121609
            
            % hided by Holy 1811011145
%             % added by Holy 1809121548
%             if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
% %                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
% %                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310904
%                 % added by Holy 1810310901
%                 img = imread(fileList{i, 1});
%                 img = fun_rotateRect(img, theta, rectWinding);
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
%                 % end of addition 1810310901
%                 data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
%                 
%                 hogWindRope = fun_calGaborBWHog(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
%                 Xtest(i,:) = hogWindRope;
%             end
%             % end of addition 1809121548
            % end of hide 1811011145
            
            % hided by Holy 1811050810
%             % added by Holy 1811011145
%             if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
% %                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
% %                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310904
%                 % added by Holy 1810310901
%                 img = imread(fileList{i, 1});
%                 img = fun_rotateRect(img, theta, rectWinding);
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
%                 % end of addition 1810310901
%                 data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
%                 
%                 hogWindRope = fun_calGaborBWHogNum(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
%                 Xtest(i,:) = hogWindRope;
%             end
%             % end of addition 1811011145
            % end of hide 1811050810
            
%             Xtest(i,:) = gaborFeatureVec'; % added by Holy 1807311607
%             % added by Holy 1808011539
%             sumDiff = complexCellAbsSumDiff(gaborResult,6)
%             Xtest(i,:) = sumDiff;
%             % end of addition 1808011539
            
%             ppm.increment(); % hided by Holy 1808281439
            
            % added by Holy 1811071606
%             if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
%                 windImgN = imread(fileList{i, 1});
%                 
%                 windImgN = fun_rotateRect(windImgN, theta, rectWinding);
%                 
%                 windImgN = windImgN(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);
%                 
%                 img = rgb2gray(windImgN);
%                 
%                 img = adapthisteq(img,'NumTiles',[16,16]);
%                 img = adapthisteq(img,'NumTiles',[8,8]);
%                 img = adapthisteq(img,'NumTiles',[4,4]);
%                                 
%                 img = medfilt2(img);
%                 gaborArray = gaborFilterBankSpecific(5,6,39,39);  % Generates the Gabor filter bank
%                 featureVector = gaborFeatures(img,gaborArray,4,4);
%                 featureVector = featureVector';
%                 
%                 Xtest(i,:) = featureVector;
%             end
            % end of addition 1811071606
            
            % added by Holy 1808281436
            p = parfor_progress;
            showTimeToCompletion(p/100, [], [], startTime);
            % end of addition 1808281436
        end
    end
    
%     % fprintf('Progress:\n');
%     % fprintf(['\n' repmat('.',1,length(fileList)) '\n\n']);
%     parfor i = 1:length(fileList)
%         %     fprintf('\b|\n');
%         [~,FileName,fileExt] = fileparts(fileList{i, 1});
%         if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
%             continue;
%         else
%             windImgN = imread(fileList{i, 1});
%             %             windImgN = imbinarize(rgb2gray(windImgN),'adaptive','Sensitivity',1); % added by Holy 1807261112
%             hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]);
%             
%             if contains(firstFilePathName, searchKey1)
%                 X = [X;hogWindRope];
%             end
%             if contains(firstFilePathName, searchKey2)
%                 Xval = [Xval;hogWindRope];
%             end
%             if contains(firstFilePathName, searchKey3)
%                 Xtest = [Xtest;hogWindRope];
%             end
%         end
%         ppm.increment();
%     end
else
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        parpool;
    end

    if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
        % added by Holy 1808281434
        fprintf('\t Completion: ');
        showTimeToCompletion; startTime=tic;
        p = parfor_progress(length(fileList));
        % end of addition 1808281434
        for i = 1:length(fileList)            
            % added by Holy 1809111615
            if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
%                 [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
%                     data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio); % hided by Holy 1810310947
                % added by Holy 1810310901
                img = imread(fileList{i, 1});
                img = fun_rotateRect(img, theta, rectWinding);
                [data_img, data_orienslist, data_sigmaC] = readandinit_smallWinding_imgEdge(img, ...
                    data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
                % end of addition 1810310901
                data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
                
                hogWindRope = fun_calGaborBWHog(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
                X(i,:) = hogWindRope;
            end
            % end of addition 1809111615
    
            % added by Holy 1808281436
            p = parfor_progress;
            showTimeToCompletion(p/100, [], [], startTime);
            % end of addition 1808281436
        end
    end

    if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
        % added by Holy 1808281434
        fprintf('\t Completion: ');
        showTimeToCompletion; startTime=tic;
        p = parfor_progress(length(fileList));
        % end of addition 1808281434
        parfor i = 1:length(fileList)            
            % added by Holy 1809121544
            if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
                [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
                    data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
                data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
                
                hogWindRope = fun_calGaborBWHog(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
                Xval(i,:) = hogWindRope;
            end
            % end of addition 1809121544
            
            % added by Holy 1808281436
            p = parfor_progress;
            showTimeToCompletion(p/100, [], [], startTime);
            % end of addition 1808281436
        end
    end
    if contains(firstFilePathName, searchKey3,'IgnoreCase',true)        
        for i = 1:length(fileList)
            if i == 1063
                pause;
            end
            if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
                [data_img, data_orienslist, data_sigmaC] = readandinit_hoist_imgEdge(fileList{i, 1}, ...
                    data_orientation, data_nroriens, data_sigma, data_wavelength, data_bandwidth, biasHRatio, biasWRatio);
                data_convResult = gaborfilter(data_img, data_wavelength, data_sigma, data_orienslist, data_phaseoffset, data_aspectratio, data_bandwidth);
                
                hogWindRope = fun_calGaborBWHog(data_convResult,data_orienslist,data_sigmaC,data,hogSize);                
                Xtest(i,:) = hogWindRope;
            end            
        end
    end
%     for i = 1:length(fileList)
%         progressbar(i, length(fileList));
%         [~,FileName,fileExt] = fileparts(fileList{i, 1});
%         if ~contains(FileName, searchKey) || ~strcmpi(fileExt,searchFileExt)
%             continue;
%         else
%             windImgN = imread(fileList{i, 1});
%             hogWindRope = extractHOGFeatures(windImgN,'CellSize',[hogSize hogSize]);
%             if i == 1
%                 testImgId = 1009;
% %                 testImgId = 319;
%                 testImg = imread(fileList{testImgId, 1});
% %                 [rowTestImg, colTestImg, ~] = size(testImg);
% %                 biasHeight = round(rowTestImg/5);
% %                 biasWidth = round(colTestImg/11);
% %                 testImgWithBias = testImg(biasHeight:end-biasHeight,biasWidth:end-biasWidth,:);
%                 testImgWithBias = testImg;
%                 hogInputImg = testImgWithBias;
% %                 processedImage = imbinarize(rgb2gray(testImg),'adaptive','Sensitivity',1);
%                 %                 se1 = strel('disk', 2);
%                 %                 processedImage = imdilate(processedImage, se1);
%                 %                 [featureVector,hogVisualization] = extractHOGFeatures(processedImage,...
%                 %                     'CellSize',[hogSize hogSize],'NumBins',9);
%                 [featureVector,hogVisualization] = extractHOGFeatures(hogInputImg,...
%                     'CellSize',[hogSize hogSize],'NumBins',9);
%                 figure;
%                 imshow(testImg);
%                 figure;
%                 imshow(hogInputImg);
%                 hold on;
%                 plot(hogVisualization,'Color','r');
%                 hold off;
%                 return;
%             end
%             if contains(firstFilePathName, searchKey1)
%                 X = [X;hogWindRope];
%             end
%             if contains(firstFilePathName, searchKey2)
%                 Xval = [Xval;hogWindRope];
%             end
%             if contains(firstFilePathName, searchKey3)
%                 Xtest = [Xtest;hogWindRope];
%             end
%         end
%     end
end

% dataMLFileName = 'dataML.mat'; % hided by Holy 1808131657

if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
    % added by Holy 1811081655
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        [X, XMean, XSigma] = featureNormalize(X);
        TF = isnan(X);
        tag = any(TF);
        tag = ~tag;
        X = X(:,tag);
        [coeff,X,~] = pca(X,'Centered',false);
        
        dataMLInput.X = X;
        dataMLInput.coeff = coeff;
        dataMLInput.XMean = XMean;
        dataMLInput.XSigma = XSigma;
        dataMLInput.tag = tag;        
    end
    % end of addition 1811081655
    
    % hided by Holy 1808011545
    % added by Holy 1807301407
    %     XMean = mean(X); % hided by Holy 1808051158
    %     X = bsxfun(@minus,X,XMean); % hided by Holy 1808041659
    % end of addition 1807301407
    %     [coeff,X,~] = pca(X,'NumComponents',numDim); % hided by Holy 1807301434
    % added by Holy 1807301434
    %     [coeff,X,~] = pca(X); % hided by Holy 1808041700
    %     [coeff,X1,~] = pca(X); % added by Holy 1808041700
    %     X = X(:,1:numDim); % hided by Holy 1807301455
    % end of addition 1807301434
    % end of hide 1808011545
    
    %     % added by Holy 1807271629
    %     trainData = XGda';
    %     trainGda = gda(trainData,trainData,trainLabel);
    %     X = trainGda';
    %     X = X(1:end-10,:);
    %     % end of addition 1807271629
    
    if contains(featureType, hogFeatureType,'IgnoreCase',true)
        % added by Holy 1808051155
        [X, XMean, XSigma] = featureNormalize(X);
        TF = isnan(X);
        tag = any(TF);
        tag = ~tag;
        X = X(:,tag);
        [coeff,X,~] = pca(X,'Centered',false);
        % end of addition 1808051155
        
        % added by Holy 1808131631
        dataMLInput.X = X;
        dataMLInput.coeff = coeff;
        dataMLInput.XMean = XMean;
        dataMLInput.XSigma = XSigma;
        dataMLInput.tag = tag;
        % end of addition 1808131631
    end
    
    % added by Holy 1809051555
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        dataMLInput.X = X;
    end
    % end of addition 1809051555
    
    % added by Holy 1809121550
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
        % added by Holy 1808051155
        [X, XMean, XSigma] = featureNormalize(X);
        TF = isnan(X);
        tag = any(TF);
        tag = ~tag;
        X = X(:,tag);
        [coeff,X,~] = pca(X,'Centered',false);
        % end of addition 1808051155
        
        % added by Holy 1808131631
        dataMLInput.X = X;
        dataMLInput.coeff = coeff;
        dataMLInput.XMean = XMean;
        dataMLInput.XSigma = XSigma;
        dataMLInput.tag = tag;
        % end of addition 1808131631
    end
    % end of addition 1809121550
    
    % added by Holy 1811011146
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
        % added by Holy 1808051155
        [X, XMean, XSigma] = featureNormalize(X);
        TF = isnan(X);
        tag = any(TF);
        tag = ~tag;
        X = X(:,tag);
%         [coeff,X,~] = pca(X,'Centered',false); % hided by Holy 1811011517
        % added by Holy 1811011518
        [coeff,XAcute,~] = pca(X(:,1:end-1),'Centered',false);
        X = [XAcute X(:,end)];
        % end of addition 1811011518
        % end of addition 1808051155
        
        % added by Holy 1808131631
        dataMLInput.X = X;
        dataMLInput.coeff = coeff;
        dataMLInput.XMean = XMean;
        dataMLInput.XSigma = XSigma;
        dataMLInput.tag = tag;
        % end of addition 1808131631
    end
    % end of addition 1811011146
    
    % added by Holy 1811071614
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        [X, XMean, XSigma] = featureNormalize(X);
        TF = isnan(X);
        tag = any(TF);
        tag = ~tag;
        X = X(:,tag);
        [coeff,X,~] = pca(X,'Centered',false);
        
        dataMLInput.X = X;
        dataMLInput.coeff = coeff;
        dataMLInput.XMean = XMean;
        dataMLInput.XSigma = XSigma;
        dataMLInput.tag = tag;        
    end
    % end of addition 1811071614
            
    % hided by Holy 1808131635
%     if exist(dataMLFileName, 'file') == 2
% %         save(dataMLFileName,'X','trainData','trainLabel','-append'); % hided by Holy 1807301124
% %         save(dataMLFileName,'X','-append'); % hided by Holy 1807301417
%         save(dataMLFileName,'X','coeff','XMean','XSigma','tag','-append'); % added by Holy 1807301419
%     else
% %         save(dataMLFileName,'X','trainData','trainLabel'); % hided by Holy 1807301124
% %         save(dataMLFileName,'X','-v7.3'); % hided by Holy 1807301420
%         save(dataMLFileName,'X','coeff','XMean','XSigma','tag','-v7.3'); % added by Holy 1807301419
%     end
    % end of hide 1808131635
end
if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
    % added by Holy 1811081655
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xval = bsxfun(@minus,Xval,dataMLInput.XMean);
        Xval = bsxfun(@rdivide, Xval, dataMLInput.XSigma);
        Xval = Xval(:,dataMLInput.tag);
        Xval = Xval*dataMLInput.coeff;
        
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;       
    end
    % end of addition 1811081655
    
    %     [~,Xval,~] = pca(Xval,'NumComponents',numDim); % hided by Holy 1807301422
    % hided by Holy 1808011548
    % added by Holy 1807301421
    %     load(dataMLFileName, 'coeff', 'XMean', 'XSigma', 'tag'); % hided by Holy 1808131637
    % hided by Holy 1808041701
    %     Xval = bsxfun(@minus,Xval,XMean);
    %     Xval = Xval*coeff;
    % end of hide 1808041701
    %     Xval = Xval(:,1:numDim); % hided by Holy 1807301455
    % end of addition 1807301421
    % end of hide 1808011548
    
    %     % added by Holy 1807271629
    %     load(dataMLFileName, 'trainLabel', 'trainData');
    %     testGda = gda(Xval',trainData,trainLabel);
    %     Xval = testGda';
    %     % end of addition 1807271629
    
    % hided by Holy 1808131638
    %     % added by Holy 1808051201
    %     Xval = bsxfun(@minus,Xval,XMean);
    %     Xval = bsxfun(@rdivide, Xval, XSigma);
    %     Xval = Xval(:,tag);
    %     Xval = Xval*coeff;
    %     % end of addition 1808051201
    % end of hide 1808131638
    
    if contains(featureType, hogFeatureType,'IgnoreCase',true)
        % added by Holy 1808131639
        Xval = bsxfun(@minus,Xval,dataMLInput.XMean);
        Xval = bsxfun(@rdivide, Xval, dataMLInput.XSigma);
        Xval = Xval(:,dataMLInput.tag);
        Xval = Xval*dataMLInput.coeff;
        % end of addition 1808131639
        
        % added by Holy 1808131631
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;
        % end of addition 1808131631
    end
    
    % added by Holy 1809051555
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;
    end
    % end of addition 1809051555
    
    % added by Holy 1809121551
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
        % added by Holy 1808131639
        Xval = bsxfun(@minus,Xval,dataMLInput.XMean);
        Xval = bsxfun(@rdivide, Xval, dataMLInput.XSigma);
        Xval = Xval(:,dataMLInput.tag);
        Xval = Xval*dataMLInput.coeff;
        % end of addition 1808131639
        
        % added by Holy 1808131631
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;
        % end of addition 1808131631
    end
    % end of addition 1809121551
    
    % added by Holy 1811011147
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
        % added by Holy 1808131639
        Xval = bsxfun(@minus,Xval,dataMLInput.XMean);
        Xval = bsxfun(@rdivide, Xval, dataMLInput.XSigma);
        Xval = Xval(:,dataMLInput.tag);
%         Xval = Xval*dataMLInput.coeff; % hided by Holy 1811011525
        % end of addition 1808131639
        
        % added by Holy 1811011526
        XvalAcute = Xval(:,1:end-1)*dataMLInput.coeff;
        Xval = [XvalAcute Xval(:,end)];
        % end of addition 1811011526
        
        % added by Holy 1808131631
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;
        % end of addition 1808131631
    end
    % end of addition 1811011147
    
    % added by Holy 1811071615
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        Xval = bsxfun(@minus,Xval,dataMLInput.XMean);
        Xval = bsxfun(@rdivide, Xval, dataMLInput.XSigma);
        Xval = Xval(:,dataMLInput.tag);
        Xval = Xval*dataMLInput.coeff;
        
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;        
    end
    % end of addition 1811071615
    
    % hided by Holy 1808131635
%     if exist(dataMLFileName, 'file') == 2
%         save(dataMLFileName,'Xval','yval','-append');
%     else
%         save(dataMLFileName,'Xval','yval','-v7.3');
%     end
    % end of hide 1808131635
end
if contains(firstFilePathName, searchKey3,'IgnoreCase',true)
    % added by Holy 1811081655
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
        Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
        Xtest = Xtest(:,dataMLInput.tag);
        Xtest = Xtest*dataMLInput.coeff;
        
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;   
    end
    % end of addition 1811081655
    
    %     [~,Xtest,~] = pca(Xtest,'NumComponents',numDim); % hided by Holy 1807301422
    % hided by Holy 1808011550
    % added by Holy 1807301421
    %     load(dataMLFileName, 'coeff', 'XMean', 'XSigma', 'tag'); % hided by Holy 1808131649
    % hided by Holy 1808041701
    %     Xtest = bsxfun(@minus,Xtest,XMean);
    %     Xtest = Xtest*coeff;
    % end of hide 1808041701
    %     Xtest = Xtest(:,1:numDim); % hided by Holy 1807301455
    % end of addition 1807301421
    % end of hide 1808011550
    
    %     % added by Holy 1807271629
    %     load(dataMLFileName, 'trainLabel', 'trainData');
    %     testGda = gda(Xtest',trainData,trainLabel);
    %     Xtest = testGda';
    %     % end of addition 1807271629
    
    % hided by Holy 1808131649
    %     % added by Holy 1808051201
    %     Xtest = bsxfun(@minus,Xtest,XMean);
    %     Xtest = bsxfun(@rdivide, Xtest, XSigma);
    %     Xtest = Xtest(:,tag);
    %     Xtest = Xtest*coeff;
    %     % end of addition 1808051201
    % end of hide 1808131649
    
    if contains(featureType, hogFeatureType,'IgnoreCase',true)
        % added by Holy 1808131650
        Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
        Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
        Xtest = Xtest(:,dataMLInput.tag);
        Xtest = Xtest*dataMLInput.coeff;
        % end of addition 1808131650
        
        % added by Holy 1808131631
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;
        % end of addition 1808131631
    end
    
    % added by Holy 1809051555
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;
    end
    % end of addition 1809051555
    
    % added by Holy 1809121553
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
        % added by Holy 1808131650
        Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
        Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
        Xtest = Xtest(:,dataMLInput.tag);
        Xtest = Xtest*dataMLInput.coeff;
        % end of addition 1808131650
        
        % added by Holy 1808131631
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;
        % end of addition 1808131631
    end
    % end of addition 1809121553
    
    % added by Holy 1811011334
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
        % added by Holy 1808131650
        Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
        Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
        Xtest = Xtest(:,dataMLInput.tag);
%         Xtest = Xtest*dataMLInput.coeff; % hided by Holy 1811011529
        % end of addition 1808131650
        
        % added by Holy 1811011529
        XtestAcute = Xtest(:,1:end-1)*dataMLInput.coeff;
        Xtest = [XtestAcute Xtest(:,end)];
        % end of addition 1811011529
        
        % added by Holy 1808131631
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;
        % end of addition 1808131631
    end
    % end of addition 1811011334
    
    % added by Holy 1811071617
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
        Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
        Xtest = Xtest(:,dataMLInput.tag);
        Xtest = Xtest*dataMLInput.coeff;
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;        
    end
    % end of addition 1811071617
    
    % hided by Holy 1808131651
%     if exist(dataMLFileName, 'file') == 2
%         save(dataMLFileName,'Xtest','ytest','-append');
%     else
%         save(dataMLFileName,'Xtest','ytest','-v7.3');
%     end
    % end of hide 1808131651
end

dataML = dataMLInput;

% hided by Holy 1808131651
% disp('Mission accomplished.');
% 
% totalElapsedTime = toc(tStart);
% disp(['total time: ' num2str(totalElapsedTime) ' sec']);
% disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
% end of hide 1808131651

% hided by Holy 1807301456
% if ~debug
%     if contains(firstFilePathName, searchKey1)
%         typeWord = searchKey1;
%     end
%     if contains(firstFilePathName, searchKey2)
%         typeWord = searchKey2;
%     end
%     if contains(firstFilePathName, searchKey3)
%         typeWord = searchKey3;
%     end
%     f = fopen('log.txt', 'a');
%     % hided by Holy 1807301440
% %     if contains(firstFilePathName, searchKey1)
% %         fprintf(f,datestr(now));
% %         fprintf(f, ' ');
% %     end
%     % end of addition 1807301440
%     
%     fprintf(f, [typeWord ' time: ']);
%     fprintf(f, '%d min, ',totalElapsedTime/60);
%     if contains(firstFilePathName, searchKey3)
%         fprintf(f, 'hogSize = %d, numDim =  %d, ',hogSize, numDim);
%     end
%     fclose(f);
% end
% end of hide 1807301456
end
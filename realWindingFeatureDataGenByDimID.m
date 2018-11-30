function dataML = realWindingFeatureDataGenByDimID(folder_name,hogSize,biasHRatio,biasWRatio,featureType,dataMLInput,dimInd)

gaborsBinHogFeatureType = 'gaborsBinHog';

if nargin < 6
    dataMLInput = [];
end

fileList = getAllFiles(folder_name);

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

refImg = imread(fileList{1, 1});
refImg = fun_rotateRect(refImg, theta, rectWinding);
refImg = refImg(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio,:);

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

% get up level dir
[dirName,~,~] = fileparts(fileList{1, 1});
upDirName = getUpLevelPath(dirName, 1);

searchKey1 = 'Train';
searchKey2 = 'CV';
searchKey3 = 'Test';

firstFilePathName = fileList{1, 1};

if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        X = zeros(length(fileList), lenGaborsBinHogFeature);
    end    
end

if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xval = zeros(length(fileList), lenGaborsBinHogFeature);
    end
    
    yvalPathName = fullfile(upDirName, 'y_CV.txt');
    yvalFileID = fopen(yvalPathName);
    yvalCell = textscan(yvalFileID,'%d');
    yval = cell2mat(yvalCell);
    fclose(yvalFileID);
end
if contains(firstFilePathName, searchKey3,'IgnoreCase',true)
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xtest = zeros(length(fileList), lenGaborsBinHogFeature);
    end
    
    ytestPathName = fullfile(upDirName, 'y_Test.txt');
    ytestFileID = fopen(ytestPathName);
    ytestCell = textscan(ytestFileID,'%d');
    ytest = cell2mat(ytestCell);
    fclose(ytestFileID);
end

poolobj = gcp('nocreate');
if isempty(poolobj)
    parpool;
end

if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
    fprintf('\t Completion: ');
    showTimeToCompletion; startTime=tic;
    p = parfor_progress(length(fileList));
    
    parfor i = 1:length(fileList)
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
        
        p = parfor_progress;
        showTimeToCompletion(p/100, [], [], startTime);        
    end
end

if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
    fprintf('\t Completion: ');
    showTimeToCompletion; startTime=tic;
    p = parfor_progress(length(fileList));
    
    parfor i = 1:length(fileList)
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
        
        p = parfor_progress;
        showTimeToCompletion(p/100, [], [], startTime);        
    end
end
if contains(firstFilePathName, searchKey3,'IgnoreCase',true)
    fprintf('\t Completion: ');
    showTimeToCompletion; startTime=tic;
    p = parfor_progress(length(fileList));
    
    parfor i = 1:length(fileList)
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
        
        p = parfor_progress;
        showTimeToCompletion(p/100, [], [], startTime);        
    end
end

if contains(firstFilePathName, searchKey1,'IgnoreCase',true)
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        [X, XMean, XSigma] = featureNormalize(X);
        TF = isnan(X);
        tag = any(TF);
        tag = ~tag;
        X = X(:,tag);
        % added by Holy 1811221413
        XMean = XMean(:,tag);
        XSigma = XSigma(:,tag);
        % end of addition 1811221413
%         [coeff,X,~] = pca(X,'Centered',false); % hided by Holy 1811241358
        
        % added by Holy 1811241358
        [coeff,X,latent] = pca(X,'Centered',false);
        latentTag = (latent>1e-3);
        X = X(:,latentTag);
        coeff = coeff(:,latentTag);
        % end of addition 1811241358
        
        dataMLInput.X = X;
        dataMLInput.coeff = coeff;
        dataMLInput.XMean = XMean;
        dataMLInput.XSigma = XSigma;
        dataMLInput.tag = tag;
%         dataMLInput.latentTag = latentTag; % added by Holy 1811241440
    end    
end

if contains(firstFilePathName, searchKey2,'IgnoreCase',true)
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xval = Xval(:,dataMLInput.tag); % added by Holy 1811221415
        Xval = bsxfun(@minus,Xval,dataMLInput.XMean);
        Xval = bsxfun(@rdivide, Xval, dataMLInput.XSigma);
%         Xval = Xval(:,dataMLInput.tag); % hided by Holy 1811221414
        Xval = Xval*dataMLInput.coeff;
        
        dataMLInput.Xval = Xval;
        dataMLInput.yval = yval;
    end    
end

if contains(firstFilePathName, searchKey3,'IgnoreCase',true)
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        Xtest = Xtest(:,dataMLInput.tag); % added by Holy 1811221416
        Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
        Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
%         Xtest = Xtest(:,dataMLInput.tag); % hided by Holy 1811221415
        Xtest = Xtest*dataMLInput.coeff(:,dimInd);
        
        dataMLInput.Xtest = Xtest;
        dataMLInput.ytest = ytest;
    end    
end

dataML = dataMLInput;
end
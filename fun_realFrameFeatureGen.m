function featureData = fun_realFrameFeatureGen(inputImg,hogSize,biasHRatio,biasWRatio,featureType,dataMLInput,dimInd)

gaborsBinHogFeatureType = 'gaborsBinHog';

if (size(inputImg,3) ~= 1)
  inputImg = rgb2gray(inputImg);
end

inputImg = inputImg(1+biasHRatio:end-biasHRatio,1+biasWRatio:end-biasWRatio);

if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)      
    inputImg = adapthisteq(inputImg,'NumTiles',[16,16]);
    inputImg = adapthisteq(inputImg,'NumTiles',[8,8]);
    inputImg = adapthisteq(inputImg,'NumTiles',[4,4]);
    
    inputImg = medfilt2(inputImg);
        
    [~, Nc, ~] = size(inputImg);
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
    Xtest = GaborTextureSegment(inputImg, gamma, Lambda, b, Theta, phi, shape, hogSize);
    
    % pca process
    Xtest = Xtest(:,dataMLInput.tag); % added by Holy 1811221419
    Xtest = bsxfun(@minus,Xtest,dataMLInput.XMean);
    Xtest = bsxfun(@rdivide, Xtest, dataMLInput.XSigma);
%     Xtest = Xtest(:,dataMLInput.tag); % hided by Holy 1811221419
%     Xtest = Xtest*dataMLInput.coeff; % hided by Holy 1811301639
    Xtest = Xtest*dataMLInput.coeff(:,dimInd); % added by Holy 1811301640
    
    featureData = Xtest;    
end
end
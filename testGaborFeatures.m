clear;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

% imgPathName = 'd:\data_seq\changdeWinding\winding2\mess\img00001.jpg'; % mess
% imgPathName = 'd:\data_seq\changdeWinding\winding2\mess\img05916.jpg'; % mess
% imgPathName = 'd:\data_seq\changdeWinding\winding2\test\imgs\img00001.jpg'; % normal
imgPathName = 'd:\data_seq\changdeWinding\winding2\train\imgs\img15830.jpg'; % normal
% imgPathName = 'd:\data_seq\smallWinding1\positiveSamples\test\06-Nov-2018-11-28-50\img00030.jpg'; % mess

rectFilePathName = 'rect_anno_changde2.txt';
rotateFilePathName = 'angle_rotate_changde2.txt';
% rectFilePathName = 'rect_anno_smallWinding.txt';
% rotateFilePathName = 'angle_rotate_smallWinding.txt';

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

inputImg = imread(imgPathName);
if (size(inputImg,3) ~= 1)
  inputImg = rgb2gray(inputImg);
end

imgRected = fun_rotateRect(inputImg, theta, rectWinding);

imgRected = adapthisteq(imgRected,'NumTiles',[16,16]);
imgRected = adapthisteq(imgRected,'NumTiles',[8,8]);
imgRected = adapthisteq(imgRected,'NumTiles',[4,4]);

imgRected = medfilt2(imgRected);

[~, Nc, ~] = size(imgRected);
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
debugTag = true;
Sensitivity = 0.88;
[Xtest,bwImg,smoothedGaborImgs] = fun_GaborTextureSegment(imgRected, gamma, Lambda, b, Theta, phi, shape, Sensitivity, debugTag);

figure('NumberTitle','Off','Name','Gabor feature imgs');
for i = 1:length(Lambda)
    for j = 1:length(Theta)      
        subplot(length(Lambda),length(Theta),(i-1)*length(Theta)+j);        
        imshow(smoothedGaborImgs(:,:,(i-1)*length(Theta)+j),[]);
    end
end
figure, imshow(bwImg);
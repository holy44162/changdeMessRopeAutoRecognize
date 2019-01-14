clear;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

imgPathName = 'd:\data_seq\changdeWinding\winding2\mess\img00001.jpg'; % messs

rectFilePathName = 'rect_anno.txt';
rotateFilePathName = 'angle_rotate.txt';

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
[Xtest,bwImg] = GaborTextureSegment(inputImg, gamma, Lambda, b, Theta, phi, shape, hogSize);
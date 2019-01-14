clear;
tic
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'messRopeFunctions']);


% videoPathName = 'd:\data\190104建起常德新工业园Winding_data\2019-01-04\00000000046000100_20190107120516.mp4';
% videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\00000000007000000(1).mp4';
videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\00000000028000000(1).mp4';
maxFrameNum = 1000;

[pathName,fileName,fileExt] = fileparts(videoPathName);

rectFilePathName = fullfile(pathName, 'rect_anno.txt');
rotateFilePathName = fullfile(pathName, 'angle_rotate.txt');

entropyDiff = fun_getEntropyThreshold(videoPathName, maxFrameNum, rectFilePathName, rotateFilePathName);
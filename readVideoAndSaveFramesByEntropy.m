clear;
tic
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'messRopeFunctions']);


videoPathName = 'd:\data\190104建起常德新工业园Winding_data\2019-01-04\00000000052000000.mp4';

[pathName,fileName,fileExt] = fileparts(videoPathName);

imgsPath = fullfile('d:\data_seq\changdeWinding\winding1\', fileName);

upDirName = getUpLevelPath(imgsPath, 1);

rectFilePathName = fullfile(upDirName, 'rect_anno.txt');
rotateFilePathName = fullfile(upDirName, 'angle_rotate.txt');

fun_readVideoAndSaveFramesByEntropy(videoPathName, imgsPath, rectFilePathName, rotateFilePathName, entropyThreshold);
toc
clear;
tic
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'messRopeFunctions']);


% videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\data_mess_all_2019_01_07_17_27_22(1).mp4';
% videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\00000000022000000(1).mp4';
videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\00000000007000000(1).mp4';

[pathName,fileName,fileExt] = fileparts(videoPathName);

imgsPath = fullfile('d:\data_seq\changdeWinding\winding2\', fileName);

upDirName = getUpLevelPath(imgsPath, 1);

rectFilePathName = fullfile(upDirName, 'rect_anno.txt');
rotateFilePathName = fullfile(upDirName, 'angle_rotate.txt');

entropyThreshold = 1e-3;

fun_readVideoAndSaveFramesByEntropy(videoPathName, imgsPath, rectFilePathName, rotateFilePathName, entropyThreshold);
toc
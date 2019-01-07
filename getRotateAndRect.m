clear;
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'messRopeFunctions']);


% videoPathName = 'd:\data\190104建起常德新工业园Winding_data\2019-01-04\00000000052000000.mp4';
% videoPathName = 'd:\data\190104建起常德新工业园Winding_data\2019-01-04\00000000046000100_20190107120516.mp4';
% videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\data_mess_all_2019_01_07_17_27_22.mp4';
videoPathName = 'd:\data\建起常德新工业园Winding_data\190107\data_mess_all_2019_01_07_17_27_22.mp4';

[pathName,fileName,fileExt] = fileparts(videoPathName);

rectFilePathName = fullfile(pathName, 'rect_anno.txt');
rotateFilePathName = fullfile(pathName, 'angle_rotate.txt');

vidObj = VideoReader(videoPathName);
vidFrame = readFrame(vidObj);

[positionH, theta] = fun_getRotateAndRect(vidFrame, rectFilePathName, rotateFilePathName);
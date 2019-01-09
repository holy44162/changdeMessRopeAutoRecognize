clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);

builtVideoPathName = 'd:\data_seq\changdeWinding\winding2\test.mp4';
normalFramesPath = 'd:\data_seq\changdeWinding\winding2\video\normal\';
messFramesPath = 'd:\data_seq\changdeWinding\winding2\video\mess\';

fps = 25;
portionNum = 7;

fun_buildVideo(builtVideoPathName, normalFramesPath, messFramesPath, fps, portionNum);

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
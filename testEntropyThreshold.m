clear;
tic
% functionPath = 'd:\baiduSyn\files\phd\functions\';
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'messRopeFunctions']);


videoPathName = 'd:\data\190104建起常德新工业园Winding_data\2019-01-04\00000000052000000.mp4';

vidObj = VideoReader(videoPathName);
numFrames = ceil(vidObj.Duration * vidObj.FrameRate);
i = 1;
maxFrameNum = 100;
entropyPre = 0;
entropyDiff = [];
while hasFrame(vidObj)
    progressbar(i, maxFrameNum);
    entropyCurrent = entropy(rgb2gray(vidFrame));
    %     entropyDiff = [entropyDiff;abs(entropyCurrent - entropyPre)];
    entropyDiff = abs(entropyCurrent - entropyPre);
    entropyPre = entropyCurrent;
    i = i + 1;
end
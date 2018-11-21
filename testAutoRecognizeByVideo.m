clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
% functionPath = 'd:\baiduSyn\files\phd\functions\';
addpath(functionPath);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

bestParaMat = 'bestPara.mat';

heightBias = 0;
widthBias = 0;

testFolderName = 'd:\data_seq\smallWinding1\test1\imgs\';

featureType = 'gaborsBinHog';

[F1,tp,fp,indMess,indFn,indFp] = fun_testScriptWithPara(bestParaMat,testFolderName,heightBias,widthBias,featureType);

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
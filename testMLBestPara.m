clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\'; % hided by Holy 1810150847
% functionPath = 'd:\baiduSyn\files\phd\functions\'; % added by Holy 1810150847
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);
addpath([functionPath 'gabor']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

bestParaMat = 'bestPara.mat';
% heightBias = 30; % hided by Holy 1809191647
heightBias = 0; % added by Holy 1809191647
widthBias = 0;
% hided by Holy 1809051115
% trainFolderName = 'd:\data_seq\towerCrane\train\imgs\';
% CVFolderName = 'd:\data_seq\towerCrane\CV\imgs\';
% testFolderName = 'd:\data_seq\towerCrane\test\imgs\';
% end of hide 1809051115

% hided by Holy 1810150848
% % added by Holy 1809051115
% trainFolderName = 'd:\data_seq\towerCraneCompact\trainWithoutP2\imgs\';
% CVFolderName = 'd:\data_seq\towerCraneCompact\CV\imgs\';
% testFolderName = 'd:\data_seq\towerCraneCompact\test2\imgs\';
% % end of addition 1809051115
% end of hide 1810150848

% added by Holy 1810150848
% trainFolderName = 'd:\dataFromDell\towerCraneCompact\trainWithoutP2\imgs\';
% CVFolderName = 'd:\dataFromDell\towerCraneCompact\CV\imgs\';
% testFolderName = 'd:\dataFromDell\towerCraneCompact\test1\imgs\';
% end of addition 1810150848

% hided by Holy 1811061404
% % added by Holy 1810310907
% trainFolderName = 'd:\data_seq\smallWinding\train\imgs\';
% CVFolderName = 'd:\data_seq\smallWinding\CV2\imgs\';
% testFolderName = 'd:\data_seq\smallWinding\test\imgs\';
% % end of addition 1810310907
% end of hide 1811061404

% added by Holy 1811061405
trainFolderName = 'd:\data_seq\smallWinding1\train\imgs\';
CVFolderName = 'd:\data_seq\smallWinding1\CV1\imgs\';
testFolderName = 'd:\data_seq\smallWinding1\test\imgs\';
% end of addition 1811061405

% featureType = 'hogOnly'; % added by Holy 1809051546
% featureType = 'gaborMax'; % added by Holy 1809051546
% featureType = 'gaborBWHog'; % added by Holy 1809111558
% featureType = 'gaborBWNum'; % added by Holy 1811011336
% featureType = 'gaborSpecific';
featureType = 'gaborsBinHog'; % added by Holy 1811081435

[F1,tp,fp,indMess,indFn,indFp] = fun_testScriptWithPara(bestParaMat,trainFolderName,CVFolderName,testFolderName,heightBias,widthBias,featureType);

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
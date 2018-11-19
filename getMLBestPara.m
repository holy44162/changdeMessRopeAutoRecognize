clear;
tStart = tic;
functionPath = 'm:\files\files\phd\functions\';
addpath(functionPath);
% addpath([functionPath 'ParforProgMon']);
addpath([functionPath 'toolbox_general']);
addpath([functionPath 'SoundZone_Tools-master']);
addpath([functionPath 'parfor_progress']);
addpath([functionPath 'gabor']);
addpath([functionPath 'Texture-Segmentation-using-Gabor-Filters']);

maxHogSize = 64; % hided by Holy 1810310955
% maxHogSize = 32; % added by Holy 1810310956
% maxImgEdge = 60; % hided by Holy 1809061537
maxImgEdge = 30; % hided by Holy 1809061537
% maxImgEdge = 120; % added by Holy 1809061538
% heightBias = 30; % hided by Holy 1809191536
heightBias = 0; % added by Holy 1809191536
widthBias = 0;
% hided by Holy 1808290928
% numImgEdgeStep = 1;
% numHogSizeStep = 6;
% end of hide 1808290928

% hided by Holy 1809111600
% added by Holy 1808290928
% numImgEdgeStep = 6; % hided by Holy 1810251107
% numHogSizeStep = 6; % hided by Holy 1810251107
numImgEdgeStep = 0; % added by Holy 1810251107
numHogSizeStep = 1; % added by Holy 1810251107
% numImgEdgeStep = 1; % added by Holy 1810261146
% numHogSizeStep = 6; % added by Holy 1810261146
% end of addition 1808290928
% end of hide 1809111600

% hided by Holy 1810310906
% % added by Holy 1809051115
% trainFolderName = 'd:\data_seq\towerCraneCompact\trainWithoutP2\imgs\';
% CVFolderName = 'd:\data_seq\towerCraneCompact\CV\imgs\';
% testFolderName = 'd:\data_seq\towerCraneCompact\test\imgs\';
% % end of addition 1809051115
% end of hide 1810310906

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

% featureType = 'hogOnly';
% featureType = 'gaborMax'; % added by Holy 1809051614
% featureType = 'gaborBWHog'; % added by Holy 1809111558
% featureType = 'gaborBWNum'; % added by Holy 1811011336
% featureType = 'gaborSpecific';
featureType = 'gaborsBinHog'; % added by Holy 1811081435

[bestPara,paraLog] = fun_testScript(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep,trainFolderName,CVFolderName,testFolderName,featureType);
save('bestPara.mat','bestPara','paraLog');

totalElapsedTime = toc(tStart);
disp(['total time: ' num2str(totalElapsedTime) ' sec']);
disp(['total time: ' num2str(totalElapsedTime/60) ' min']);
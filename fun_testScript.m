function [bestPara,paraLog] = fun_testScript(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep,trainFolderName,CVFolderName,testFolderName,featureType)
% clear;

% hogSize = 64; % hog feature cell size % hided by Holy 1808060828
% numDim = [1:8]; % reduced dim in pca, model best para.
% numDim = [30]; % reduced dim in pca % hided by Holy 1808060845

% added by Holy 1808131555
% numImgEdgeStep = 2; % hided by Holy 1808141638
% minImgEdge = 1; % hided by Holy 1809191524
minImgEdge = 0; % added by Holy 1809191524

% added by Holy 1809211407
if numImgEdgeStep == 0
    imgEdgeSteps = 0;
else
    stepSizeImgEdge = (maxImgEdge - minImgEdge) / numImgEdgeStep;
    imgEdgeSteps = maxImgEdge:-stepSizeImgEdge:minImgEdge;
end
% end of addition 1809211407
% stepSizeImgEdge = (maxImgEdge - minImgEdge) / numImgEdgeStep; % hided by Holy 1809211418

% numHogSizeStep = 2; % hided by Holy 1808141638
% minHogSize = 8; % hided by Holy 1811070837
% minHogSize = 4; % added by Holy 1811070837
minHogSize = 2; % added by Holy 1811080821

% added by Holy 1809211407
if numHogSizeStep == 0
    hogSizeSteps = maxHogSize;
else
    stepSizeHogSize = (maxHogSize - minHogSize) / numHogSizeStep;
    hogSizeSteps = maxHogSize:-stepSizeHogSize:minHogSize;
end
% end of addition 1809211407
% stepSizeHogSize = (maxHogSize - minHogSize) / numHogSizeStep; % hided by Holy 1809211422

hogFeatureType = 'hogOnly';
gaborMaxFeatureType = 'gaborMax';
gaborBWHogFeatureType = 'gaborBWHog'; % added by Holy 1809111558
gaborBWHogNumFeatureType = 'gaborBWNum'; % added by Holy 1811011338
gaborSpecificFeatureType = 'gaborSpecific'; % added by Holy 1811071543
gaborsBinHogFeatureType = 'gaborsBinHog'; % added by Holy 1811081435

bestPara = num2cell(zeros(1,6));
paraLog = []; % added by Holy 1811051339
iProgress = 1;
% for imgEdge = maxImgEdge:-stepSizeImgEdge:minImgEdge % hided by Holy 1809211418
for imgEdge = imgEdgeSteps % added by Holy 1809211418
    progressbar(iProgress,numImgEdgeStep+1);
    heightImgEdge = round(heightBias + imgEdge);
    widthImgEdge = round(widthBias + imgEdge);
    
    % added by Holy 1811081702
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        for hogSize = hogSizeSteps
            hogSize1 = round(hogSize);
            % train
            dataML = realWindingFeatureDataGen(trainFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType);
            
            % CV
            dataML = realWindingFeatureDataGen(CVFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % test
            dataML = realWindingFeatureDataGen(testFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % get best parameters
            numDim = size(dataML.X,2);
            resultMatrix = zeros(numDim,4);
            for i = 1:numDim
                gaussianPara = fun_trainGaussian(dataML,i);
                
                [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
                resultMatrix(i,4) = i;
            end
            sortedResult = sortrows(resultMatrix,'descend');
            
            % remove lines with nan elements
            nanTag = isnan(sortedResult);
            nanInd = any(nanTag,2);
            sortedResult(nanInd,:) = [];
            
            % perform feature selection
            maxF1Row = num2cell(sortedResult(1,:));
            maxF1Row = [maxF1Row {hogSize1} {imgEdge}];
            featureIDs = maxF1Row(4);
            resultCell = cell(1,4);
            selectedIDs = featureIDs;
            for i = 1:size(sortedResult,1)
                if i > 1
                    diff = length(featureIDs{1}) - length(selectedIDs{1});
                    if diff == 0
                        break;
                    else
                        selectedIDs = featureIDs;
                    end
                end
                for j = 1:size(sortedResult,1)
                    if sum(selectedIDs{1}==sortedResult(j,4)) == 1
                        continue;
                    end
                    dimIDs = [selectedIDs{1} sortedResult(j,4)];
                    gaussianPara = fun_trainGaussian(dataML,dimIDs);
                    [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
                    resultCell{1,4} = dimIDs;
                    
                    if resultCell{1,1} == 1
                        bestPara = [bestPara;[resultCell {hogSize1} {imgEdge}]];
                    end
                                        
                    if resultCell{1,1} > maxF1Row{1}
                        maxF1Row(1:4) = resultCell;
                        featureIDs = maxF1Row(4);
                        
                        if maxF1Row{1} > bestPara{1,1}
                            bestPara = maxF1Row;                            
                        end                        
                    end
                end
            end
            paraLog = [paraLog;maxF1Row];
        end
    end
    % end of addition 1811081702
    
    if contains(featureType, hogFeatureType,'IgnoreCase',true)
%         for hogSize = maxHogSize:-stepSizeHogSize:minHogSize % hided by Holy 1809211424
        for hogSize = hogSizeSteps % added by Holy 1809211424
            hogSize1 = round(hogSize); % added by Holy 1809191551
            % train
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTrain\imgsTarget\'; % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\train\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(trainFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType);
            
            % CV
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactCV\imgsTarget\';  % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\CV\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(CVFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % test
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTest\imgsTarget\'; % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\test\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(testFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % get best parameters
            numDim = size(dataML.X,2);
            resultMatrix = zeros(numDim,4);
            for i = 1:numDim
                gaussianPara = fun_trainGaussian(dataML,i);
                
                [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
                resultMatrix(i,4) = i;
            end
            sortedResult = sortrows(resultMatrix,'descend');
            
            % remove lines with nan elements
            nanTag = isnan(sortedResult);
            nanInd = any(nanTag,2);
            sortedResult(nanInd,:) = [];
            
            % perform feature selection
            maxF1Row = num2cell(sortedResult(1,:));
            maxF1Row = [maxF1Row {hogSize1} {imgEdge}];
            featureIDs = maxF1Row(4);
            resultCell = cell(1,4);
            selectedIDs = featureIDs;
            for i = 1:size(sortedResult,1)
                if i > 1
                    diff = length(featureIDs{1}) - length(selectedIDs{1});
                    if diff == 0
                        break;
                    else
                        selectedIDs = featureIDs;
                    end
                end
                for j = 1:size(sortedResult,1)
                    if sum(selectedIDs{1}==sortedResult(j,4)) == 1
                        continue;
                    end
                    dimIDs = [selectedIDs{1} sortedResult(j,4)];
                    gaussianPara = fun_trainGaussian(dataML,dimIDs);
                    [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
                    resultCell{1,4} = dimIDs;
                    
                    % added by Holy 1808141552
                    if resultCell{1,1} == 1
                        bestPara = [bestPara;[resultCell {hogSize1} {imgEdge}]];
                    end
                    % end of addition 1808141552
                    
                    if resultCell{1,1} > maxF1Row{1}
                        %                     maxF1Row = resultCell; % hided by Holy 1808141436
                        maxF1Row(1:4) = resultCell; % added by Holy 1808141437
                        featureIDs = maxF1Row(4);
                        
                        % added by Holy 1808141447
                        if maxF1Row{1} > bestPara{1,1}
                            bestPara = maxF1Row;                            
                        end
                        % end of addition 1808141447
                    end
%                     paraLog = [paraLog;maxF1Row]; % added by Holy 1811051342
                end
            end
            paraLog = [paraLog;maxF1Row]; % added by Holy 1811070842
        end
    end
    
    if contains(featureType, gaborMaxFeatureType,'IgnoreCase',true)
        dataML = realWindingFeatureDataGen(trainFolderName,maxHogSize,heightImgEdge,widthImgEdge,featureType);
        dataML = realWindingFeatureDataGen(CVFolderName,maxHogSize,heightImgEdge,widthImgEdge,featureType,dataML);
        dataML = realWindingFeatureDataGen(testFolderName,maxHogSize,heightImgEdge,widthImgEdge,featureType,dataML);
        
        gaussianPara = fun_trainGaussian(dataML,1);
        resultCell = cell(1,6);
        resultCell{1,1} = 0;
        resultCell{1,6} = imgEdge;
        [resultCell{1,1},resultCell{1,2},resultCell{1,3},resultCell{1,4},resultCell{1,5}] = fun_testGaussian(dataML,1,gaussianPara);
        
        if resultCell{1,1} > bestPara{1,1}
            bestPara = resultCell;
        end
        paraLog = [paraLog;maxF1Row]; % added by Holy 1811051342
    end
    
    if contains(featureType, gaborBWHogFeatureType,'IgnoreCase',true)
%         for hogSize = maxHogSize:-stepSizeHogSize:minHogSize % hided by Holy 1809211425
        for hogSize = hogSizeSteps % added by Holy 1809211424
            hogSize1 = round(hogSize); % added by Holy 1809191551
            % train
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTrain\imgsTarget\'; % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\train\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(trainFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType);
            
            % CV
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactCV\imgsTarget\';  % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\CV\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(CVFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % test
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTest\imgsTarget\'; % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\test\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(testFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % get best parameters
            numDim = size(dataML.X,2);
            resultMatrix = zeros(numDim,4);
            for i = 1:numDim
                gaussianPara = fun_trainGaussian(dataML,i);
                
                [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
                resultMatrix(i,4) = i;
            end
            sortedResult = sortrows(resultMatrix,'descend');
            
            % remove lines with nan elements
            nanTag = isnan(sortedResult);
            nanInd = any(nanTag,2);
            sortedResult(nanInd,:) = [];
            
            % perform feature selection
            maxF1Row = num2cell(sortedResult(1,:));
            maxF1Row = [maxF1Row {hogSize1} {imgEdge}];
            featureIDs = maxF1Row(4);
            resultCell = cell(1,4);
            selectedIDs = featureIDs;
            for i = 1:size(sortedResult,1)
                if i > 1
                    diff = length(featureIDs{1}) - length(selectedIDs{1});
                    if diff == 0
                        break;
                    else
                        selectedIDs = featureIDs;
                    end
                end
                for j = 1:size(sortedResult,1)
                    if sum(selectedIDs{1}==sortedResult(j,4)) == 1
                        continue;
                    end
                    dimIDs = [selectedIDs{1} sortedResult(j,4)];
                    gaussianPara = fun_trainGaussian(dataML,dimIDs);
                    [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
                    resultCell{1,4} = dimIDs;
                    
                    % added by Holy 1808141552
                    if resultCell{1,1} == 1
                        bestPara = [bestPara;[resultCell {hogSize1} {imgEdge}]];
                    end
                    % end of addition 1808141552
                    
                    if resultCell{1,1} > maxF1Row{1}
                        %                     maxF1Row = resultCell; % hided by Holy 1808141436
                        maxF1Row(1:4) = resultCell; % added by Holy 1808141437
                        featureIDs = maxF1Row(4);
                        
                        % added by Holy 1808141447
                        if maxF1Row{1} > bestPara{1,1}
                            bestPara = maxF1Row;
                        end
                        % end of addition 1808141447
                    end
%                     paraLog = [paraLog;maxF1Row]; % added by Holy 1811051342
                end
            end
           paraLog = [paraLog;maxF1Row]; % added by Holy 1811070842 
        end
    end
    
    % added by Holy 1811011339
    if contains(featureType, gaborBWHogNumFeatureType,'IgnoreCase',true)
%         for hogSize = maxHogSize:-stepSizeHogSize:minHogSize % hided by Holy 1809211425
        for hogSize = hogSizeSteps % added by Holy 1809211424
            hogSize1 = round(hogSize); % added by Holy 1809191551
            % train
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTrain\imgsTarget\'; % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\train\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(trainFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType);
            
            % CV
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactCV\imgsTarget\';  % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\CV\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(CVFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % test
            %         folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTest\imgsTarget\'; % hided by Holy 1808281445
            %         folder_name = 'd:\data_seq\towerCrane\test\imgs\'; % added by Holy 1808281445
            dataML = realWindingFeatureDataGen(testFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % get best parameters
%             numDim = size(dataML.X,2); % hided by Holy 1811011540
            numDim = size(dataML.X,2) - 1; % added by Holy 1811011540
            resultMatrix = zeros(numDim,4);
            for i = 1:numDim
                gaussianPara = fun_trainGaussian(dataML,i);
                
                [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
                resultMatrix(i,4) = i;
            end
            sortedResult = sortrows(resultMatrix,'descend');
            
            % remove lines with nan elements
            nanTag = isnan(sortedResult);
            nanInd = any(nanTag,2);
            sortedResult(nanInd,:) = [];
            
            % perform feature selection
            maxF1Row = num2cell(sortedResult(1,:));
            maxF1Row = [maxF1Row {hogSize1} {imgEdge}];
            featureIDs = maxF1Row(4);
            resultCell = cell(1,4);
            selectedIDs = featureIDs;
            for i = 1:size(sortedResult,1)
                if i > 1
                    diff = length(featureIDs{1}) - length(selectedIDs{1});
                    if diff == 0
                        break;
                    else
                        selectedIDs = featureIDs;
                    end
                end
                for j = 1:size(sortedResult,1)
                    if sum(selectedIDs{1}==sortedResult(j,4)) == 1
                        continue;
                    end
                    dimIDs = [selectedIDs{1} sortedResult(j,4)];
                    gaussianPara = fun_trainGaussian(dataML,dimIDs);
                    [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
                    resultCell{1,4} = dimIDs;
                    
                    % added by Holy 1808141552
                    if resultCell{1,1} == 1
                        bestPara = [bestPara;[resultCell {hogSize1} {imgEdge}]];
                    end
                    % end of addition 1808141552
                    
                    if resultCell{1,1} > maxF1Row{1}
                        %                     maxF1Row = resultCell; % hided by Holy 1808141436
                        maxF1Row(1:4) = resultCell; % added by Holy 1808141437
                        featureIDs = maxF1Row(4);
                        
                        % added by Holy 1808141447
                        if maxF1Row{1} > bestPara{1,1}
                            bestPara = maxF1Row;
                        end
                        % end of addition 1808141447
                    end
%                     paraLog = [paraLog;maxF1Row]; % added by Holy 1811051342
                end
            end
            paraLog = [paraLog;maxF1Row]; % added by Holy 1811070842
        end
    end
    % end of addition 1811011339
    
    % added by Holy 1811071619
    if contains(featureType, gaborSpecificFeatureType,'IgnoreCase',true)
        dataML = realWindingFeatureDataGen(trainFolderName,minHogSize,heightImgEdge,widthImgEdge,featureType);
        
        % CV
        dataML = realWindingFeatureDataGen(CVFolderName,minHogSize,heightImgEdge,widthImgEdge,featureType,dataML);
        
        % test
        dataML = realWindingFeatureDataGen(testFolderName,minHogSize,heightImgEdge,widthImgEdge,featureType,dataML);
        
        % get best parameters
        numDim = size(dataML.X,2);
        resultMatrix = zeros(numDim,4);
        for i = 1:numDim
            gaussianPara = fun_trainGaussian(dataML,i);
            
            [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
            resultMatrix(i,4) = i;
        end
        sortedResult = sortrows(resultMatrix,'descend');
        
        % remove lines with nan elements
        nanTag = isnan(sortedResult);
        nanInd = any(nanTag,2);
        sortedResult(nanInd,:) = [];
        
        % perform feature selection
        maxF1Row = num2cell(sortedResult(1,:));
        maxF1Row = [maxF1Row {minHogSize} {imgEdge}];
        featureIDs = maxF1Row(4);
        resultCell = cell(1,4);
        selectedIDs = featureIDs;
        for i = 1:size(sortedResult,1)
            if i > 1
                diff = length(featureIDs{1}) - length(selectedIDs{1});
                if diff == 0
                    break;
                else
                    selectedIDs = featureIDs;
                end
            end
            for j = 1:size(sortedResult,1)
                if sum(selectedIDs{1}==sortedResult(j,4)) == 1
                    continue;
                end
                dimIDs = [selectedIDs{1} sortedResult(j,4)];
                gaussianPara = fun_trainGaussian(dataML,dimIDs);
                [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
                resultCell{1,4} = dimIDs;
                
                % added by Holy 1808141552
                if resultCell{1,1} == 1
                    bestPara = [bestPara;[resultCell {minHogSize} {imgEdge}]];
                end
                % end of addition 1808141552
                
                if resultCell{1,1} > maxF1Row{1}
                    %                     maxF1Row = resultCell; % hided by Holy 1808141436
                    maxF1Row(1:4) = resultCell; % added by Holy 1808141437
                    featureIDs = maxF1Row(4);
                    
                    % added by Holy 1808141447
                    if maxF1Row{1} > bestPara{1,1}
                        bestPara = maxF1Row;
                    end
                    % end of addition 1808141447
                end
                %                     paraLog = [paraLog;maxF1Row]; % added by Holy 1811051342
            end
        end
        paraLog = [paraLog;maxF1Row]; % added by Holy 1811070842
        
    end
    % end of addition 1811071619
    
    iProgress = iProgress + 1;
end
% end of addition 1808131555

% hided by Holy 1808141449
% % added by Holy 1808060831
% dataMLFileName = 'dataML.mat';
% if exist(dataMLFileName, 'file') == 2
%     trainTag = false;
%     dataML = load(dataMLFileName);
% else
%     trainTag = true;
% end
% % end of addition 1808060831
% 
% % hided by Holy 1808060833
% % % trainTag = true;
% % trainTag = false;
% % end of hide 1808060833
% 
% % biasHRatio = 90; % video tracked target's height bias ratio % hided by Holy 1808060828
% % biasWRatio = 60; % video tracked target's width bias ratio % hided by Holy 1808060828
% 
% % hided by Holy 1808081011
% % f = fopen('log.txt', 'a');
% % fprintf(f,datestr(now));
% % fprintf(f, ' ');
% % fprintf(f, 'hogSize = %d, numDim =  %s, ',hogSize, num2str(numDim));
% % fclose(f);
% % end of hide 1808081011
% 
% if trainTag
%     % train
%     folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTrain\imgsTarget\';
%     %     folder_name = 'd:\data_seq\sequences\windingRopeTrain\imgsTarget\';
%     realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio);
%     
%     % CV
%     folder_name = 'd:\data_seq\sequences\realWindingRopesCompactCV\imgsTarget\';
%     %     folder_name = 'd:\data_seq\sequences\windingRopeCV\imgsTarget\';
%     realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio);
%     
%     % test
%     folder_name = 'd:\data_seq\sequences\realWindingRopesCompactTest\imgsTarget\';
%     %     folder_name = 'd:\data_seq\sequences\windingRopeTest\imgsTarget\';
%     realWindingFeatureDataGen(folder_name,hogSize,biasHRatio,biasWRatio);
%     
%     dataML = load(dataMLFileName);
% end
% 
% numDim = size(dataML.X,2);
% resultMatrix = zeros(numDim,4);
% for i = 1:numDim
%     gaussianPara = fun_trainGaussian(dataML,i);
%     
%     [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = fun_testGaussian(dataML,i,gaussianPara);
%     resultMatrix(i,4) = i;
% end
% sortedResult = sortrows(resultMatrix,'descend');
% 
% % remove lines with nan elements
% nanTag = isnan(sortedResult);
% nanInd = any(nanTag,2);
% sortedResult(nanInd,:) = [];
% 
% % perform feature selection
% % added by Holy 1808081051
% maxF1Row = num2cell(sortedResult(1,:));
% featureIDs = maxF1Row(4);
% resultCell = cell(1,4);
% selectedIDs = featureIDs;
% for i = 1:size(sortedResult,1)
%     if i > 1
%         diff = length(featureIDs{1}) - length(selectedIDs{1});
%         if diff == 0
%             break;
%         else
%             selectedIDs = featureIDs;
%         end
%     end
%     for j = 1:size(sortedResult,1)
%         if sum(selectedIDs{1}==sortedResult(j,4)) == 1
%             continue;
%         end
%         dimIDs = [selectedIDs{1} sortedResult(j,4)];
%         gaussianPara = fun_trainGaussian(dataML,dimIDs);
%         [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
%         resultCell{1,4} = dimIDs;
%         if resultCell{1,1} > maxF1Row{1}
%             maxF1Row = resultCell;
%             featureIDs = maxF1Row(4);
%         end
%     end
% end
% % end of addition 1808081051
% end of hide 1808141449

% hided by Holy 1808081050
% numStep = 100;
% stepsize = (sortedResult(1,1) - sortedResult(end,1)) / numStep;
% 
% resultCell = cell(numStep+1,4);
% 
% maxF1Row = num2cell(sortedResult(1,:));

% j = 1;
% for F1Value = sortedResult(end,1):stepsize:sortedResult(1,1)
%     indSort = sortedResult(:,1)>=F1Value;
%     dimIDs = sortedResult(indSort,4);
%     dimIDs = dimIDs';
%     gaussianPara = fun_trainGaussian(dataML,dimIDs);
%     [resultCell{j,1},resultCell{j,2},resultCell{j,3}] = fun_testGaussian(dataML,dimIDs,gaussianPara);
%     resultCell{j,4} = dimIDs;
%     if resultCell{j,1} > maxF1Row{1}
%         maxF1Row = resultCell(j,:);
%     end
%     j = j + 1;
% end
% end of hide 1808081050
end
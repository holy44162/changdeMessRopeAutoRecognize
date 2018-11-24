function [bestPara,paraLog,dataMLOutput] = fun_trainMLParasByGMM(maxHogSize,maxImgEdge,heightBias,widthBias,numImgEdgeStep,numHogSizeStep,trainFolderName,CVFolderName,testFolderName,featureType)

minImgEdge = 0;


if numImgEdgeStep == 0
    imgEdgeSteps = 0;
else
    stepSizeImgEdge = (maxImgEdge - minImgEdge) / numImgEdgeStep;
    imgEdgeSteps = maxImgEdge:-stepSizeImgEdge:minImgEdge;
end

minHogSize = 8;


if numHogSizeStep == 0
    hogSizeSteps = maxHogSize;
else
    % hided by Holy 1811221450
%     stepSizeHogSize = (maxHogSize - minHogSize) / numHogSizeStep;
%     hogSizeSteps = maxHogSize:-stepSizeHogSize:minHogSize;
    % end of hide 1811221450
    
    % added by Holy 1811221452
    maxNumHogSize = log2(maxHogSize)-log2(minHogSize)+1;
    if numHogSizeStep > maxNumHogSize
        numHogSizeStep = maxNumHogSize;
    end
    hogSizeSteps = 2.^(log2(minHogSize):(log2(minHogSize)+numHogSizeStep-1));
    % end of addition 1811221452
end

gaborsBinHogFeatureType = 'gaborsBinHog';

bestPara = num2cell(zeros(1,6)); % hided by Holy 1811241523
% bestPara = zeros(1,4); % added by Holy 1811241524

paraLog = [];
iProgress = 1;

for imgEdge = imgEdgeSteps
    progressbar(iProgress,numImgEdgeStep+1);
    heightImgEdge = round(heightBias + imgEdge);
    widthImgEdge = round(widthBias + imgEdge);
    
    if contains(featureType, gaborsBinHogFeatureType,'IgnoreCase',true)
        for hogSize = hogSizeSteps
            hogSize1 = round(hogSize);
            % train
            dataML = realWindingFeatureDataGen(trainFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType);
            
            % CV
            dataML = realWindingFeatureDataGen(CVFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % test
            dataML = realWindingFeatureDataGen(testFolderName,hogSize1,heightImgEdge,widthImgEdge,featureType,dataML);
            
            % added by Holy 1811221607
%             % retrieve GMM
%             options = statset('MaxIter',1000);
%             GMModel = fitgmdist(dataML.X,1,'Options',options,'CovarianceType','diagonal');
            % end of addition 1811221607
            
            % added by Holy 1811241521
%             resultPara = zeros(1,4);
%             resultPara(4) = hogSize1;
%             [resultPara(1),resultPara(2),resultPara(3)] = testGMM(dataML,GMModel);
%             if resultPara(1) > bestPara(1)
%                 bestPara = resultPara;
%                 dataMLOutput = dataML;
%                 paraLog = [paraLog;resultPara];
%             end
            % end of addition 1811241521
            % get best parameters
            numDim = size(dataML.X,2);
            resultMatrix = zeros(numDim,4);
            options = statset('MaxIter',1000);
            for i = 1:numDim
                GMModel = fitgmdist(dataML.X(:,i),1);
                [resultMatrix(i,1),resultMatrix(i,2),resultMatrix(i,3)] = testGMM(dataML,GMModel,i);
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
                    GMModel = fitgmdist(dataML.X(:,dimIDs),1,'Options',options,'CovarianceType','diagonal');
                    [resultCell{1,1},resultCell{1,2},resultCell{1,3}] = testGMM(dataML,GMModel,dimIDs);
                    resultCell{1,4} = dimIDs;
                    
                    if resultCell{1,1} == 1
                        bestPara = [bestPara;[resultCell {hogSize1} {imgEdge}]];
                    end
                                        
                    if resultCell{1,1} > maxF1Row{1}
                        maxF1Row(1:4) = resultCell;
                        featureIDs = maxF1Row(4);
                        
                        if maxF1Row{1} > bestPara{1,1}
                            bestPara = maxF1Row;
                            dataMLOutput = dataML;                            
                        end                        
                    end
                end
            end
            paraLog = [paraLog;maxF1Row];
        end
    end
    iProgress = iProgress + 1;
end
end
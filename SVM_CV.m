function [bestLog2c, bestLog2g, bestf] = SVM_CV(WholeData, WholeLabel ,SR_RG, stepSize, numF_List, NumberFolds)

% NumberFolds = 3;  
log2c_list = -SR_RG:stepSize:SR_RG;
log2g_list = -SR_RG:stepSize:SR_RG;

numLog2c = length(log2c_list);
numLog2g = length(log2g_list);
numCanF = length(numF_List); 
cvMatrix = zeros(numLog2c,numLog2g,numCanF,NumberFolds);

% Stratified 10-fold CV
C = cvpartition(WholeLabel,'k',NumberFolds);
for num = 1:NumberFolds;
    trainData_in = WholeData(training(C,num),:);
    trainLabel_in = WholeLabel(training(C,num),:);
    testData_in = WholeData(test(C,num),:);
    testLabel_in = WholeLabel(test(C,num),:);
    for i = 1:numLog2c
        log2c = log2c_list(i);
        for j = 1:numLog2g
            log2g = log2g_list(j);
            for ii = 1: numCanF
                param = ['-t 2 -q -h 0 -b 1 -w1 1 -w-1 4.74 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
                % Feature Selection
                inmodelAll = feast('jmi',numF_List(ii), trainData_in,trainLabel_in,0.8);
                trainData_in2 = trainData_in(:,inmodelAll);
                testData_in2 = testData_in(:,inmodelAll);
                % Building model 
                model_inside = svmtrain(trainLabel_in, trainData_in2, param);
                [predict_label_in, ~, P_in] = svmpredict(testLabel_in, testData_in2, model_inside, '-q'); % run the SVM model on the test data
                [Accuracy_in, TP_in, fMeasure_in, Gmean_in, AUCROC_in] = f_Measure(testLabel_in, predict_label_in, P_in);
                % cvMatrix(i,j) = fMeasure_in + Gmean_in + AUCROC_in;
                cvMatrix(i,j,ii,num) = Gmean_in;
            end
        end
    end
end
cvMatrix2 = sum(cvMatrix,4);
% Summed_cvMatrix = sum(cvMatrix,3); 
[maxA,ind] = max(cvMatrix2(:));
[index_C, index_G, index_F] = ind2sub(size(cvMatrix2),ind);
bestLog2c = log2c_list(index_C)
bestLog2g = log2g_list(index_G)
bestf = numF_List(index_F)


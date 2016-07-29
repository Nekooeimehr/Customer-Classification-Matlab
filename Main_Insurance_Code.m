clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Data Preparation %%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reading the data
pagenumber = 1;
filename = 'training.csv';
xlRange = 'A2:W8239';
[X_num, X_cell, X_all] = xlsread(filename,pagenumber, xlRange);

filename = 'testingCandidate.csv';
xlRange = 'A2:V32951';
[j1, j2, X_all_test] = xlsread(filename,pagenumber, xlRange);
XT = X_all_test(:,1:end-1);

bin_y = X_all(:,end-1);
bin_y(strcmp('no', bin_y))= {1};
bin_y(strcmp('yes', bin_y))= {-1};
bin_y = cell2mat(bin_y);
%bin_y = bin_y([1:150,end-50:end]);
X = X_all(:,1:end-2);
Big_X = [X;XT];

%% Removing unnecessary features (Highly correlated variables)
subset_out = [14,20];
Big_X(:,subset_out) = [];
% TBF = Big_X(:,12);
% TBF(strcmp({999}, TBF))= {15};
% Big_X(:,12) = TBF;

%% Imputing missing values using the mode of existing data
vars = [2,3,4,5,6,7,8,9,10];
X_imputed = impute_mode(Big_X,vars);

%% Converting Categorical features to binary Features
X_nominal = categorical2bins(X_imputed,vars);
[N D] = size(X_nominal);

%% Standardize the feature space between -1 and 1
for i = 1:D
    X_scaled(:,i) = 2*((X_nominal(:,i) - min(X_nominal(:,i))) / ( max(X_nominal(:,i)) - min(X_nominal(:,i))))-1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X_scaledTr = X_scaled(1:8238,:);
XT_scaled = X_scaled(8239:end,:);

%%%%Validation: Stratified Cross Validation to select the best set of
%%%%parameters%%%%

%% Defining the search space; due to computational limit over a very small set
numF_List = [10, 15, 20, 25];
SR_RG = 1;
stepSize = 1;
NumberFolds = 3; 

%% Finding the best set of parpameters for the model using 10-fold cross validation to avoid overfitting 
[bestLog2c, bestLog2g, bestf] = SVM_CV(X_scaledTr, bin_y ,SR_RG, stepSize, numF_List, NumberFolds);
% Input the best set of parameters for the final model.
param_SVM = ['-q -c ', num2str(2^bestLog2c), ' -g ', num2str(2^bestLog2g), ' -b 1 -t 2 -w1 1 -w-1 4.74'];
% Feature Selection using the best number of features found using CV
selectedIndices = feast('jmi',bestf, X_scaledTr, bin_y, 0.8);
X_scaled_F = X_scaledTr(:,selectedIndices);
% Train the SVM
model = svmtrain(bin_y, X_scaled_F, param_SVM);

%%%%%%%%%%%% Use the SVM model to predict the test data%%%%%%%%%%%%%%%%%%
XT_scaled = XT_scaled(:,selectedIndices);
[N D] = size(XT_scaled);

testLabel = ones(N,1); 
[predict_label, ~, P]= svmpredict(testLabel, XT_scaled, model); % run the SVM model on the test data

% Writing the results 
xlRange_column = 'W2:W32951';
xlswrite(filename, predict_label, pagenumber, xlRange_column);
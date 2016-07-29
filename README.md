# MATLAB-Data-Analysis-Sample-Project
I did this project in MATLAB for a business analytics company as work sample. The dataset contains over 8000 samples and 22 features. Your objective of this project was to determine which set of customers the marketing firm should contact to maximize profit. 

Here is a summaty of the steps that were taken to analyze the data:

Data Pre-Processing:

  Correlation Analysis: Remove the features that are highly correlated using pearson correlation. 
  
  Dataset Normalization: Transform the range of all predictors in the dataset to [-1 1].
  
  Missing Value Imputation: Replace missing values with the mode of existing examples. 
  
  Handling Categorical Data: Convert Categorical features to dummy binary Features.
  
Parameter Tuning:

The parameters of the model including the cost, gamma and the number of features were optimized over a small set of parameters to avoid overfitting. 
Tuning was performed using 10 fold cross validation on only the training set.

Building the Model:

Radial Based Support Vector Machine was used to build the model. 
Due to imbalance number of examples, the misclassification cost was set different for each class. The misclassification cost for the class of “NO” was set to 1 and for the class of “YES” was set to 4.74. 
Joint Mutual information were used for feature ranking to identify relevant and irrelevant predictors.

Predicting testing set:

The SVM model were used to predict the new customers. 
The test set was also pre-processed and cleaned before prediction. 













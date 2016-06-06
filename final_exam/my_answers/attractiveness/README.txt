The cross-validated ridge regression model from scikit-learn generated an accuracy of 0.6545.
Normalization of the data did not improve the cross-validated accuracy.

Missing data values were replaced by the training mean of their respective features for weight, 
attractive, intelligence, and trustworthy. age was non-null for every sample, but null values 
would be replaced by the median instead of the mean because the variance was much higher.

This method seems to be somewhat effective, as it was able to obtain accuracies higher than
simply replacing missing values with the same placeholder (i.e. 0 or 1). Another model such
as random forests or gradient boosting would be able to deal with these missing values and
would likely obtain much higher accuracies.

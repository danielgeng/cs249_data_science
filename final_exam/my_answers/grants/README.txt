Files:

script.py - generates `predictions.csv` with default 200 trees
    Usage: python3 script.py <number_of_trees>

predictions.csv - probabilities generated using RandomForestClassifier `predict_proba()`
	1 = successful, 0 = unsuccessful

predictions_labels.csv - corresponding labels to `predictions.csv`

predictions_regressor.csv - probabilities generated using RandomForestRegressor `predict()`

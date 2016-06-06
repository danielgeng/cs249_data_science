#!/usr/bin/python

from sklearn.linear_model import RidgeClassifier, RidgeClassifierCV
from sklearn import cross_validation
from sklearn import metrics
import numpy as np
import csv
import time

TRAIN_FILE = '../../attractiveness/attractiveness_train.csv'
TEST_FILE = '../../attractiveness/attractiveness_test.csv'
OUTPUT_FILE = '../../attractiveness/attractiveness_predictions.csv'

def process_nans(file):
    matrix = np.genfromtxt(file, delimiter=',', usecols=(1,2,3,4), skip_header=1)
    return np.nanmean(matrix, axis=0)

def get_data(train_file, test_file):
    train_feats = []
    train_labels = []
    test_feats = []
    defaults = process_nans(train_file) # weight, attractive, intelligence, trustworthy
    with open(train_file, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['weight'] == 'NA': row['weight'] = defaults[0]
            if row['attractive'] == 'NA': row['attractive'] = defaults[1]
            if row['intelligence'] == 'NA': row['intelligence'] = defaults[2]
            if row['trustworthy'] == 'NA': row['trustworthy'] = defaults[3]
            feats = [row['age'], row['weight'], row['attractive'], row['intelligence'], row['trustworthy']]
            train_feats.append(feats)
            train_labels.append(row['male'])
    train_feats = np.array(train_feats, dtype=float)
    train_labels = np.array(list(map(lambda x: 1 if x == 'TRUE' else 0, train_labels)))
    # print(train_feats.shape)
    # print(train_labels.shape)
    with open(test_file, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            if row['weight'] == 'NA': row['weight'] = defaults[0]
            if row['attractive'] == 'NA': row['attractive'] = defaults[1]
            if row['intelligence'] == 'NA': row['intelligence'] = defaults[2]
            if row['trustworthy'] == 'NA': row['trustworthy'] = defaults[3]
            feats = [row['age'], row['weight'], row['attractive'], row['intelligence'], row['trustworthy']]
            test_feats.append(feats)
    test_feats = np.array(test_feats, dtype=float)
    # print(test_feats.shape)
    return train_feats, train_labels, test_feats

def main():
    start_time = time.time()
    train_feats, train_labels, test_feats = get_data(TRAIN_FILE, TEST_FILE)

    # try RidgeClassifier with manual cross validation (k-fold)
    lr = RidgeClassifier().fit(train_feats, train_labels)
    cv_preds = cross_validation.cross_val_predict(lr, train_feats, train_labels, cv=10)
    print("cross validation accuracy:", metrics.accuracy_score(train_labels, cv_preds))

    # try automatic RidgeClassifierCV (k-fold)
    lrcv = RidgeClassifierCV(cv=10).fit(train_feats, train_labels)
    print("built in ridge cv accuracy:", lrcv.score(train_feats, train_labels))

    # use cross validated model to predict test labels
    preds = lrcv.predict(test_feats).astype(str)
    for i in range(preds.shape[0]):
        if preds[i] == '1': preds[i] = 'TRUE'
        else: preds[i] = 'FALSE'
    np.savetxt("attractiveness_predictions.csv", preds, fmt="%s", newline="\n")

    print("time taken:", time.time()-start_time, "seconds")

if __name__ == '__main__':
    main()

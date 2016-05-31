#!/usr/bin/python

from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
from sklearn.feature_selection import SelectKBest, chi2
import numpy as np
import pandas as pd
import csv
import time
import string

TRAINING_DATA = 'HW5_jobs_data/train_data.csv'
TEST_DATA = 'HW5_jobs_data/test_data.csv'

lef = LabelEncoder()
lel = LabelEncoder()

def get_data(train_file, test_file):
    features = []
    test_features = []
    labels = []
    with open(train_file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        # dr = csv.DictReader(csvfile)
        # header = dr.fieldnames
        # indices = [10, 13, 15, 76, 79, 103, 107, 128, 139, 158]
        # for i in indices:
        #     print(header[i])
        next(reader, None)
        for row in reader:
            features.append(row[1:270])
            labels.append(row[270])
    with open(test_file, 'r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader, None)
        for row in reader:
            test_features.append(row[1:270])
    npf = np.array(features)
    nptf = np.array(test_features)
    npl = np.array(labels)
    lel.fit(labels)
    npl = lel.transform(npl)
    # kbest = SelectKBest(chi2, k=10).fit(np.delete(npf, 0, 1).astype(int), npl.astype(int))
    # print(kbest.get_support(indices=True))
    lef.fit(np.append(npf[:,0], nptf[:,0]))
    npf[:, 0] = lef.transform(npf[:, 0])
    nptf[:, 0] = lef.transform(nptf[:, 0])
    print("number of employers:", lef.classes_.shape[0])
    return npf.astype(int), npl.astype(int), nptf.astype(int)

def main():
    init_time = time.time()
    start_time = time.time()
    train_features, train_labels, test_features = get_data(TRAINING_DATA, TEST_DATA)
    oh = OneHotEncoder(categorical_features=[0])
    oh.fit(train_features, test_features)
    train_features = oh.transform(train_features).toarray()
    test_features = oh.transform(test_features).toarray()
    print("data extraction/preprocessing time:", (time.time() - start_time), "seconds")

    start_time = time.time()
    rf = RandomForestClassifier(n_estimators=1200)
    rf.fit(train_features, train_labels)
    print("random forest training time:", (time.time() - start_time), "seconds")

    start_time = time.time()
    pred = rf.predict(train_features)
    wrong = np.absolute(np.subtract(pred, train_labels))
    print("training prediction time:", (time.time() - start_time), "seconds")
    print("training accuracy:", (1-np.mean(wrong))) # make sure it somewhat works

    start_time = time.time()
    pred = rf.predict(test_features)
    pred = lel.inverse_transform(np.around(pred))
    np.savetxt("test_predictions.csv", pred, fmt="%s", newline="\n")
    print("test prediction time:", (time.time() - start_time), "seconds")

    print("total time:", (time.time() - init_time), "seconds")

if __name__ == '__main__':
    main()
#!/usr/bin/python

from sklearn.ensemble import RandomForestClassifier
import pandas as pd
import numpy as np
import time
import sys

TRAINING_FILE = '../../grants/APM_training.tsv'
TEST_FILE = '../../grants/APM_testing.csv'
PREDICTION_INPUT = '../../grants/APM_prediction_input.csv'
OUTPUT_FILE = 'predictions.csv'

def generate_columns():
    print('generating columns...')
    table = pd.read_csv(TRAINING_FILE, sep=',', nrows=1)
    roles = ['CI', 'DR', 'ECI', 'PS', 'SR']
    years = ['1900', '1925', '1930', '1935', '1940', '1945', '1950', '1955', '1960', '1965', '1970', '1975', '1980', '1985']
    regions = ['AsiaPacific', 'Australia', 'EasternEurope', 'GreatBritain', 'MiddleEastandAfrica', 'NewZealand', 'SouthAfrica', 'TheAmericas', 'WesternEurope']
    cols_used = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sun', 'Sat', 'Day', 'allPub', 'numPeople',
    'Class'
    ]
    features = ['Num', 'PhD', 'Duration', 'Grant', 'ContractValueBand', 'Sponsor', 'RFCD', 'Dept', 'Faculty']
    features.extend(years)
    features.extend(regions)
    for i in features: cols_used.extend([col for col in table.columns if i in col])
    for r in roles:
        cols_used.append('Success.' + r)
        cols_used.append('Unsuccess.' + r)
        cols_used.append('Astar.' + r)
        cols_used.append('A.' + r)
        cols_used.append('B.' + r)
        cols_used.append('C.' + r)
    print('number of features used:', len(cols_used)-1)
    return cols_used

def get_data(file, cols_used):
    table = pd.read_csv(file, sep=',', usecols=cols_used)
    class_map = {'successful' : 1, 'unsuccessful' : 0}
    labels = table['Class'].map(class_map)
    features = table.drop('Class', 1)
    return np.array(features), np.array(labels)

def main(argv):
    start_time = time.time()
    cols_used = generate_columns()
    print('extracting training data...')
    train_feats, train_labels = get_data(TRAINING_FILE, cols_used)
    print('extracting test data...')
    test_feats, test_labels = get_data(TEST_FILE, cols_used)
    # print(train_feats.shape, train_labels.shape)
    # print(test_feats.shape, test_labels.shape)

    n = int(argv[1]) if len(argv) > 1 else 200
    print('training random forest with', n, 'trees...')
    rf = RandomForestClassifier(n_estimators=n)
    rf.fit(train_feats, train_labels)

    print('calculating test accuracy...')
    test_accu = rf.score(test_feats, test_labels)
    print('test accuracy:', test_accu)

    print('extracting prediction input...')
    pred_feats, _ = get_data(PREDICTION_INPUT, cols_used)

    print('generating predictions...')
    preds = rf.predict(pred_feats).astype(str)
    for i in range(preds.shape[0]):
        if preds[i] == '1': preds[i] = 'successful'
        else: preds[i] = 'unsuccessful'
    np.savetxt(OUTPUT_FILE, preds, fmt="%s", newline="\n")

    print('time taken:', time.time()-start_time, 'seconds')

if __name__ == '__main__':
    main(sys.argv[0:])

#!/usr/bin/python

from sklearn.cluster.bicluster import SpectralCoclustering
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os
import fnmatch

DATA_DIR = '../../voting/'

def get_data(file):
    table = pd.read_csv(file, sep=',', quotechar='"', nrows=1)
    cols_used = [col for col in table.columns if 'V' in col or 'var' in col]
    # cols_used.append('party')
    table = pd.read_csv(file, sep=',', quotechar='"', usecols=cols_used)
    # party = table['party']
    # table = table.drop('party', axis=1)
    return np.array(table)#, np.array(party)

def main():
    files = [DATA_DIR + file for file in os.listdir(DATA_DIR) if fnmatch.fnmatch(file, '*.csv')]

    for i in files:
        print('processing', i, '...')
        table = get_data(i)
        cl = SpectralCoclustering(n_clusters=2, random_state=0)
        cl.fit(table)

        # using http://scikit-learn.org/stable/auto_examples/bicluster/plot_spectral_coclustering.html
        fit_data = table[np.argsort(cl.row_labels_)]
        fit_data = fit_data[:, np.argsort(cl.column_labels_)]

        plt.matshow(fit_data, cmap=plt.cm.Reds)
        plt.title(i[len(DATA_DIR):])
        # plt.show()
        plt.savefig(i[len(DATA_DIR):-4] + '.pdf')

if __name__ == '__main__':
    main()

#!/usr/bin/python

import pandas as pd
import numpy as np
import scipy.stats as sp
import matplotlib.pyplot as plt
import os
import fnmatch

DATA_DIR = '../../voting/'

def get_data(file):
    table = pd.read_csv(file, sep=',', quotechar='"', nrows=1)
    cols_used = [col for col in table.columns if 'V' in col or 'var' in col]
    cols_used.append('party')
    table = pd.read_csv(file, sep=',', quotechar='"', usecols=cols_used)
    party = table['party']
    table = table.drop('party', axis=1)
    return np.array(table, dtype=float), np.array(party)

def main():
    files = [DATA_DIR + file for file in os.listdir(DATA_DIR) if fnmatch.fnmatch(file, '*.csv')]
    bad_codes = [0, 7, 8, 9]
    kt = []
    cong = list(range(102, 114))

    for i in files:
        print('processing', i, '...')
        table, party = get_data(i)
        # for j in bad_codes:
        #     table[table == j] = np.nan
        kt.append(10-np.mean(sp.kurtosis(table, fisher=True, nan_policy='omit')))

    plt.plot(cong, kt)
    plt.title('Polarization timeline (original data)')
    plt.xlabel('x-th Congress')
    plt.ylabel('10 - kurtosis')
    # plt.show()
    plt.savefig('polarization.pdf')

if __name__ == '__main__':
    main()

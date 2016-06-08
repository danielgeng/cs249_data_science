#!/usr/bin/python

import pandas as pd
import numpy as np
import scipy.stats as sp
import matplotlib.pyplot as plt
import os
import fnmatch
import time

DATA_DIR = '../../voting/'

def get_data(file):
    table = pd.read_csv(file, sep=',', quotechar='"', nrows=1)
    cols_used = [col for col in table.columns if 'V' in col or 'var' in col]
    cols_used.append('party')
    table = pd.read_csv(file, sep=',', quotechar='"', usecols=cols_used)
    dem = table.loc[table['party'] == 100]
    rep = table.loc[table['party'] == 200]
    table = table.drop('party', axis=1)
    dem = dem.drop('party', axis=1)
    rep = rep.drop('party', axis=1)
    return np.array(table, dtype=float), np.array(dem, dtype=float), np.array(rep, dtype=float)

def main():
    start_time = time.time()
    files = [DATA_DIR + file for file in os.listdir(DATA_DIR) if fnmatch.fnmatch(file, '*.csv')]
    bad_codes = [0, 7, 8, 9]
    kt = []
    cong = list(range(102, 114))

    for i in files:
        print('processing', i, '...')
        table, dem, rep = get_data(i)
        # for j in bad_codes:
        #     table[table == j] = np.nan
        #     dem[dem == j] = np.nan
        #     rep[rep == j] = np.nan
        total_pol = 10-np.mean(sp.kurtosis(table, fisher=True, nan_policy='omit'))
        dem_pol = 10-np.mean(sp.kurtosis(dem, fisher=True, nan_policy='omit'))
        rep_pol = 10-np.mean(sp.kurtosis(rep, fisher=True, nan_policy='omit'))
        print('total polarization:', total_pol)
        print('democrat only polarization:', dem_pol)
        print('republican only polarization:', rep_pol, '\n')
        kt.append(total_pol)

    plt.plot(cong, kt)
    plt.title('Polarization timeline (original data)')
    plt.xlabel('x-th Congress')
    plt.ylabel('10 - kurtosis')
    # plt.show()
    plt.savefig('polarization.pdf')
    print('time taken:', time.time()-start_time, 'seconds')

if __name__ == '__main__':
    main()

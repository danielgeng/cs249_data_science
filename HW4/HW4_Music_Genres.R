
# coding: utf-8

# # HW4 Problem:  Classifying Music Genres
# 
# This problem asks you to classify music into genres that include:  Blues, Classical, Jazz, Metal, Pop, Rock.
# 
# Column 192 in the dataset is the "GENRE" attribute used for classification.
# The 191 columns before this are numeric features of music clips.
# <blockquote>
# A database of 60 music performers has been prepared for the competition. The material is divided into six categories: classical music, jazz, blues, pop, rock and heavy metal. For each of the performers 15-20 music pieces have been collected. All music pieces are partitioned into 20 segments and parameterized. The descriptors used in parametrization also those formulated within the MPEG-7 standard, are only listed here since they have already been thoroughly reviewed and explained in many studies.  <br /><br />The feature vector consists of 191 parameters, the first 127 parameters are based on the MPEG-7 standard, the remaining ones are cepstral coefficients descriptors and time-related dedicated parameters:<br /><br />a) parameter 1: Temporal Centroid, <br />b) parameter 2: Spectral Centroid average value, <br />c) parameter 3: Spectral Centroid variance, <br />d) parameters 4-37: Audio Spectrum Envelope (ASE)  average values in 34 frequency bands<br />e) parameter 38: ASE average value (averaged for all frequency bands)<br />f) parameters 39-72: ASE variance values in 34 frequency bands<br />g) parameter 73: averaged ASE variance parameters<br />h) parameters 74,75: Audio Spectrum Centroid -- average and variance values<br />i) parameters 76,77: Audio Spectrum Spread -- average and variance values<br />j) parameters 78-101: Spectral Flatness Measure (SFM) average values for 24 frequency bands<br />k) parameter 102: SFM average value (averaged for all frequency bands)<br />l) parameters 103-126: Spectral Flatness Measure (SFM) variance values for 24 frequency bands<br />m) parameter 127: averaged SFM variance parameters<br />n) parameters 128-147: 20 first mel cepstral coefficients average values <br />o) parameters 148-167: the same as 128-147<br />p) parameters 168-191: dedicated parameters in time domain based of the analysis of the distribution of the envelope in relation to the rms value.<br />
# </blockquote>

# The results of a contest for building classifiers for this dataset are reported in:
# <blockquote>
# http://duch.mimuw.edu.pl/~mwojnars/papers/ismis-2011-contest.pdf
# </blockquote>
# This paper offers some ideas about models to consider.

# #  The Goal
# 
# In this assignment you are to generate the genre predictions you can for a set of test data:
# <ul><li>
# Given the file <tt>MusicGenres.csv</tt>, develop a classifier that is as accurate as possible.
# </li><li>
# Use your classifier to predict genre classifications for each row of data in <tt>MusicFeatures.csv</tt>.
# </li><li>
# Put your predictions in a .csv file called  <tt>HW4_predictions.csv</tt> and upload it to CCLE.
# </li></ul>
# 
# ## Step 1: download your data, using your UID
# 
# <blockquote>
# 
# Download the music data at:
# <br/>
# http://datamining.cs.ucla.edu/cs249/hw4/music/___PUT_YOUR_UID_HERE___.zip
# 
# <br/>
# <br/>
# <i>For example, if your UID is  123456789, download the file</i>
#     http://datamining.cs.ucla.edu/cs249/hw4/music/123456789.zip
#     
# </blockquote>
#     
# This zip file has two csv data files:  a training set and a test set.
# 
# ## Step 2: construct a model from <tt>training_set.csv</tt>
# 
# Using the <tt>training_set.csv</tt> data, construct a classifier.
# 
# <br/>
# <b>YOU CAN USE ANY ENVIRONMENT YOU LIKE TO BUILD A CLASSIFIER.</b>
# Please construct the most accurate models you can.
# 
# <hr style="border-width:20px;">
# 
# ## Step 3: generate predictions from <tt>test_set.csv</tt>
#     
# The rows of file <tt>test_set.csv</tt> have input features for a number of music clips.
# Using your classifer, produce class predictions for each of them.
# 
# <br/>
# Put one predicted class name per line in a CSV file <tt>HW4_Music_Predictions.csv</tt>.
# This file should also have the header line "<tt>GENRE</tt>".
# 
# <br/>
# <i>Your score on this problem will be the accuracy of these predictions.</i>
# <br/>
# 
# <hr style="border-width:20px;">
# 
# ## Step 4: upload <tt>HW4_Music_Predictions.csv</tt> and your notebook to CCLE
# 
# Finally, go to CCLE and upload:
# <ul><li>
# your output CSV file <tt>HW4_Music_Predictions.csv</tt>
# </li><li>
# your notebook file <tt>HW4_Music_Genres.ipynb</tt>
# </li></ul>
# 
# We are not planning to run any of the uploaded notebooks.
# However, your notebook should have the commands you used in developing your models ---
# in order to show your work.
# As announced, all assignment grading in this course will be automated,
# and the notebook is needed in order to check results of the grading program.

# In[ ]:




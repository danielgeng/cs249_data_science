
# coding: utf-8

# # HW4: Baseball Modeling
# 
# For this problem please install the <i>Lahman</i> package, a comprehensive package about Baseball statistics,
# and use it to answer a few questions.
# 
# Important information:
# <ul><li>
# project home page (with links to impressive graphics):  http://lahman.r-forge.r-project.org/
# </li><li>
# package documentation (html):  http://lahman.r-forge.r-project.org/doc/
# </li></ul>
# 
# The documentation includes descriptions of the many tables in this package, such as the
# Salaries table: http://lahman.r-forge.r-project.org/doc/Salaries.html
# 

# #  The Goal
# 
# There are two problems for you to solve:
# <ul><li>
# Problem 1: construct a model that predicts a player's salary based on his baseball statistics.
# Your model should have better performance (higher R-squared) than the baseline model given.
# </li><li>
# Problem 2: construct a model that predicts whether a player will be inducted into the Hall of Fame.
# Your model should have better performance (higher Hall-of-Fame-Accuracy-Rate) than the baseline model given.
# </li></ul>
# Here, <i>Hall-of-Fame-Accuracy-Rate</i> is a weighted percentage of correct predictions
# for players in the Hall of Fame:  <u>correct prediction for players in the Hall of Fame
# is worth 100 times more than for players who are not in the Hall of Fame.</u>
# 
# Then, as in HW3, upload a .csv file containing your models to CCLE.
# 
# 
# ## Step 1: build the models
# 
# Using the 'RelevantInformation' table, one model should predict a player's maximum salary,
# the other should predict whether or not they will get into the Hall of Fame.
# 
# <b>YOU CAN USE ANY MODEL YOU LIKE.</b>
# The baseline models are a linear regression model and a logistic regression model ----------
# but you can choose <i>any</i> model.
# Please produce the most accurate models you can --
# more accurate models will get a higher score.
# 
# <hr style="border-width:20px;">
# 
# ## Step 2: generate a CSV file "HW4_Baseball_Models.csv" including your 2 models
# 
# If these were your two models, then to complete the assignment you would create
# a CSV file <tt>HW4_Baseball_Models.csv</tt> containing two lines:
# 
# <code>
#       0.8999,"lm( log10(max_salary) ~ AB+R+H+X2B+X3B+HR+RBI+SB, data = RelevantInformation)"
#       0.7888,"glm( HallOfFame ~ AB+R+H+X2B+X3B+HR+SlugPct, data = RelevantInformation, family=binomial)"
# </code>
# 
# <b>Each line gives the accuracy of a model</b>,
# as well as <b>the exact command you used to generate the model</b>.
# There is no length restriction on the lines.
# 
# <hr style="border-width:20px;">
# 
# ## Step 3: upload your CSV file and notebook to CCLE
# 
# Finally, go to CCLE and upload:
# <ul><li>
# your output CSV file <tt>HW4_Baseball_Models.csv</tt>
# </li><li>
# your notebook file <tt>HW4_Baseball_Modeling.ipynb</tt>
# </li></ul>
# 
# We are not planning to run any of the uploaded notebooks.
# However, your notebook should have the commands you used in developing your models ---
# in order to show your work.
# As announced, all assignment grading in this course will be automated,
# and the notebook is needed in order to check results of the grading program.

# # Get the Lahman package for R -- a database of Baseball Statistics

# <hr style="border-width:20px;">
# 
# ### The safe way to install it, so it will work with Jupyter -- execute the command:
# 
# <pre>
#          sudo conda install -c https://conda.anaconda.org/asmeurer r-lahman
# </pre>
# ### (The 'sudo' is not necessary if your conda installation is not write-protected.)

# <hr style="border-width:20px;">
# 
# ### Another way to install the Lahman package (if this works from within your Jupyter session):

# In[403]:

if (!(is.element("Lahman", installed.packages()))) install.packages("Lahman", repos="http://cran.us.r-project.org")


# ### Load the Lahman baseball data

# In[404]:

library(Lahman)


# <hr style="border-width:20px;">
# 
# ### Another way to get the data, if you cannot load the Lahman package:
# 
# The files
# <tt>PlayersAndStats.csv</tt>
# and
# <tt>PlayersAndStatsAndSalary.csv</tt>
# are distributed with the homework assignment, and are used in the notebook below.
# 
# You can use these fiels rather than recompute the tables using the Lahman package.

# # Extract Tables of Relevant Information for your Models

# ### Player information -- from the Master table
# http://lahman.r-forge.r-project.org/doc/Master.html

# In[405]:

SelectedColumns = c("playerID","nameFirst","nameLast","birthYear", "weight","height","bats","throws")
Players = na.omit( Master[, SelectedColumns] )
summary(Players)


# ### Player Maximum Salary -- from the Salaries table
# http://lahman.r-forge.r-project.org/doc/Salaries.html

# In[406]:

summary(Salaries)

# example(Salaries)  # see demos of results from the Salaries table

PlayerMaxSalary = aggregate( salary ~ playerID, Salaries, max )
colnames(PlayerMaxSalary) = gsub( "salary", "max_salary", colnames(PlayerMaxSalary) )

head(PlayerMaxSalary)


# In[407]:

PlayerStartYear = aggregate( yearID ~ playerID, Salaries, min )
colnames(PlayerStartYear) = gsub( "yearID", "startYear", colnames(PlayerStartYear) )

PlayerEndYear = aggregate( yearID ~ playerID, Salaries, max )
colnames(PlayerEndYear) = gsub( "yearID", "endYear", colnames(PlayerEndYear) )

head(PlayerStartYear)


# ### Batting Statistics -- from the BattingStats table
# http://lahman.r-forge.r-project.org/doc/battingStats.html
#    
# (See also the Batting table:
# http://lahman.r-forge.r-project.org/doc/Batting.html )
# 
# A glossary for Baseball Statistics Acronyms is in
#    http://en.wikipedia.org/wiki/Baseball_statistics

# In[408]:

BattingStats = battingStats()


# ### Aggregate Batting Stats -- cumulative, over a player's career

# In[409]:

TotalBattingCounts = aggregate( cbind(AB,R,H,X2B,X3B,HR,RBI,SB,CS,BB,BA,PA,TB) ~ playerID,
                                     BattingStats, sum)
nrow(TotalBattingCounts)
MaxBattingPcts = aggregate( cbind(SlugPct,OBP,OPS,BABIP) ~ playerID,
                                 BattingStats, max )
nrow(MaxBattingPcts)

AggregateBattingStats = merge(TotalBattingCounts,MaxBattingPcts, by="playerID")
summary(AggregateBattingStats)
nrow(AggregateBattingStats)


# ### Inducted into the Hall of Fame?  -- from the HallOfFame table
# http://lahman.r-forge.r-project.org/doc/HallOfFame.html

# In[410]:

data(HallOfFame)
head(HallOfFame)

InductedIntoHallOfFame = subset(HallOfFame, inducted == 'Y')[ , 1:2]

head(InductedIntoHallOfFame)
nrow(InductedIntoHallOfFame)


# ### Include HallOfFame information in the Players table

# In[411]:

PlayersWithHallOfFame = transform( merge( Players, InductedIntoHallOfFame, all.x=TRUE, by="playerID"),
                                        HallOfFame = ifelse( is.na(yearID), 0, 1 ),
                                        yearID = ifelse( is.na(yearID), 0, yearID )
                                        )
colnames(PlayersWithHallOfFame) = gsub( "yearID", "HallOfFameYear", colnames(PlayersWithHallOfFame) )
head(PlayersWithHallOfFame, 20)


# In[412]:

nrow(PlayersWithHallOfFame)
nrow(subset(PlayersWithHallOfFame, HallOfFame == 1))


# In[413]:

PlayersAndStats = merge( PlayersWithHallOfFame, AggregateBattingStats )

nrow(PlayersAndStats)
nrow(subset(PlayersAndStats, HallOfFame == 1))

# write.csv(PlayersAndStats, file="PlayersAndStats.csv", quote=FALSE, row.names=FALSE)


# # Join Information for your Baseball Salary model into one Table

# ### Merge Aggregate Batting Statistics and Maximum Salary into the Relevant Information table

# In[414]:

PlayersAndStatsAndSalary = transform(
    merge( merge( merge( PlayersAndStats, PlayerMaxSalary ), PlayerStartYear), PlayerEndYear ),
    totalYears = endYear - startYear + 1
    )
head(PlayersAndStatsAndSalary)
nrow(PlayersAndStatsAndSalary)

# write.csv(PlayersAndStatsAndSalary, file="PlayersAndStatsAndSalary.csv", quote=FALSE, row.names=FALSE)


# # Problem 1: construct a model with better performance  (higher R-squared) than this Baseline Salary Model

# ### For this salary model, consider only those players who started playing after 2000:

# In[415]:

RecentPlayersAndStatsAndSalary = subset( PlayersAndStatsAndSalary, startYear >= 2000 )
nrow(RecentPlayersAndStatsAndSalary)


# In[416]:

summary(PlayersAndStatsAndSalary)


# In[417]:

BaselineSalaryModel = lm( log10(max_salary) ~
                         AB+R+H+X2B+X3B+HR+RBI+SB+CS+BB+BA+PA+SlugPct+OBP+BABIP + startYear + totalYears,
                         data = PlayersAndStatsAndSalary)
summary(BaselineSalaryModel)


# In[418]:

#  Create your model here ...


# # Problem 2: construct a model with better performance  (higher accuracy) than this Baseline Hall of Fame Model

# ###  Hall of Fame election rules:
# 
# 
# A. A baseball player must have been active as a player in the Major Leagues at some time during a period beginning fifteen (15) years before and ending five (5) years prior to election.
# 
# B. Player must have played in each of ten (10) Major League championship seasons, some part of which must have been within the period described in 3(A).
# 
# C. Player shall have ceased to be an active player in the Major Leagues at least five (5) calendar years preceding the election but may be otherwise connected with baseball.
# 
# ### Consequently:   only consider players born before 1970
# (They must start around 20 years of age, play at least 10 years, have stopped playing at least 5 years earlier, and take perhaps 10 years to win the ballot -- so born at least 45 years ago.)

# In[419]:

HallOfFameContenders = subset( PlayersAndStats, birthYear < 1970 )
head(HallOfFameContenders)
nrow(HallOfFameContenders)


# In[420]:

BaselineHallOfFameModel = glm( HallOfFame ~ AB+R+H+X2B+X3B+HR+RBI+SB+CS+BB+BA+PA+SlugPct+OBP+BABIP,
                         data = HallOfFameContenders, family=binomial)

summary(BaselineHallOfFameModel)


# In[421]:

confusionMatrix = table( round(predict(BaselineHallOfFameModel, type="response")), HallOfFameContenders$HallOfFame )
confusionMatrix
# terrible prediction accuracy:  only 34 Hall-of-Fame players were identified correctly:


# ##  Warning!  This dataset is severely imbalanced.  Read Ch.16 of [APM]
# 
# Only about 1% or 2% of all players are inducted into the Hall of Fame:

# In[422]:

( FameTally = table( HallOfFameContenders$HallOfFame ) )


# In[423]:

data.frame( percentageOfHallOfFamers = FameTally[2] / sum(FameTally) )


# ##  The measure of accuracy will heavily emphasize correct prediction of Hall-of-Fame players
# 
# (i.e., the measurement of accuracy will focus on correct prediction of Hall-of-Fame players)
# 
# Even though classifying everybody as a NON-Hall-of-Fame player is right
# for about 98% of the players, predictions for Hall-of-Fame players will be weighted heavily in this assignment.
# Ignoring these players will get a very low score on this assignment.
# 
# Specifically, your model will be evaluated by its <b>Hall-of-Fame-Accuracy-Rate</b>:
# <blockquote>
# This rate is a weighted percentage of correct predictions
# for players in the Hall of Fame:  <u>correct prediction for players in the Hall of Fame
# is worth 100 times more than for players who are not in the Hall of Fame.</u>
# </blockquote>
# 

# In[424]:

#  Create your model here ...


# In[ ]:




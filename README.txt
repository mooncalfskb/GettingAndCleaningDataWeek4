==================================================================
Analysis and Tidying of Human Activity Recognition

By Sherrod Blankner
For Coursera Getting and Cleaning Data Week 4
https://github.com/mooncalfskb/GettingAndCleaningDataWeek4

==================================================================
Based on the following dataset
==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================


The file run_analysis.R in this repo performs the cleaning and 
tidying of the data from a separate data set called UCI_HAR_Dataset,
(see attribution above). I did not include the data in this repo 
because it was so large, but you can download it here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and get more information about it here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

My analysis does the following:
Step 1. Combines the training and test subjects (30 people) 
and the activities (six named activities) into a dataframe of
10299 rows with an id column.
#length of test data = 2947
# length of training data = 7352
# length of total data = 10299

Step 2: Takes the data measured by 561 feature measures and splits 
it into 561 columns, each named for the measurement it took. 
This dataframe is 561 x 10299, with an additional column for id.

Step 3: Separates out only the columns with mean() and std() 
in the data measurement.

Step 4. Combines the subject and data dataframes to build the
"abridged_df" which populates wk4_MeanStdDataSet.csv.
This csv is all the mean and std dev measurements for all 
the subjects.

Step 5. Uses tapply to get the average for every measurement
by subject and activity. Writes them to wk4_AveragesDataSet.csv.

The extra file: extra_list.R, makes a list of all the 128
column data, but was not needed for this assignment.


library(dplyr)
library(plyr)



#explanation of dataset
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# data directory
#/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset

# Assignment: Create one data set that:
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# set directories for data 
uci_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/"
test_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/test/"
train_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/train/"

# function to read in similar two column text files
readTwoColText <- function(fileName){
  rawData <- readLines(paste0(uci_dir, fileName))
  rawData <- simplify2array(strsplit(rawData, split=" "))
  df <- data_frame(id=as.numeric(rawData[1,]),description<-rawData[2,])
  return(df)
}

# explore data
# read in activities and features
activities <- readTwoColText("activity_labels.txt")
head(activities)
features <- readTwoColText("features.txt")
head(features)

readOneColText <- function(fileName, dir){
  rawData <- readLines(paste0(dir, fileName))
  df <- data_frame(id=1:length(rawData),data=as.character(rawData))
  return(df)  
  
}

#tried something fancier but it didn't work.
# testFiles <- c("subject_test.txt", "X_test.txt", "y_test.txt")
# testVars <- c("testSubjects", "testX", "testY")

testSubjects <- readOneColText("subject_test.txt", test_dir)
str(testSubjects)
testX <- readOneColText("X_test.txt", test_dir)
str(testX)
testY <- readOneColText("y_test.txt", test_dir)
str(testY)


trainSubjects <- readOneColText("subject_train.txt", train_dir)
str(trainSubjects)
trainX <- readOneColText("X_train.txt", train_dir)
str(trainX)
trainY <- readOneColText("y_train.txt", train_dir)
str(trainY)

#use this to clear the global environment when R slows down
#rm(list = ls())

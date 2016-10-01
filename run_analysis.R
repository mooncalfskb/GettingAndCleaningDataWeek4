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

# function to read in basics and number them with ids.
readOneColText <- function(fileName, dir, start_id){
  rawData <- readLines(paste0(dir, fileName))
  end_id <- start_id + as.numeric(length(rawData)) - 1
  df <- data_frame(id=start_id:end_id,data=as.character(rawData))
  return(df)  
}

#tried something fancier but it didn't work.
# testFiles <- c("subject_test.txt", "X_test.txt", "y_test.txt")
# testVars <- c("testSubjects", "testX", "testY")

testSubjects <- readOneColText("subject_test.txt", test_dir, 1)
str(testSubjects)
testX <- readOneColText("X_test.txt", test_dir, 1)
str(testX)
testY <- readOneColText("y_test.txt", test_dir, 1)
str(testY)

# start id's of next group at 1 + length of last group
new_start_id <- as.numeric(length(testSubjects$data)) + 1
trainSubjects <- readOneColText("subject_train.txt", train_dir, new_start_id)
str(trainSubjects)
trainX <- readOneColText("X_train.txt", train_dir, new_start_id)
str(trainX)
trainY <- readOneColText("y_train.txt", train_dir, new_start_id)
str(trainY)

testdf <- data_frame()

parseData <- function(fileName, dir, testdf){
  rawData <- readLines(paste0(dir, fileName, ".txt"))
  rawData <- simplify2array(strsplit(rawData, split="  "))
  print(head(rawData))
  testdf[,fileName] <- rawData
}

test_data_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/test/Inertial\ Signals/"
train_data_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/train/Inertial\ Signals/"

test_data_files <- list.files(test_data_dir)
test_data_files <- simplify2array(strsplit(test_data_files, split=".txt"))


sapply(test_data_files, FUN=parseData, dir=test_data_dir)


#use this to clear the global environment when R slows down
#rm(list = ls())

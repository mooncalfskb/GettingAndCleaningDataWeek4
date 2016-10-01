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

# functions for reading and parsing data
readDataFile <- function(fileName, dir){
  rawData <- readLines(paste0(dir, fileName, ".txt"))
  return(rawData)
}

trimDataTo128 <- function(data_str){
  data_str <- gsub("  ", " ", data_str)
  data_str <- trimws(data_str)
  data_str <- as.double(simplify2array(strsplit(data_str, split=" ")))
  return(data_str)
}

#########################################
#########################################
#########################################
#########################################
# Test Data

test_data_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/test/Inertial\ Signals/"

test_data_files <- list.files(test_data_dir)
test_data_files <- simplify2array(strsplit(test_data_files, split=".txt"))

#debug
# test_data_files <- c("body_acc_x_test", "body_acc_y_test")
#test_data_list <- list("body_acc_x_test"=double())

#I tried a lot of lapply and sapply things to make this list but in the end did a for loop because it could be controlled.
#need to understand lapply better, but had to move on.
test_data_list <- list("body_acc_x_test"=double(), "body_acc_y_test"=double(), "body_acc_z_test"=double(), "body_gyro_x_test"=double(), "body_gyro_y_test"=double(), "body_gyro_z_test"=double(),"total_acc_x_test"=double(), "total_acc_y_test"=double(), "total_acc_z_test"=double())

for(i in 1:length(test_data_files)) {
  #tried to make this dynamicly generated matrix, but caused issues so hard coded it
  myMatrix <- matrix(nrow=2947, ncol=128)
  fileName <- test_data_files[i]
  rd <- readDataFile(fileName,test_data_dir)
  lrd <- length(rd)
  print(paste("the length of rd = ",lrd))
  
  for(j in 1:lrd) {
   
    rdd <- trimDataTo128(rd[j])
    lrdd <- length(rdd)
    print(head(rdd)) 

    for(k in 1:lrdd) {
      myMatrix[eval(j),eval(k)] <- rdd[k] 
    }  
      
   }

  #I tried every kind of eval to get this to work, but couldn't pull it off
  #eval(paste0("test_data_list$",fileName,"<-",myMatrix))
  # ran out of time so wrote this silly thing:
  
  if(fileName == "body_acc_x_test"){test_data_list$body_acc_x_test <- myMatrix}
  if(fileName == "body_acc_y_test"){test_data_list$body_acc_y_test <- myMatrix}
  if(fileName == "body_acc_z_test"){test_data_list$body_acc_z_test <- myMatrix}
  if(fileName == "body_gyro_x_test"){test_data_list$body_gyro_x_test <- myMatrix}
  if(fileName == "body_gyro_y_test"){test_data_list$body_gyro_y_test <- myMatrix}
  if(fileName == "body_gyro_z_test"){test_data_list$body_gyro_z_test <- myMatrix}
  if(fileName == "total_acc_x_test"){test_data_list$total_acc_x_test <- myMatrix}
  if(fileName == "total_acc_y_test"){test_data_list$total_acc_y_test <- myMatrix}
  if(fileName == "total_acc_z_test"){test_data_list$total_acc_z_test <- myMatrix}
  test_data_list$id <-1:lrd

}

#########################################
#########################################
#########################################
#########################################
# Training Data
train_data_dir <- "/Users/mooncalf/Dropbox/skb/coursera/UCI_HAR_Dataset/train/Inertial\ Signals/"


train_data_files <- list.files(train_data_dir)
train_data_files <- simplify2array(strsplit(train_data_files, split=".txt"))

#to debug use short list
#train_data_files <- c("body_acc_x_train", "body_acc_y_train")
#train_data_list <- list("body_acc_x_train"=double())

#I tried a lot of lapply and sapply things to make this list but in the end did a for loop because it could be controlled.
#need to understand lapply better, but had to move on.
train_data_list <- list("body_acc_x_train"=double(), "body_acc_y_train"=double(), "body_acc_z_train"=double(), "body_gyro_x_train"=double(), "body_gyro_y_train"=double(), "body_gyro_z_train"=double(),"total_acc_x_train"=double(), "total_acc_y_train"=double(), "total_acc_z_train"=double())

# know this is totally against the principles of dry coding to repeat this 
# tried making into function, but alas, did not work.

for(i in 1:length(train_data_files)) {
  #tried to make this dynamicly generated matrix, but caused issues so hard coded it
  myMatrix <- matrix(nrow=7352, ncol=128)
  fileName <- train_data_files[i]
  rd <- readDataFile(fileName,train_data_dir)
  lrd <- length(rd)
  print(paste("the length of rd = ",lrd))
  
  for(j in 1:lrd) {
    
    rdd <- trimDataTo128(rd[j])
    lrdd <- length(rdd)
    print(head(rdd)) 
    
    for(k in 1:lrdd) {
      myMatrix[eval(j),eval(k)] <- rdd[k] 
    }  
    
  }
  
  #I tried every kind of eval to get this to work, but couldn't pull it off
  #eval(paste0("train_data_list$",fileName,"<-",myMatrix))
  # ran out of time so wrote this silly thing:
  
  if(fileName == "body_acc_x_train"){train_data_list$body_acc_x_train <- myMatrix}
  if(fileName == "body_acc_y_train"){train_data_list$body_acc_y_train <- myMatrix}
  if(fileName == "body_acc_z_train"){train_data_list$body_acc_z_train <- myMatrix}
  if(fileName == "body_gyro_x_train"){train_data_list$body_gyro_x_train <- myMatrix}
  if(fileName == "body_gyro_y_train"){train_data_list$body_gyro_y_train <- myMatrix}
  if(fileName == "body_gyro_z_train"){train_data_list$body_gyro_z_train <- myMatrix}
  if(fileName == "total_acc_x_train"){train_data_list$total_acc_x_train <- myMatrix}
  if(fileName == "total_acc_y_train"){train_data_list$total_acc_y_train <- myMatrix}
  if(fileName == "total_acc_z_train"){train_data_list$total_acc_z_train <- myMatrix}
  end_line <- 2948 + lrd - 1
  train_data_list$id <-2948:end_line
  
}



#use this to clear the global environment when R slows down
#rm(list = ls())

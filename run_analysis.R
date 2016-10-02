library(dplyr)
library(plyr)

# length of test = 2947
# length of train = 7352
# total = 10299


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

##################################
# Begin Activities and Features
##################################
# function to read in similar two column text files, activities and features
readTwoColText <- function(fileName){
  rawData <- readLines(paste0(uci_dir, fileName))
  rawData <- simplify2array(strsplit(rawData, split=" "))
  df <- data_frame(id=as.numeric(rawData[1,]),description=rawData[2,])
  return(df)
}

# explore data
# read in activities and features
activities <- readTwoColText("activity_labels.txt")
head(activities)
features <- readTwoColText("features.txt")
head(features)
# set featuresLength variable to be used in data matrix later
featuresLength <- length(features$description)


##################################
# End Activities and Features
##################################


##################################
# Begin Subjects and Activity Numbers
##################################
# function to read in basics and number them with ids.
# decided to always do "test" first and "train" second, and number them.
# start_id is 1 for test and testLength + 1 for train
readOneColText <- function(fileName, dir, start_id){
  rawData <- readLines(paste0(dir, fileName))
  end_id <- start_id + as.numeric(length(rawData)) - 1
  df <- data_frame(id=start_id:end_id,data=as.character(rawData))
  return(df)  
}

testSubjects <- readOneColText("subject_test.txt", test_dir, 1)
str(testSubjects)
testY <- readOneColText("y_test.txt", test_dir, 1)
str(testY)
testLength <- length(testSubjects$data)

# start id's of next group at 1 + length of last group
new_start_id <- testLength + 1
trainSubjects <- readOneColText("subject_train.txt", train_dir, new_start_id)
str(trainSubjects)

trainY <- readOneColText("y_train.txt", train_dir, new_start_id)
str(trainY)
trainLength <- length(trainSubjects$data)
#this variable used later
totalLength <- testLength + trainLength


#########################
# combine subjects and activities
#########################

#remember strings as factors = false!
subject_df <- data.frame(id=integer(),subject=integer(),subjectType=character(),activityID=integer(),activityName=character(), stringsAsFactors = FALSE)

# loop through test data and activities and assign to dataframe along with an id
for (i in 1:testLength){
  subject_df[i, "id"] <- testSubjects$id[i] 
  subject_df[i, "subject"] <- testSubjects$data[i] 
  subject_df[i, "activityID"] <- testY$data[i]
  #get this activity id from testY
  thisActivityID <- testY$data[i]
  thisActivity <- dplyr::filter(activities,id==thisActivityID)
  subject_df[i, "activityName"] <- thisActivity$description
  subject_df[i, "subjectType"] <- "test"
  
}

# loop through train data and activities and assign to dataframe along with an id
start_id <- testLength + 1
for (i in 1:trainLength){
  
  subject_df[start_id, "id"] <- trainSubjects$id[i] 
  subject_df[start_id, "subject"] <- trainSubjects$data[i] 
  subject_df[start_id, "activityID"] <- trainY$data[i]
  #get this activity id from trainY
  thisActivityID <- trainY$data[i]
  #print(paste("this activity id for ",i,"=",thisActivityID))
  thisActivity <- dplyr::filter(activities,id==thisActivityID)
  #print(head(thisActivity))
  subject_df[start_id, "activityName"] <- thisActivity$description
  #increment up the start id
  subject_df[i, "subjectType"] <- "train"
  start_id <- start_id + 1
}



##################################
# End Subjects and Activity Numbers
##################################

##################################
# Begin parsing functions for data
##################################

# functions for reading and parsing data
readDataFile <- function(fileName, dir){
  rawData <- readLines(paste0(dir, fileName, ".txt"))
  return(rawData)
}

splitLine <- function(data_str){
  data_str <- gsub("  ", " ", data_str)
  data_str <- trimws(data_str)
  data_str <- as.double(simplify2array(strsplit(data_str, split=" ")))
  return(data_str)
}

##################################
# End parsing functions for data
##################################


#########################################
#Begin Test Data
#########################################

# Note: I made several attempts to use lapply and sapply to do this but I was getting strange results.
# I got close, but finally gave up because ran out of time.
# this loop solution is probably because I am a web programmer.
# also realized belatedly could have done one loop by combining the read lines. for another day.

# declare a big matrix to hold all data totalLength x 561
dataMatrix <- matrix(nrow=totalLength, ncol=featuresLength)
fileName <- "X_test"
rd <- readDataFile(fileName,test_dir)
j <- 1
  
# loop through test data, split and assign to matrix
#for(j in 1:testLength) {
for(j in 1:testLength) {
    
  rdd <- splitLine(rd[j])
  lrdd <- length(rdd)
  print(head(rdd)) 
  
  for(k in 1:lrdd) {
    dataMatrix[eval(j),eval(k)] <- rdd[k] 
  }  
  
}

# loop through training data, split and assign to matrix
# ran into issues. Did not record above 9802 > total_df$`tGravityAcc-iqr()-Z`[9802]
fileName <- "X_train"
rd <- readDataFile(fileName,train_dir)
#for(m in 1:lrd {

m <- 1
#for(j in 1:trainLength) {
#for(m in 1:2) {
#train length = 7352
for(m in 1:trainLength) {
    
  rdd <- splitLine(rd[m])
  lrdd <- length(rdd)
  print(head(rdd)) 

  #which row to start on. start at the end of the test data
  start_id <- m+testLength
  #end_id <- testLength + trainLength - 1
  
  for(n in 1:lrdd) {
    dataMatrix[start_id,eval(n)] <- rdd[n] 
    #increment up 1
  }  
  #whoops this goes here
  start_id <- start_id + 1
}

#convert matrix to dataframe
data_df <- as.data.frame(dataMatrix)
colnames(data_df)
#rename columns like features names
for (i in 1:ncol(data_df)){
  oldColName <- paste0("V",i)
  featureColName <- features$description[i]
  #this worked but dyplr rename did not. very irritating
  names(data_df)[names(data_df) == oldColName] <- featureColName
}

## add an ID to data_df
data_df <- mutate(data_df, id = 1:nrow(data_df))

## join two dataframes at id
total_df <- dplyr::arrange(plyr::join(subject_df, data_df), id)

#########################################
#End Test Data
#########################################







#########################################
#########################################
#########################################
#########################################
# Test Extra Data

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
  myMatrix <- matrix(nrow=testLength, ncol=128)
  fileName <- test_data_files[i]
  rd <- readDataFile(fileName,test_data_dir)
  lrd <- length(rd)
  print(paste("the length of rd = ",lrd))
  
  for(j in 1:lrd) {
   
    rdd <- splitLine(rd[j])
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
# tried making into function, but alas, did not work. ran out of time

for(i in 1:length(train_data_files)) {
  #tried to make this dynamicly generated matrix, but caused issues so hard coded it
  myMatrix <- matrix(nrow=trainLength, ncol=128)
  fileName <- train_data_files[i]
  rd <- readDataFile(fileName,train_data_dir)
  lrd <- length(rd)
  print(paste("the length of rd = ",lrd))
  
  for(j in 1:lrd) {
    
    rdd <- splitLine(rd[j])
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
  start_line <- testLength + 1
  end_line <- testLength + trainLength
  train_data_list$id <-start_line:end_line
  
}



#use this to clear the global environment when R slows down
#rm(list = ls())

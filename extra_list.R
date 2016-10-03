

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


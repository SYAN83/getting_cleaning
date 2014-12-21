##  1.Merges the training and the test sets to create one data set.
##  2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##  3.Uses descriptive activity names to name the activities in the data set
##  4.Appropriately labels the data set with descriptive variable names. 
##  5.From the data set in step 4, creates a second, independent tidy data set with the average of 
##    each variable for each activity and each subject.

require("data.table")
require("reshape2")
##  set wording directory to the folder directory
##setwd("./UCI HAR Dataset")

##  load labels and features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

##  extract the features containing mean and std
feature_extracts <- grep("mean|std",features)

##  test data processing
##    load and name the measurements on the mean and standard deviation from X_test.txt
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[,feature_extracts]
names(X_test) <- features[feature_extracts]
##    load and label the activities from y_test.txt
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_test[,2] <- activity_labels[y_test[,1]]
names(y_test) <- c("activityID", "activityLabel")
##  load the subject_test from subject_test.txt
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test) <- "subject"
##  combine subject_test, y_test and X_test
data_test <- cbind(subject_test,y_test,X_test)

##  training data processing
##    load and name the measurements on the mean and standard deviation from X_train.txt
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[,feature_extracts]
names(X_train) <- features[feature_extracts]
##    load and label the activities from y_train.txt
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_train[,2] <- activity_labels[y_train[,1]]
names(y_train) <- c("activityID", "activityLabel")
##  load the subject_train from subject_train.txt
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train) <- "subject"
##  combine subject_train, y_train and X_train
data_train <- cbind(subject_train,y_train,X_train)

##  merge test data and training data
data <- rbind(data_test, data_train)

##  tidy data set with the average of each variable for each activity and each subject
id_labels = c("subject", "activityID", "activityLabel")
data_labels <- setdiff(colnames(data), id_labels)
melt_data <- melt(data, id = id_labels, measure.vars = data_labels)

##  Apply mean function to dataset using dcast function
tiny_data <- dcast(melt_data, subject + activityLabel ~ variable, mean)

##  output to tiny_data.txt
write.table(tiny_data,file = "./tiny_data.txt",row.name=FALSE)

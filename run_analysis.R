library(data.table)
## 1.Read all the files in data table format
subject_train <- fread("Dataset/train/subject_train.txt")
X_train <- fread("Dataset/train/X_train.txt")
y_train <- fread("Dataset/train/y_train.txt")
subject_test <- fread("Dataset/test/subject_test.txt")
X_test <- fread("Dataset/test/X_test.txt")
y_test <- fread("Dataset/test/y_test.txt")

## 2.Merge the train and test data set by first concatenate the 
## rows by subject, activity and experiment then merge the 3
## column together
subject <- rbind(subject_train,subject_test)
activity <- rbind(y_train, y_test)
experiment <- rbind(X_train, X_test)
setnames(subject,"V1", "subject")
setnames(activity, "V1","activitylabel")
experiment <- cbind(experiment,subject,activity)

## Extract only mean and strandard deviation
### Read the features.txt file to find out the columns record
### means and sd
features <- fread("Dataset/features.txt")
### Find the subset of feature lable with mean and sd
features <- features[grepl("mean\\(\\)|std\\(\\)", features$V2)]
features$match <- features[,paste0("V", features$V1)]
### Extract corresponding columns in experiment
sub_experiment <- experiment[, c("subject","activitylabel", features$match),with=FALSE]

## 3.Use descriptive activity names
### Read activity_labels.txt
activity_names <- fread("Dataset/activity_labels.txt")
### Merge the activity names to the sub_experiment dataset
sub_experiment <- merge(sub_experiment, activity_names, by.x = "activitylabel", by.y = "V1", all=TRUE)
setnames(sub_experiment, "V2.y", "activity_names")

## 4.Label the data set with descriptive variable names
### Reshape the dataset to long and narrow format
fixed <- c("subject","activitylabel","activity_names")
sub_experiment <- data.table(melt(sub_experiment,fixed,variable.name = "feature_label"))
### merge with the features table 
sub_experiment <- merge(sub_experiment, features, by.x = "feature_label", by.y = "match", all = TRUE)
setnames(sub_experiment, c("V1","V2"), c("feature_num","features"))

## 5.Creat a tidy dataset with the average of each variable for each activity and each subject
### First group the dataset by subject, activity name and features then calculate the mean for each feature
library(dplyr)
tidyset <- sub_experiment %>% 
  group_by(.dots=c("subject","activity_names","features")) %>%
  summarise(Avg=mean(value))

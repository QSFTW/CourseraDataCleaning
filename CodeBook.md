# Codebook
## Variables in tidyset
1. subject: Volunteers participated in the experiment indexed as 1 - 30
2. activity_names: names of 6 activities that are taken by each subject
3. features: names of measurements of each activities
4. Avg: average value of each measurement by activity of each subject

## Steps to reproduce the tidy set
### 1. Read all the files to R
- using fread() so that the table read are in data table format

### 2. Merge the train and test data set 
- First, concartenate the rows for "subject", "activities" and  "experiment" using rbind()
- Then, merge the 3 table together using cbind()

### 3. Extract only mean and strandard deviation
- Read the features.txt file to find out the columns which record means and sd as "features"
- Find the subset of feature lable with mean and sd using grepl()
- Extract corresponding columns in "experiment" table to form a new dataset "sub_experiment"

### 4. Use descriptive activity names
- Read activity_labels.txt
- Merge the activity names to the "sub_experiment" dataset using merge()

### 5. Label the data set with descriptive variable names
- Reshape the dataset to long and narrow format using merge()
- which fix only the "subject", "activitylabel" and "activity names"
- merge with the "feature" table

### 6. Creat a tidy dataset with the average of each variable for each activity and each subject
- Group the dataset by "subject", "activity name" and "features" using group_by()
- then calculate the mean for each feature using summarise(Avg=mean(value))
- the result is the tidy dataset
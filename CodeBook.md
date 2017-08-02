---
title: "CodeBook"
author: "ptitmatheux"
date: "August 2, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Raw data used as input

The following files (obtained from the source https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) were used as input in the presented data preparation process:

  - UCI_HAR_Dataset/features.txt: list of all features
  - UCI_HAR_Dataset/activity_labels.txt: links between class labels and corresponding activity name
  - UCI_HAR_Dataset/train/X_train.txt: training data set
  - UCI_HAR_Dataset/train/y_train.txt: each row identifies the the activity type; its range is from 1 to 6
  - UCI_HAR_Dataset/train/subject_train.txt: each row identifies the subject who performed the activity; its range is from 1 to 30
  - UCI_HAR_Dataset/test/X_test.txt: testing data set
  - UCI_HAR_Dataset/test/y_test.txt: each row identifies the the activity type; its range is from 1 to 6
  - UCI_HAR_Dataset/test/subject_test.txt: each row identifies the subject who performed the activity; its range is from 1 to 30

The unzipped folder shoud be placed in a subdirectory *data/* of the current working directory.

## Data preparation

As a first step, one imports train and test data separately. For both sets, one gathers in a single data-frame the data itself with information about the subjects as well as about the type of activity. The labels encoding the type of activity are converted to qualitative descriptions of the activity: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.

```
options(stringsAsFactors = FALSE)
### Importing features names and description of activity labels:
features <- read.table("data/UCI_HAR_Dataset/features.txt")
activity.labels <- read.table("data/UCI_HAR_Dataset/activity_labels.txt")
### Train data:
# importing:
train <- read.table("data/UCI_HAR_Dataset/train/X_train.txt")
train.activity <- read.table("data/UCI_HAR_Dataset/train/y_train.txt")
train.subject <- read.table("data/UCI_HAR_Dataset/train/subject_train.txt")
# converting activity labels to qualitative description:
train.activity.descr <- sapply(train.activity[,1], FUN=function(x) { activity.labels$V2[which(activity.labels$V1 == x)] })
# gathering in a single data-frame the data with info about subjects and activity:
train.data <- bind_cols(subject=train.subject, data.frame("activity"=train.activity.descr), train)

### Test data:
# importing:
test <- read.table("data/UCI_HAR_Dataset/test/X_test.txt")
test.activity <- read.table("data/UCI_HAR_Dataset/test/y_test.txt")
test.subject <- read.table("data/UCI_HAR_Dataset/test/subject_test.txt")
# converting activity labels to qualitative description:
test.activity.descr <- sapply(test.activity[,1], FUN=function(x) { activity.labels$V2[which(activity.labels$V1 == x)] })
# gathering in a single data-frame the data with info about subjects and activity:
test.data <- bind_cols(subject=test.subject, data.frame("activity"=test.activity.descr), test)
```
As a next step, one merges the data-frames *train.data* and *test.data* into a single one, *alldata*:

```
alldata <- bind_rows(train.data, test.data)
```

We now parse the features in order to retain only means and standard deviations of measurements; this results in 66 features. The character strings describing the features are parsed by removing the parenthesis and replacing the "-" (minus) by "_" (underscores). The resulting data-frame is *subdata*; its columns are labeled: "subject", "activity" and the relevant feature names (e.g. "tBodyAcc_mean_X") 

```
# Extracting features:
subfeatures <- grep("-mean\\(|-std\\(", features[,2], value=FALSE)
subfeatures.names <- grep("-mean\\(|-std\\(", features[,2], value=TRUE)
subfeatures.names <- sub(pattern="\\(\\)", replacement = "", subfeatures.names)
subfeatures.names <- gsub(pattern="-", replacement = "_", subfeatures.names)
subdata <- alldata[, c(1, 2, subfeatures+2)]
names(subdata) <- c("subject", "activity", subfeatures.names)
```
The resulting data set was saved in a csv format in "data/tidy_subdata.csv".
Finally, one creates a second tidy dataset with averages of each variables for each activity and each subject:

```
averages <- as.tbl(subdata) %>% group_by(subject, activity) %>% summarise_all(mean, na.rm=TRUE)
```
The resulting data set was saved in a csv format in "data/tidy_averages.csv".

## Output data

The script run_analysis.R produces two data-frames: "subdata" (saved in data/tidy_subdata.csv) and "averages" (saved in data/tidy_averages.csv). 
In both data-frames, columns are labeled by:

"subject" - an integer (from 1 to 30) identifying the subject
"activity" - a character string descrbing the type of activity 

The following features: (of the form "physical quantity"\_"agregation performed on the measurement window"\_"spatial direction")

"tBodyAcc_mean_X"
"tBodyAcc_mean_Y"
"tBodyAcc_mean_Z"          
"tBodyAcc_std_X"
"tBodyAcc_std_Y"
"tBodyAcc_std_Z"
"tGravityAcc_mean_X"
"tGravityAcc_mean_Y"
"tGravityAcc_mean_Z" 
"tGravityAcc_std_X"     
"tGravityAcc_std_Y"   
"tGravityAcc_std_Z"   
"tBodyAccJerk_mean_X"      
"tBodyAccJerk_mean_Y"
"tBodyAccJerk_mean_Z" 
"tBodyAccJerk_std_X"   
"tBodyAccJerk_std_Y"  
"tBodyAccJerk_std_Z"       
"tBodyGyro_mean_X" 
"tBodyGyro_mean_Y"   
"tBodyGyro_mean_Z"  
"tBodyGyro_std_X"  
"tBodyGyro_std_Y"          
"tBodyGyro_std_Z" 
"tBodyGyroJerk_mean_X"  
"tBodyGyroJerk_mean_Y" 
"tBodyGyroJerk_mean_Z"   
"tBodyGyroJerk_std_X"      
"tBodyGyroJerk_std_Y"  
"tBodyGyroJerk_std_Z"  
"tBodyAccMag_mean" 
"tBodyAccMag_std"    
"tGravityAccMag_mean"      
"tGravityAccMag_std"  
"tBodyAccJerkMag_mean" 
"tBodyAccJerkMag_std"   
"tBodyGyroMag_mean"    
"tBodyGyroMag_std"         
"tBodyGyroJerkMag_mean" 
"tBodyGyroJerkMag_std" 
"fBodyAcc_mean_X"       
"fBodyAcc_mean_Y"   
"fBodyAcc_mean_Z"          
"fBodyAcc_std_X"   
"fBodyAcc_std_Y"     
"fBodyAcc_std_Z"    
"fBodyAccJerk_mean_X" 
"fBodyAccJerk_mean_Y"      
"fBodyAccJerk_mean_Z" 
"fBodyAccJerk_std_X"  
"fBodyAccJerk_std_Y"  
"fBodyAccJerk_std_Z" 
"fBodyGyro_mean_X"         
"fBodyGyro_mean_Y"  
"fBodyGyro_mean_Z" 
"fBodyGyro_std_X"   
"fBodyGyro_std_Y"   
"fBodyGyro_std_Z"          
"fBodyAccMag_mean" 
"fBodyAccMag_std"   
"fBodyBodyAccJerkMag_mean"
"fBodyBodyAccJerkMag_std" 
"fBodyBodyGyroMag_mean"   
"fBodyBodyGyroMag_std" 
"fBodyBodyGyroJerkMag_mean"
"fBodyBodyGyroJerkMag_std"

In the data-frame "subdata", rows correspond to all measurements of previous features, for each subject and activity. In the data-frame "averages", each rows corresponds to the *mean* measurements of previous features for each subject and each activity. 


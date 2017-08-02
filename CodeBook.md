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


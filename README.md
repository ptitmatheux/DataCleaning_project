==================================================================
Transforming and tidying the dataset: Human Activity Recognition Using Smartphones Dataset
==================================================================

Overview:
======================================

The script run_analysis.R in the current directory imports a number of .txt files, takes a subset of the data available in the imported files and rearranges it into a tidy data-frame format. Then, it performs some agregations on the previously obtained dataset in order to provide a second, independent dataset. The new datasets are then saved in the local subdirectory data/.
A detailed description of the steps used in the data processing can be found in the html file CodeBook.html (sourced from CodeBook.md)

Files used as input:
======================================

The following files (obtained from the source https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) were used as input in the presented data preparation process:

  - UCI_HAR_Dataset/features.txt: list of all features
  - UCI_HAR_Dataset/activity_labels.txt: links between class labels and corresponding activity name
  - UCI_HAR_Dataset/train/X_train.txt: training data set
  - UCI_HAR_Dataset/train/y_train.txt: each row identifies the the activity type; its range is from 1 to 6
  - UCI_HAR_Dataset/train/subject_train.txt: each row identifies the subject who performed the activity; its range is from 1 to 30
  - UCI_HAR_Dataset/test/X_test.txt: testing data set
  - UCI_HAR_Dataset/test/y_test.txt: each row identifies the the activity type; its range is from 1 to 6
  - UCI_HAR_Dataset/test/subject_test.txt: each row identifies the subject who performed the activity; its range is from 1 to 30

N.B. All remaining files in the unzipped folder UCI_HAR_Dataset are ignored in the present data processing.

The dataset includes the following files:
=========================================

- 'README.md'

- 'CodeBook.html': description of the the data processing

- 'CodeBook.md': the source for the previous file

- 'run_analysis.R': The R code performing the data processing


Output data:
============

The script run_analysis.R produces two data-frames: "subdata" (saved in data/tidy_subdata.csv) and "averages" (saved in data/tidy_averages.csv). 
In both data-frames, columns are labeled by:

"subject"
"activity"
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


Notes: 
======
- Features are normalized and bounded within [-1,1].



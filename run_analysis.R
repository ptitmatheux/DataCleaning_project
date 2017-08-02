
options(stringsAsFactors = FALSE)
library(dplyr)

features <- read.table("data/UCI_HAR_Dataset/features.txt")
activity.labels <- read.table("data/UCI_HAR_Dataset/activity_labels.txt")

train <- read.table("data/UCI_HAR_Dataset/train/X_train.txt")
train.activity <- read.table("data/UCI_HAR_Dataset/train/y_train.txt")
train.activity.descr <- sapply(train.activity[,1], FUN=function(x) { activity.labels$V2[which(activity.labels$V1 == x)] })
train.subject <- read.table("data/UCI_HAR_Dataset/train/subject_train.txt")

train.data <- bind_cols(subject=train.subject, data.frame("activity"=train.activity.descr), train)

test <- read.table("data/UCI_HAR_Dataset/test/X_test.txt")
test.activity <-read.table("data/UCI_HAR_Dataset/test/y_test.txt")
test.activity.descr <- sapply(test.activity[,1], FUN=function(x) { activity.labels$V2[which(activity.labels$V1 == x)] })
test.subject <- read.table("data/UCI_HAR_Dataset/test/subject_test.txt")
test.data <- bind_cols(subject=test.subject, data.frame("activity"=test.activity.descr), test)

# Merging train and test data together:
alldata <- bind_rows(train.data, test.data)

# Extracting features:
subfeatures <- grep("-mean\\(|-std\\(", features[,2], value=FALSE)
subfeatures.names <- grep("-mean\\(|-std\\(", features[,2], value=TRUE)
subfeatures.names <- sub(pattern="\\(\\)", replacement = "", subfeatures.names)
subfeatures.names <- gsub(pattern="-", replacement = "_", subfeatures.names)
subdata <- alldata[, c(1, 2, subfeatures+2)]
names(subdata) <- c("subject", "activity", subfeatures.names)
write.csv(subdata, file="data/tidy_subdata.csv", row.names=FALSE)

# Creating a dataset with averages per activity and subject:
averages <- as.tbl(subdata) %>% group_by(subject, activity) %>% summarise_all(mean, na.rm=TRUE)
write.csv(averages, file="data/tidy_averages.csv", row.names=FALSE)



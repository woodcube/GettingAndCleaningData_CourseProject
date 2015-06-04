library(dplyr)
library(tidyr)

# read data
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
X_test <- read.table('UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')

subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
X_train <- read.table('UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')

# merge test and train data sets
subject <- rbind(subject_test, subject_train)
X <- rbind(X_test, X_train)
y <- rbind(y_test, y_train)

# use variable names
features <- read.table('UCI HAR Dataset/features.txt')
colnames(X) <- features[['V2']]

# extract only the measurements on mean and standard deviation 
X <- X[, grep('std|mean', colnames(X))]

# use activity names
activity_labels <- read.table('UCI HAR Dataset/activity_labels.txt')
y <- merge(y, activity_labels)
y <- y['V2']

# combine into 1 table
colnames(y) <- 'activities'
colnames(subject) <- 'subject'
df <- cbind(subject, y, X)

# create data set with the average of each variable
# for each activity and each subject
df2 <- df %>% group_by(subject, activities) %>% summarise_each(funs(mean))
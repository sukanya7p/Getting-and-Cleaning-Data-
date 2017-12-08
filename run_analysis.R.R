# Below is the code to download and unzip the dataset

if (!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")
# Unzipping the dataset and saving the files in the data dorectory
  unzip(zipfile = "./data/dataset.zip", exdir="./data")
# Listing the data files in the data directory
  list.files("./data")
 
 
#Merging the "training" and the "test" data sets to create combined data set.
 
# Reading training data 
 x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
 y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
 subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
# Reading testing data
 x_test<- read.table("./data/UCI HAR Dataset/test/x_test.txt")
 y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
 subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
# Reading features vector
features <- read.table("./data/UCI HAR Dataset/features.txt")
# Reading activity label
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
# Assigning column names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c("activityId", "activityType")
# Merging all datas into one large set
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setInAll <- rbind(mrg_train,mrg_test)

# Extracting only the measurements on the mean and standard deviation for each measurements
# Reading column names
colNames <- colnames(setInAll)
# Creating a vector defining ID, Mean and Standard deviation
mean_and_stdv <- (grepl("activityId", colNames)|
                    grepl("subjectId", colNames)|
                    grepl("mean.." , colNames)|
                    grepl("std.." , colNames)
                  )
# Subsetting Means and Standard deviation
subsetMean_Stdev <- setInAll[, mean_and_stdv==TRUE]
# Using descriptive activity names to name the actiivity in the data set
setWithActivityNames <- merge(subsetMean_Stdev, activityLabels,
                              by='activityId',
                              all.x=TRUE)

# Creating a second independeent tidy data set with the average of each variable for each activity and each subject
# Making second tidy data set
secTidySet <- aggregate(.~subjectId+activityId, setWithActivityNames,mean)

secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

# Writing second tidy data in text file



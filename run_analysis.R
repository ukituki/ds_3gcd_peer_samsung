
### Merge training and test sets ####

#read training data
X_train <- read.table("data/train/X_train.txt", quote="\"")
subject_train <- read.table("data/train/subject_train.txt", quote="\"")
y_train <- read.table("data/train/y_train.txt", quote="\"")

#create one data set with complete training data by adding ids and outcomes
train <- cbind(X_train, subject_train)
train <- cbind(train, y_train)

#read test data
X_test <- read.table("data/test/X_test.txt", quote="\"")
subject_test <- read.table("data/test/subject_test.txt", quote="\"")
y_test <- read.table("data/test/y_test.txt", quote="\"")

#create full test data
test <- cbind(X_test, subject_test)
test <- cbind(test, y_test)

#combine test and training data
all <- rbind(train, test)

#create vector with features names
features <- read.table("data/features.txt", quote="\"")
featuresnames <- as.vector(features[,2])
featuresnames <- c(featuresnames, "id", "label")

#set names for merged data set
names(all) <- featuresnames

#remove variables not needed any more
rm("features", "test", "train", "featuresnames", "subject_test", 
   "subject_train","y_test", "y_train", "X_train", "X_test")


# Extracts only the measurements on the mean and standard deviation for 
# each measurement. 
selectcols <- grep("mean|std", names(all))
reduceddata <- all[,c(selectcols, 562, 563)]

# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive activity names. 

activitylabels <- read.table("data/activity_labels.txt", quote="\"")
names(activitylabels) <- c("label", "activity")
reduceddata <- merge(reduceddata, activitylabels)
# remove label col
reduceddata <- reduceddata[,-1]
# names(reduceddata)


# Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
library(reshape2)
meltdata <- melt(reduceddata, id.vars = c("id", "activity"), 
                 measure.vars = names(reduceddata)[1:79])
tidydata <- dcast(meltdata, id+activity ~ variable, mean)
write.table(tidydata, "cleandata.txt")

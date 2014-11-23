# 3rd week of Coursera Data Cleanning course

#We need melt and dcast during the script so we load reshape lybrary
library(reshape2)
#Read activity labels
activities<-read.table("./activity_labels.txt")

#Read features 
features<-read.table("./features.txt")

#read Test Set
testSetX <-read.table("./test/X_test.txt")
testSetY <-read.table("./test/y_test.txt")
#Read test subjects
testSetSub <-read.table("./test/subject_test.txt")
#read Train Set
trainSetX <-read.table("./train/X_train.txt")
trainSetY <-read.table("./train/y_train.txt")
#Read train subjects
trainSetSub <-read.table("./train/subject_train.txt")
#Since are the same type of data and we cat the Y observations
totalSetY <- rbind(testSetY,trainSetY)
colnames(totalSetY) <-"activity_id"

totalSetSubjects <- rbind( testSetSub, trainSetSub)
colnames(totalSetSubjects) <-"subject_id"
colnames(activities) <-c("activity_id","activity_name")
# 1-Merges the training and the test sets to create one data set.
totalSetX<-rbind(testSetX,trainSetX)

# 2-Extracts only the measurements on the mean and standard deviation for each measurement.
# Grep the info to have only data of the mean and the std
meanAndStdFeatures<- features[ grep("mean|std",features$V2),]

#Select from the total set only the columns related to mean() and std() functions
meanAndStdSetX<-totalSetX[,meanAndStdFeatures$V1]

#Add columns with the subject id and the activity id
meanAndStdSet<-cbind(totalSetSubjects,totalSetY,meanAndStdSetX)

#3-Uses descriptive activity names to name the activities in the data set
# Add a new column with the name of the activity, so we have to merge by activity_id and V1
meanAndStdSetActiv<-merge (activities,meanAndStdSet, by.x="activity_id", by.y="activity_id", by.all=TRUE)

# 4-Appropriately labels the data set with descriptive variable names.
colnames(meanAndStdSetActiv) <-c("activity_id","activity_name","subject_id",as.character(meanAndStdFeatures$V2))

meanAndStdSetActiv<-meanAndStdSetActiv[,2:ncol(meanAndStdSetActiv)]
# 5-From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

dataMelted <- melt(meanAndStdSetActiv, id=c("activity_name","subject_id"))
#The mean of variable 
castedData <-dcast(dataMelted, subject_id + activity_name ~ variable, mean)
#Then, we melt the new data set to have a nice tidy data with only four columns
tidyData <- melt(castedData, id=c("subject_id","activity_name"))
#Then, the dataSet
write.table(tidyData,"tidyDataSet.txt", row.names=FALSE)

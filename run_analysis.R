# 3rd week of Coursera Data Cleanning course

#Read activity labels
activities<-read.table("./activity_labels.txt")

#Read features 
features<-read.table("./features.txt")



#read Test Set
testSetX <-read.table("./test/X_test.txt")
testSetY <-read.table("./test/y_test.txt")
#Read subjects
testSetSub <-read.table("./test/subject_test.txt")
#read Train Set
trainSetX <-read.table("./train/X_train.txt")
trainSetY <-read.table("./train/y_train.txt")
#Read subjects
trainSetSub <-read.table("./train/subject_train.txt")
#Since are the same type of data and we cat the Y observations
totalSetY <- rbind(testSetY,trainSetY)
colnames(totalSetY) <-"activity_id"

totalSetY <- rbind(testSetY,trainSetY)
totalSetSubjects <- rbind( testSetSub, trainSetSub)
colnames(totalSetSubjects) <-"Subject_id"
# 1-Merges the training and the test sets to create one data set.


# 2-Extracts only the measurements on the mean and standard deviation for each measurement.

# Grep the info to have only data of the mean and the std
meanAndStdFeatures<- features[ grep("mean|std",features$V2),]

meanAndStdSetX<-totalSetX[,meanAndStdFeatures$V1]
meanAndStdSet<-cbind(totalSetSubjects,totalSetY,meanAndStdSetX)

#3-Uses descriptive activity names to name the activities in the data set
meanAndStdSetActiv<-merge (activities,meanAndStdSet, by.x="V1", by.y="Activity_id", by.all=TRUE)

# 4-Appropriately labels the data set with descriptive variable names.
colnames(meanAndStdSetActiv) <-c("activity_id","activity_name","subject_id",as.character(meanAndStdFeatures$V2))

# 5-From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
dataSplit <-split (meanAndStdSetActiv, list(meanAndStdSetActiv$activity_id,meanAndStdSetActiv$subject_id ))


finalData<-lapply(dataSplit, function(x) colMeans(x[,4:ncol(meanAndStdSetActiv)]))

write.table(finalData,"tidyDataSet.txt", row.name=FALSE)

run_analysis Guide
==================

Guide with the main run_analysis script functions.
line break

###Variables reading initial files:
1. `activities` data.frame of activity_labels.txt
2. `features` data.frame of features.txt
3. `testSetX` data.frame of  X_test.txt
4. `testSetY` data.frame of y_test.txt
5. `testSetSub` data.frame of subject_test.txt
6. `trainSetX` data.frame of X_train.txt
7. `trainSetY`data.frame of y_train.txt
8. `trainSetSub` data.frame of subject_train.txt

___

After read each text file into a data frame, 

as `testSetY` and `trainSetY`  contain the same type of data we cat the Y observations and set the name as `activity_id`;

```R
totalSetY <- rbind(testSetY,trainSetY)
colnames(totalSetY) <-"activity_id"
```
We do the same for the set of subjects to obtain;
`totalSetSubjects` as data.frame

We change the column names of the activities to have activity_id and activity_name

At this point, we create a data frame with train and test set X

Next command greps only the mean and standar data columns;
```R
meanAndStdFeatures<- features[ grep("mean|std",features$V2),]
```
The subset desired is obtained by selecting only the columns that match `meanAndStdFeatures$V1`
```R
meanAndStdSetX <- totalSetX[,meanAndStdFeatures$V1]
```
The next step towards the full dataset is to add the  `totalSetSubjects` and the `totalSetY` colums with the `cbind` function;
`meanAndStdSet`

Then we merge the activities with this set by `activity_id` and the full dataset is ready.

`meanAndStdSetActiv` is the data.frame with this information.

To add readable labels to the data set the colnames function is called.

```R
colnames(meanAndStdSetActiv) <-c("activity_id","activity_name","subject_id",as.character(meanAndStdFeatures$V2))
```
As the activity_id is no longer needed, is removed from the dataSet
___
So far, so good. Now the funny commands start... 
The last part of the script creates a new data.frame object `dataMelted` with the data formated by activity_name and subject_id
```R
dataMelted <- melt(meanAndStdSetActiv, id=c("activity_name","subject_id"))
```
To obtain a dataframe with the average values of each variable a dcast function is called. The subject_id and `activity_name` and `subject_id` again.
```R
castedData <-dcast(dataMelted, subject_id + activity_name ~ variable, mean)
```
The `castedData` is not a tidy data set, since we have each variable in a column as the `meanAndStdSetActiv` previous data frame.
Then we only need to melt it again and obtain the `tidyData` set.
```R
tidyData <- melt(castedData, id=c("subject_id","activity_name"))
```
And, to end the script, the `tidyData` dataframe is writen to a text file;
___
**tidyDataSet.txt** is the final file obtained as the output of run_analysis script.
This plain text file contains a tiny data set with four columns:
1. `subject_id` With the 30 id's of the people that carried out the smart phones
2. `activity_name` With one of the six activities that they where performing while the observation 
..* LAYING
..* SITTING
..* STANDING
..* WALKING
..* WALKING_DOWNSTAIRS
..* WALKING_UPSTAIRS
3. `variable` The different meassures related to mean or standard deviation
4. `value` is the mean value of the variable observed for each subject and activity


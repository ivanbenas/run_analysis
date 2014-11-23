run_analysis Guide
==================

Guide with the main run_analysis script functions.
line break

###Variables:
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
We the same for the subjects to obtain;
`totalSetSubjects` as data.frame

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
___
So far, so good. Now the funny commands start... 
The last part of the script creates a list object `dataSplit` with the split data by activity_id and subject_id
```R
dataSplit <-split (meanAndStdSetActiv, list(meanAndStdSetActiv$activity_id,meanAndStdSetActiv$subject_id ))
```
To obtain a dataframe with the average values of each column a lapply function is called. The first 3 columns of each
data frame have not to be applied in the function.
```R
finalData<-lapply(dataSplit, function(x) colMeans(x[,4:ncol(meanAndStdSetActiv)]))
```
And, to end the script, the `finalData` dataframe is writen to a text file;
___
**tidyDataSet.txt** is the final file obtained as the output of run_analysis script.


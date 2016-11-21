library(dplyr)
#get data dictionary data
features <- read.table('.//UCI HAR Dataset//features.txt',header=F)
activity_labels <- read.table('.//UCI HAR Dataset//activity_labels.txt',header=F)

#get the training data
activity_train_data <- read.table('.//UCI HAR Dataset//train//y_train.txt',header=F)
subject_train <- read.table('.//UCI HAR Dataset//train//subject_train.txt',header=F)
trainData <- read.table('.//UCI HAR Dataset//train//X_train.txt',header=F)

#get the test data
activity_test_data <- read.table('.//UCI HAR Dataset//test//y_test.txt',header=F)
subject_test <- read.table('.//UCI HAR Dataset//test//subject_test.txt',header=F)
testData <- read.table('.//UCI HAR Dataset//test//X_test.txt',header=F)

#if I wanted to add the Inertia Data, this would be how...
#accXtrain = read.table('.//UCI HAR Dataset//train//Inertial Signals//total_acc_x_train.txt',header=F)
      
#assign column names
names(trainData) = features[,2]
names(testData) = features[,2]

names(activity_train_data) = 'ActivityCode'
names(activity_test_data) = 'ActivityCode'

#merge the subject records
## ALWAYS RUN THE MERGE TRAIN,TEST so the records don't get flipped
merged_subjects <- rbind(subject_train,subject_test)
names(merged_subjects)="SubjectNumber"

#merge the activity data
activity_data_merged = rbind(activity_train_data,activity_test_data)

#Label the activity code with plain english describing the activity
activity_data_merged['ActivityType']=activity_labels[activity_data_merged$ActivityCode,2]

#merge the measurement data 
merged_data <- rbind(trainData,testData)

#keep only the column names with mean or std in them
data_MeanStd <- cbind(merged_data[,(grep('mean',names(merged_data)))],merged_data[,(grep('std',names(merged_data)))])

#Combine the activity, subject, and select measurement data
tidyData <- cbind(merged_subjects,activity_data_merged,data_MeanStd)

#Split the first tidyData data frame up so we can summarize it.
tidySet2 <- split(tidyData,tidyData$ActivityType)

#start a counter
counter <- 1
for (set in tidySet2){ #iterate through the activity dataframe sets
  if(counter ==1){ #if this is the first iteration, make the dataframe
    #aggregate the subjectnumer's measurement data together as a mean value
    summarySet <- aggregate(set, by=list(set$SubjectNumber), FUN=mean)}
  else{ #the data frame already exists. Add to it.
    #aggregate the subjectnumer's measurement data together as a mean value
    summarySet <- rbind(summarySet,aggregate(set, by=list(set$SubjectNumber), FUN=mean))}
  #add to the counter
  counter = counter +1
}

#CLEANUP
#Label the activity code with plain english describing the activity
summarySet['ActivityType']=activity_labels[summarySet$ActivityCode,2]

#Remove the Group.1 field
summarySet <- subset(summarySet, select = -Group.1 )

#Save the data 
write.table(tidyData,file='tidyData.txt',row.name =F )
write.table(summarySet,file='tidySummaryData.txt',row.name=F)

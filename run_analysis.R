#Read X train and test datasets
XTrainData = read.table('./UCI HAR Dataset/train/X_train.txt',row.names=NULL)
XTestData = read.table('./UCI HAR Dataset/test/X_test.txt',row.names=NULL)

#Merge the X train and test datasets
XCombinedData = rbind(XTrainData,XTestData)

#Read subject train and test datasets
SubjectTrainData = read.table('./UCI HAR Dataset/train/subject_train.txt')
SubjectTestData = read.table('./UCI HAR Dataset/test/subject_test.txt')

#Merge the subject train and test datasets
SubjectCombinedData = rbind(SubjectTrainData, SubjectTestData)

#Read y train and test datasets
YTrainData = read.table('./UCI HAR Dataset/train/y_train.txt')
YTestData = read.table('./UCI HAR Dataset/test/y_test.txt')

#Merge the subject train and test datasets
YCombinedData = rbind(YTrainData, YTestData)

#Read features file
Features = read.table('./UCI HAR Dataset/features.txt')

#Extract columns containing mean or std (ignoring case)
pattern = 'mean|std'
mean_std_cols = which(grepl(pattern,Features$V2, ignore.case=TRUE))

#Extract the data containing mean or std from X combined data
mean_std_CombinedData = XCombinedData[,mean_std_cols]

options(stringsAsFactors = FALSE)
#Read activity labels
ActivityLabels = read.table('./UCI HAR Dataset/activity_labels.txt')

Descriptive_YCombinedData = vector()
#Use descriptive activity names to name the activities in the data set
for (i in 1:length(YCombinedData[,1])) {
  if (YCombinedData[i,1] == 1) {
    Descriptive_YCombinedData[i] = ActivityLabels$V2[1]
  }
  if (YCombinedData[i,1] == 2) {
    Descriptive_YCombinedData[i] = ActivityLabels$V2[2]
  }
  if (YCombinedData[i,1] == 3) {
    Descriptive_YCombinedData[i] = ActivityLabels$V2[3]
  }
  if (YCombinedData[i,1] == 4) {
    Descriptive_YCombinedData[i] = ActivityLabels$V2[4]
  }
  if (YCombinedData[i,1] == 5) {
    Descriptive_YCombinedData[i] = ActivityLabels$V2[5]
  }
  if (YCombinedData[i,1] == 6) {
    Descriptive_YCombinedData[i] = ActivityLabels$V2[6]
  }    
}

#Replace features with descriptive variable names
Features$V2 = gsub("^t","time ",Features$V2)
Features$V2 = gsub("^f","frequency ",Features$V2)
Features$V2 = gsub("Acc"," Accelerometer ",Features$V2)
Features$V2 = gsub("Gyro"," Gyroscope ",Features$V2)
Features$V2 = gsub("mean()"," Mean value ",Features$V2)
Features$V2 = gsub("std()"," Standard deviation ",Features$V2)
Features$V2 = gsub("mad()"," Median absolute deviation ",Features$V2)
Features$V2 = gsub("max()"," Largest value in array ",Features$V2)
Features$V2 = gsub("min()"," Smallest value in array ",Features$V2)
Features$V2 = gsub("sma()"," Signal magnitude area ",Features$V2)
Features$V2 = gsub("energy()"," Energy measure ",Features$V2)
Features$V2 = gsub("iqr()"," Interquartile range ",Features$V2)
Features$V2 = gsub("entropy()"," Signal entropy ",Features$V2)
Features$V2 = gsub("arCoeff()"," Autorregresion coefficients with Burg order equal to 4 ",Features$V2)
Features$V2 = gsub("correlation()"," correlation coefficient between two signals ",Features$V2)
Features$V2 = gsub("maxInds()"," index of the frequency component with largest magnitude ",Features$V2)
Features$V2 = gsub("meanFreq()"," Weighted average of the frequency components ",Features$V2)
Features$V2 = gsub("skewness()"," skewness ",Features$V2)
Features$V2 = gsub("kurtosis()"," kurtosis ",Features$V2)
Features$V2 = gsub("bandsEnergy()"," Energy of a frequency interval ",Features$V2)
Features$V2 = gsub("angle()"," Angle between to vectors ",Features$V2)

#Extract the data containing mean or std from X Features
mean_std_Features = Features$V2[mean_std_cols]

#Add column names to dataset
colnames(mean_std_CombinedData) = mean_std_Features

colnames(SubjectCombinedData) = 'Subject'

#Add columns for subject and activity
mean_std_CombinedData$Subject = SubjectCombinedData
mean_std_CombinedData$Activity = Descriptive_YCombinedData

write.table(mean_std_CombinedData, 'TidyData.txt',row.name=FALSE)



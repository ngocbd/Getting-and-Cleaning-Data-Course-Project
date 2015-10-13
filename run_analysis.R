require(data.table)


#setwd("C:/Users/NgocBD/Getting-and-Cleaning-Data-Course-Project")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "dataset.zip"
if (!file.exists(f))
{
	download.file(url, f)
	unzip ("dataset.zip", exdir = ".")
}

train.x<-read.table("UCI HAR Dataset/train/X_train.txt")
test.x<-read.table("UCI HAR Dataset/test/X_test.txt")
train.y<-read.table("UCI HAR Dataset/train/y_train.txt")
test.y<-read.table("UCI HAR Dataset/test/y_test.txt")
Subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
Subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
activity_lables<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

#Merges the train and the test sets to create one data set.
full.x<-rbind(train.x,test.x)

#Extracts  measurements on the mean and standard deviation for each measurement.
colnames(full.x) <- c(as.character(features[,2]))

Mean<-grep("mean()",colnames(full.x),fixed=TRUE)

SD<-grep("std()",colnames(full.x),fixed=TRUE)

MeanSD<-full.x[,c(Mean,SD)]

#Uses descriptive activity names to name the activities in the data set.

all.y<-rbind(train.y,test.y)

all.activity<-cbind(all.y,MeanSD)

colnames(all.activity)[1] <- "Activity"

#Appropriately labels the data set with descriptive activity names.
activity_lables[,2]<-as.character(activity_lables[,2])

for(i in 1:length(all.activity[,1])){
  all.activity[i,1]<-activity_lables[all.activity[i,1],2]
}

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Subject_all<-rbind(Subject_train,Subject_test)

all<-cbind(Subject_all,all.activity)

colnames(all)[1] <- "Subject"

Tidy <- aggregate( all[,3] ~ Subject+Activity, data = all, FUN= "mean" )

for(i in 4:ncol(all)){
  Tidy[,i] <- aggregate( all[,i] ~ Subject+Activity, data = all, FUN= "mean" )[,3]
}

colnames(Tidy)[3:ncol(Tidy)] <- colnames(MeanSD)
#Write to final data file
write.table(Tidy, file = "HumanActivityRecognitionUsingSmartphones.txt",row.name=FALSE)
run_analysis.R
==============

Download dataset 
==============

```R

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "dataset.zip"
if (!file.exists(f))
{
	download.file(url, f)
	unzip ("dataset.zip", exdir = ".")
}

```

Extract to current directory
==============

```R
unzip ("dataset.zip", exdir = ".")
```


Read test and train dataset to datatable 
==============

```R
train.x<-read.table("UCI HAR Dataset/train/X_train.txt")
test.x<-read.table("UCI HAR Dataset/test/X_test.txt")
train.y<-read.table("UCI HAR Dataset/train/y_train.txt")
test.y<-read.table("UCI HAR Dataset/test/y_test.txt")
```


Merges the train and the test sets to create one data set.
==============

```R
#Merges the train and the test sets to create one data set.
full.x<-rbind(train.x,test.x)
```


Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
==============
```R
Subject_all<-rbind(Subject_train,Subject_test)

all<-cbind(Subject_all,all.activity)

colnames(all)[1] <- "Subject"

Tidy <- aggregate( all[,3] ~ Subject+Activity, data = all, FUN= "mean" )

for(i in 4:ncol(all)){
  Tidy[,i] <- aggregate( all[,i] ~ Subject+Activity, data = all, FUN= "mean" )[,3]
}

colnames(Tidy)[3:ncol(Tidy)] <- colnames(MeanSD)
```

Write to final data file
==============

```R
write.table(Tidy, file = "HumanActivityRecognitionUsingSmartphones.txt",row.name=FALSE)
```
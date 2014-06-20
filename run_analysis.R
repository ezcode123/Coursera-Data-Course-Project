setwd("C:\\Users\\a0196320\\Documents\\training\\R\\Coursera")

## Read in the file from the web, unzip the directory, and read in the data tables.

  if (!file.exists("dataproject")){dir.create("dataproject")}
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "./dataproject/projectfiles.zip")
  list.files("./dataproject")
  if (!file.exists("./dataproject/zipdir")){dir.create("./dataproject/zipdir")}

  unzip("./dataproject/projectfiles.zip", exdir="./dataproject/zipdir")

  testdata <- read.table("./dataproject/zipdir/UCI HAR Dataset/test/X_test.txt")
  traindata <- read.table("./dataproject/zipdir/UCI HAR Dataset/train/X_train.txt")
  dim(testdata)
  dim(traindata)

## Combine the test and train data

  combineddata <- rbind(testdata, traindata)

## Read in the variable names and make a vector of variables that have mean() or std() in name

  variables <- read.table("./dataproject/zipdir/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
  keepvar <- variables[c(grep("mean()",variables$V2),grep("std()",variables$V2)),]
  keepvar <- keepvar[order(keepvar$V1),] 

## Subset the dataset for to keep only the mean and std variables
  
  trimdata <- combineddata[,keepvar$V1]

## Read in the subject and activity columns for both test and train datasets
## Append these columns to the dataset

  testsubject <- read.table("./dataproject/zipdir/UCI HAR Dataset/test/subject_test.txt")
  trainsubject <- read.table("./dataproject/zipdir/UCI HAR Dataset/train/subject_train.txt")
  subject <- rbind(testsubject,trainsubject)

  testactivity <- read.table("./dataproject/zipdir/UCI HAR Dataset/test/y_test.txt")
  trainactivity <- read.table("./dataproject/zipdir/UCI HAR Dataset/train/y_train.txt")
  activity <- rbind(testactivity, trainactivity)

  trimdata$Subject <- subject$V1
  trimdata$activityno <- activity$V1

## Load in the decoder for the activities number and replace numbers with activity name

  activitykey <- read.table("./dataproject/zipdir/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
  names(activitykey)[names(activitykey)=="V1"] <- "activityno"
  names(activitykey)[names(activitykey)=="V2"] <- "Activity"
  alldata <- merge(trimdata, activitykey, by="activityno", all=TRUE)

## Clean up the variable names and apply them to the dataset
  for (i in 1:nrow(keepvar)){
      keepvar[i,"V2"] <- gsub("\\(\\)", "", keepvar[i,"V2"])
      keepvar[i,"V2"] <- gsub("-", ".", keepvar[i,"V2"])
      keepvar[i,"V3"] <- paste("V",keepvar[i,"V1"],sep="")
      names(alldata)[names(alldata)==keepvar[i,"V3"]] <- keepvar[i,"V2"]   
  }

## Find the mean of all the variables by activity and subject

  library(reshape2)

  alldata <- alldata[,!(names(alldata) == "activityno")]
  dataMelt <- melt(alldata,id=c("Subject","Activity"))
  datasum <- aggregate(value ~ ., data = dataMelt, mean, simplify=TRUE, na.action=na.omit)
  names(datasum)[names(datasum)=="value"] <- "Mean"
  widemean <- reshape(datasum, timevar="variable", idvar=c("Subject","Activity"), direction="wide")

## Write out the tidy dataset as a text file

  write.table(widemean, "./dataproject/tidy_data.txt", sep = " ", row.names=FALSE)
  
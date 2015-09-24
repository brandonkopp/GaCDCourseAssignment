#GETTING AND CLEANING DATA

#COURSE PROJECT

##DOWNLOAD .ZIP AND EXTRACT FILES (NOTE: THE ZIP FILE IS FILE 62.6MB)
  if (!file.exists("./data")){
    dir.create("./data")
  }
  
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,destfile="./data/Galaxy.zip", method="curl")
  list.files("./data")
  
  dateDownloaded <- date()
  dateDownloaded
  
  unzip("./data/Galaxy.zip", exdir = "./data")

#Create table of X variable features and activity labels
features <- read.table("./data/UCI HAR Dataset/features.txt",sep=" ")
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt",sep=" ")
activities$V2 <- sub("_"," ",activities$V2)
names(activities)[1] <- "label"

##COMBINE X, Y, & SUBJECT TEST FILES INTO SINGLE DATASET
  #Extract Test Variables
  xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt",sep="", header = FALSE)
  yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt",sep=" ")
  subTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",sep=" ")
  
  #Assign variable names
  names(xTest) <- features[ ,2]
  
  #Combine test files
  testData <- cbind(subTest, yTest, xTest)
  
  names(testData)[1:2] <- c("subject", "label")
  
  #Merge meaningful y-variable labels with dataset
  testData <- merge(activities, testData, by = "label")
  
  #Remove interim datasets from Global Environment
  rm(list= c("xTest", "yTest", "subTest"))

##COMBINE X, Y, & SUBJECT TRAIN FILES INTO SINGLE DATASET
  #Extract Train Variables
  xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt",sep="", header = FALSE)
  yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt",sep=" ")
  subTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",sep=" ")
  
  #Assign variable names
  names(xTrain) <- features[ ,2]
  
  #Combine train files
  trainData <- cbind(subTrain, yTrain, xTrain)
  
  names(trainData)[1:2] <- c("subject", "label")
  
  #Merge meaningful y-variable labels with dataset
  trainData <- merge(activities, trainData, by = "label")
  
  #Remove interim datasets from Global Environment
  rm(list= c("xTrain", "yTrain", "subTrain"))

##MERGE TEST AND TRAIN DATASETS
  mergedData <- rbind(testData, trainData)
  #Remove interim datasets from Global Environment
  rm(list= c("testData", "trainData"))
  
  names(mergedData)[2] <- "activity"

##SUBSET THE MERGED FILE SO THAT IT CONTAINS ONLY VARIABLES WITH MEAN AND STD
  nameext <- grep("*subject*|*activity*|*mean\\(\\)*|*std()*", x= names(mergedData))
  mergedData <- mergedData[ , nameext]
  mergedData <- mergedData[ ,c(2,1, 3:length(mergedData))]

##MAKE MEANINFUL LABELS FOR VARIABLES
  features <- names(mergedData)
  
  features <- sub("^t", "Time-", features)
  features <- sub("^f", "Frequency-", features)
  features <- sub("BodyAccJerkMag", "Body Acceleration Jerk Magnitude", features)
  features <- sub("GravityAccJerkMag", "Gravity Acceleration Jerk Magnitude", features)
  features <- sub("BodyAccMag", "Body Acceleration Magnitude", features)
  features <- sub("GravityAccMag", "Gravity Acceleration Magnitude", features)
  features <- sub("BodyAccJerk", "Body Acceleration Jerk Signal", features)
  features <- sub("GravityAccJerk", "Gravity Acceleration Jerk Signal", features)
  features <- sub("BodyAcc", "Body Acceleration", features)
  features <- sub("GravityAcc", "Gravity Acceleration", features)
  features <- sub("BodyGyroMag", "Body Gyroscope Magnitude", features)
  features <- sub("BodyGyroJerkMag", "Body Gyroscope Jerk Magnitude", features)
  features <- sub("BodyGyroJerk", "Body Gyroscope Jerk Signal", features)
  features <- sub("BodyGyro", "Body Gyroscope", features)
  features <- sub("*mean\\(\\)*", "Mean", features)
  features <- sub("std\\(\\)", "Standard Deviation", features)
  features <- sub("X", "X-Axis", features)
  features <- sub("Y", "Y-Axis", features)
  features <- sub("Z", "Z-Axis", features)
  features <- sub("BodyBody", "Overall Body", features)
  
  names(mergedData) <- features

##CREATE SIMPLIFIED DATA FILE WITH ONE ROW PER ACTIVITY PER PERSON
  simpleData <- aggregate(mergedData, by=list(mergedData$subject, mergedData$activity), FUN= mean)
  rm("mergedData")
  simpleData <- simpleData[ ,c(1,2,5:length(simpleData))]
  names(simpleData)[1:2] <- c("subject","activity")
  simpleData <- simpleData[order(simpleData$subject, simpleData$activity), ]
  
##RESHAPE TABLE SO THAT EACH ROW CONSISTS OF ONE MEAN OBSERVATION FOR EACH ACTIVITY FOR EACH PERSON  
  install.packages("reshape2")
  library(reshape2)
  
  measurevars <- names(simpleData)[3:length(simpleData)]
  
  
  simpleData <- melt(simpleData, id=c("subject", "activity"), 
                   measure.vars= measurevars)

  names(simpleData)[4] <- c("mean value")

##WRITE TABLE TO TXT FILE
  write.table(simpleData, file="./data/simpledata.txt", sep=",", row.names = FALSE)

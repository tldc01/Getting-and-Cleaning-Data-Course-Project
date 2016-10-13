

# Q1. Load required packages and read in the training and testing files.

library(dplyr)

traindata<-read.table("UCI HAR Dataset/train/X_train.txt")
trainsub<-read.table("UCI HAR Dataset/train/subject_train.txt")
trainlabels<-read.table("UCI HAR Dataset/train/y_train.txt")
testdata<-read.table("UCI HAR Dataset/test/X_test.txt")
testsub<-read.table("UCI HAR Dataset/test/subject_test.txt")
testlabels<-read.table("UCI HAR Dataset/test/y_test.txt")
features<-read.table("UCI HAR Dataset/features.txt")
activitylabels<-read.table("UCI HAR Dataset/activity_labels.txt")

# Q1. (cont). Now combine the training and test datasets...

trainmaster<-cbind(trainsub, trainlabels, traindata) #adds subject field and labels field to training data
testmaster<-cbind(testsub, testlabels, testdata) #adds subject field and labels field to testing data
mastertbl<-rbind(trainmaster,testmaster)  #consolidates training and testing data via 'rowbind' function

# Q2.  Compute the mean and standard deviation for each column in the combined dataset.

datameans<-colMeans(mastertbl)
datastdev<-sapply(mastertbl,sd)

# Q3 & Q4.  Assign the activity names to an object and label columns with descriptive names

activitynames<-features[,2]
names(mastertbl)<-c("subjectnum", "activitynum", as.character(activitynames))

# Q5. Create new data frame rolling up average to subject and activity

keepflag<-ifelse(grepl("mean|std", names(mastertbl)), "keep", "drop") #filter vector defined for selected fields
tmp1<-mastertbl[names(mastertbl)[keepflag=="keep"]]
tmp1<-cbind(mastertbl$subjectnum, mastertbl$activitynum,tmp1)
newnames<-names(tmp1)
ID <- as.vector(paste("ID",as.character(1:81),sep=""))
names(tmp1)<-ID
tidytbl<-tmp1 %>% group_by(ID1, ID2) %>% summarise_each(funs(mean))  #calculate the statistics
tmp2<-merge(activitylabels, tidytbl, by.x = "V1", by.y="ID2")
output<-select(tmp2, -V1)
names(output)<-newnames
write.table(output,"tidyoutput.csv", row.name=FALSE) #generate output file

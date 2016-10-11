


# Q1. Read in the files and combine the training and test datasets

traindata<-read.table("X_train.txt")
testdata<-read.table("X_test.txt")
features<-read.table("features.txt")
alldata<-rbind(traindata, testdata)

# Q2.  Compute the mean and standard deviation for each column in the combined dataset

datameans<-colMeans(alldata)
datastdev<-sapply(alldata,sd)

# Q3.  Assign the activity names to an object

activitynames<-features[,2]

# Q4.  Label the columns of the combined dataset w/ descriptive names
names(alldata)<-activitynames

# Q5. Do this same assignment for the averages object

names(datameans)<-activitynames

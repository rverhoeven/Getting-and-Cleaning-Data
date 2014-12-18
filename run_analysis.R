# Raymon Verhoeven
# Coursera - Getting and Cleaning Data
# Course Project
# December 2014

####################### Read data into R

# Train data
xtrain          <- read.table(file="./Coursera/Getting and Cleaning Data/Project/train/X_train.txt")
subjecttrain    <- read.table(file="./Coursera/Getting and Cleaning Data/Project/train/subject_train.txt")
ytrain          <- read.table(file="./Coursera/Getting and Cleaning Data/Project/train/y_train.txt")

# Test data
xtest           <- read.table(file="./Coursera/Getting and Cleaning Data/Project/test/X_test.txt")
subjecttest     <- read.table(file="./Coursera/Getting and Cleaning Data/Project/test/subject_test.txt")
ytest           <- read.table(file="./Coursera/Getting and Cleaning Data/Project/test/y_test.txt")

# Features and activity labels
features        <- read.table(file="./Coursera/Getting and Cleaning Data/Project/features.txt")
activitylabels  <- read.table(file="./Coursera/Getting and Cleaning Data/Project/activity_labels.txt")

##################### Include column names 

colnames(xtrain)        <- features[,2]
colnames(xtest)         <- features[,2]
colnames(subjecttrain)  <- "subject"
colnames(subjecttest)   <- "subject"
colnames(ytrain)        <- "y"
colnames(ytest)         <- "y"
colnames(activitylabels)<- c("label","activity")

##################### Only keep columns with mean and std

meanxtrain              <- grep("mean",colnames(xtrain),value=TRUE)
stdxtrain               <- grep("std",colnames(xtrain),value=TRUE)
keepcolumsxtrain        <- c(meanxtrain,stdxtrain)

xtrainsubset            <- xtrain[,keepcolumsxtrain]

meanxtest               <- grep("mean",colnames(xtest),value=TRUE)
stdxtest                <- grep("std",colnames(xtest),value=TRUE)
keepcolumsxtest         <- c(meanxtest,stdxtest)

xtestsubset             <- xtest[,keepcolumsxtest]
        
##################### Combine data sets

# Combine all train data
traindata       <- cbind(subjecttrain,xtrainsubset,ytrain)
# Combine all test data
testdata        <- cbind(subjecttest,xtestsubset,ytest)

# combine train and test
trainandtest    <- rbind(traindata,testdata)

# Merge with activity labels and clean column names
complete                        <- merge(activitylabels,trainandtest,by.x="label",by.y="y")
complete                        <- complete[,-1]
colnames(complete)              <- gsub("-|\\()","",colnames(complete),)

############ Finally take mean value of all columns and write to txt file

Final           <- aggregate(complete,by=list(complete$activity,complete$subject),FUN=mean)
Final           <- Final[,c(-2,-3)]
names(Final)[1]   <- "activity" 
View(Final)

write.table(Final,file="./Coursera/Getting and Cleaning Data/Project/run_analysis.txt",row.names=FALSE)

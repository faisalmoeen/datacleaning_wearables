# Reading the features list
features<-read.table("./features.txt",header=FALSE,stringsAsFactors=FALSE)
# Reading activity labels
labels<-read.table("./activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)


# Reading the training data set
train<-read.table("./train/X_train.txt",header=FALSE,colClasses="numeric")
# Assinging feature names to the column names of the training dataset
names(train)<-features[,"V2"]
# Extracting the mean() & std() measures
train<-train[,grepl("mean()",names(train)) | grepl("std()",names(train))]
# Reading training activity index
trainActIndex<-read.table("./train/y_train.txt",header=FALSE,colClasses="integer")
# Converting tainining activity index to vector
trainActIndex<-trainActIndex[,"V1"]
# Adding activity index to training data
train$actIndex<-trainActIndex
# Reading subject ids
trainSubjects<-read.table("./train/subject_train.txt",header=FALSE,stringsAsFactors=FALSE)
# Adding subject ids to the training data
train$subj<-trainSubjects$V1


# Reading the test data set
test<-read.table("./test/X_test.txt",header=FALSE,colClasses="numeric")
# Assinging feature names to the column names of the test dataset
names(test)<-features[,"V2"]
# Extracting the mean() & std() measures
test<-test[,grepl("mean()",names(test)) | grepl("std()",names(test))]
# Reading test activity index
testActIndex<-read.table("./test/y_test.txt",header=FALSE,colClasses="integer")
# Converting tainining activity index to vector
testActIndex<-testActIndex[,"V1"]
# Adding activity index to training data
test$actIndex<-testActIndex
# Reading subject ids
testSubjects<-read.table("./test/subject_test.txt",header=FALSE,stringsAsFactors=FALSE)
# Adding subject ids to the training data
test$subj<-testSubjects$V1


# Merging test and training datasets
all<-rbind(train,test)

# Adding descriptive activity names
tidyData<-merge(x=all,y=labels,by.x="actIndex",by.y="V1",all=FALSE)
names(tidyData)[ncol(tidyData)]<-"activity"
# Removing the activity index column as we already have the descriptive activity label
tidyData<-tidyData[,names(tidyData)!="actindex"]

# Cleaning feature names to follow the rules
names(tidyData)<-tolower(names(tidyData))
names(tidyData)<-gsub("[\\(\\)-]","",names(tidyData))

# New Tidy Data with aggregation over subject and activity
tidyData2<-aggregate(tidyData[,1:(ncol(tidyData)-2)],by=list(activity=tidyData[,"activity"],subject=tidyData[,"subj"]),FUN=mean,)
write.table(x=tidyData2,file="tidydata.txt",append=FALSE)

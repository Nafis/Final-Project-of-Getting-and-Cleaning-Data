#Final projet of Getting and Cleaning data "Coursera"###############################################################################

#Objectif:
#1-Merges the training and the test sets to create one data set.
#2-Extracts only the measurements on the mean and standard deviation for each measurement.
#3-Uses descriptive activity names to name the activities in the data set
#4-Appropriately labels the data set with descriptive variable names.
#5-Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#####################################################################################################################################
library(dplyr)

 # to set the directory on the location of the files
 setwd("C:/Users/Pcs/Documents/R/galaxy/UCI HAR Dataset")
 
#############################################   Step 1  #############################################################################

###merging the datasets("test and train") and merge them

 ## "X_train.txt" and "X_test.txt" are the "training" set and the "test set".
 alltestfiles<-read.table("test/X_test.txt")
 alltrainfiles<-read.table("train/X_train.txt")
 
 #now merging them together
 merged.set<-rbind(alltestfiles,alltrainfiles)
 
 #deleting the extra files
 rm(alltrainfiles)
 rm(alltestfiles)
 
 
 
 
################################### Step 2 #####################################################################################
 
 #reading features file 
 features<-read.table("features.txt",stringsAsFactors = FALSE)

 #View(features)
 #we just need the names colomn
 features<-features$V2
 
 #keep just the variables that their names include "std" and "mean" but not includes "Frequency"
 wewantthem<-grep("(std|mean[^F])",features)
 wanted.data<-merged.set[,wewantthem]
 #naming the dataset
 names(wanted.data)<-features[wewantthem]
 #we don't need the paranthesis in the names ( forexample: mean()----->mean )
 names(wanted.data) <- gsub("\\)|\\(", "", names(wanted.data))

 
######################################################## step 3 ############################################################ 
 
 ####reading the activity's file:
 activity.label<-read.table("activity_labels.txt",header=FALSE)
 # to view the activities: 
 # View(activity)
 
 # readinf all data (about the activities) type and merge them
 y_test<-read.table("test/y_test.txt",header = FALSE)
 y_train<-read.table("train/y_train.txt",header = FALSE)
 activities<-rbind(y_test,y_train)
 
 # Now give them  lables
 activities[,2]<-activity.label[activities[,1],2]
 names(activities)<-c("activitiy_label","activitiy")  

 
####################################### step 4 ######################################################################################## 
 
 testsubject<-read.table("test/subject_test.txt")
 trainsubject<-read.table("train/subject_train.txt")
 
 #combining them
 id<-rbind(testsubject,trainsubject)
 names(id)<-c("id")
 
 #again deleting the extra variables
 rm(trainsubject)
 rm(testsubject)
 



 # our data is near to be tidy now....
 data<-cbind(id,activities,wanted.data)
 
##############################################  step 5   #####################################################################
         
 
# final.data without "activity_label" column for calculation the mean of other columns
 final.data<-data[,names(data)!="activity_label"]
 tidy.data<-aggregate(final.data[,names(final.data)!=c("id","activity")],by=list(id=final.data$id,Activity=final.data$activitiy),mean)

#create a new data set and save it 
 write.table(tidy.data,file = "tidy_data.txt",row.names=TRUE,sep='\t')

library(dplyr)

##Set WD and read files
wd<-setwd("~/Desktop/UCI HAR Dataset/train")
y_train<-read.table("y_train.txt")
X_train<-read.table("X_train.txt")
subject_train<- read.table("subject_train.txt")

wd2<-setwd("~/Desktop/UCI HAR Dataset/test")
y_test<-read.table("y_test.txt")
X_test<-read.table("X_test.txt")
subject_test<- read.table("subject_test.txt")

wd3<-setwd("~/Desktop/UCI HAR Dataset")
names<-read.table("features.txt")
names<-t(names[,-1])
activity_labels<-read.table("activity_labels.txt")

subject_data<- rbind(subject_train, subject_test, na.rm=T) 
colnames(subject_data)<-"Subject"

#Bind, rename datasets and select for those with "mean" and "STD"
xbind<- rbind(X_train, X_test, na.rm=T)
colnames(xbind)<-names
Mean_STD<-grep("mean|std", names, value = TRUE)
xbind<- xbind[Mean_STD]

ybind<-rbind(y_train, y_test, na.rm=T)
ybind[, 1] <- activity_labels[ybind[, 1], 2]
names(ybind)<-"Activity"

Final_merged<-cbind(ybind, subject_data,xbind)

#Create an independent tidy data set with the average of each variable for each activity and each subject.
Final_merged_averages<- Final_merged %>% group_by(Activity, Subject) %>% summarise_all(funs(mean))
write.table(Final_merged_averages, "Final_Tidy_Mean_Data.txt", row.name=FALSE)



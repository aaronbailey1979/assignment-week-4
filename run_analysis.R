################# 1) Merging training and testing data set

# downloaded all pertinent data from the zip file UNZIPPED
# in my working directory. 
# numerically coded activity levels for the data

X_test <- read.table("UCI HAR Dataset/test/X_test.txt",sep="")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt",sep="")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt",sep="")
train_labels <- read.table("UCI HAR Dataset/train/y_train.txt",sep="")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",sep="")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",sep="")
var_names <- read.table("UCI HAR Dataset/features.txt",sep="")
act_levels <- read.table("UCI HAR Dataset/activity_labels.txt",sep="")

# adjoining activity levels to testing and training data

test_join = cbind(subject_test,test_labels,X_test)
train_join = cbind(subject_train,train_labels,X_train)

# merging training and testing data

X_merged <- rbind(test_join,train_join)

# renaming variables in merged data set

colnames(X_merged) <- c("subject","activity_level",var_names[,2])
column_names <-colnames(X_merged)

################## 2) Extracting only the measurements
################## for mean and std dev, leaving activity
################## level

dont_want <- grep("meanFreq",column_names)
total <- c(1:2,grep("mean|std",column_names))
X_merged <- X_merged[,setdiff(total, dont_want)]
column_names <- colnames(X_merged)

################## 3) In X_merged, converting
################## numerically-code activity levels
################## to language

# converting numerical activity levels to words in merged
# data set

for (k in 1:length(X_merged[,2])){
  for (j in 1:length(act_levels[,2])){
    if(X_merged[k,2] == j){
      X_merged[k,2] = act_levels[j,2]
    }
  }
}

################## 4) The variables have been given
################## descriptive names in the process
################## of selecting the variables that
################## are the result of mean calculations.

################## 5) From the data set in step 4, we
################# create a second, independent tidy
################# data set with the average of each
################# variable for each activity and each subject.

library(dplyr)
cut_down <- group_by(X_merged,subject,activity_level)
final_table <- summarise(cut_down, across(everything(), mean))
final_table <- setNames(final_table,paste0('mean_of_', names(final_table)))
final_table <- rename(final_table, "subject" = "mean_of_subject")
final_table <- rename(final_table, "activity_level" = "mean_of_activity_level")
rm(act_levels)
rm(cut_down)
rm(subject_test)
rm(subject_train)
rm(test_join)
rm(test_labels)
rm(train_join)
rm(train_labels)
rm(var_names)
rm(X_merged)
rm(X_test)
rm(X_train)
rm(column_names)
rm(dont_want)
rm(j)
rm(k)
rm(total)
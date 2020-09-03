library(dplyr)

#Download data and unzip

if (!file.exists('./data')) {dir.create('./data')}

file_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(file_url, destfile = 'data.zip', method = 'curl')

unzip(zipfile = 'data.zip', exdir = './data')
path <- file.path('./data', 'UCI HAR Dataset')
allfiles <- list.files(path, recursive = TRUE)

#1. Read data from the training and the test sets and merge

ytest  <- read.table(file.path(path, "test" , "y_test.txt" ),header = FALSE)
ytrain <- read.table(file.path(path, "train", "y_train.txt"),header = FALSE)
subjtest  <- read.table(file.path(path, "test" , "subject_test.txt" ),header = FALSE)
subjtrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
xtest  <- read.table(file.path(path, "test" , "x_test.txt" ),header = FALSE)
xtrain <- read.table(file.path(path, "train", "x_train.txt"),header = FALSE)

xdat <-rbind(xtrain, xtest)
ydat <-rbind(ytrain, ytest)
subjdat <- rbind(subjtrain, subjtest)

# Reading feature vector to assign to x names
features <- read.table(file.path(path,'features.txt'), header = F)

#Assign names
names(subjdat) <- 'subject'
names(ydat) <- 'activity'
names(xdat) <- features[,2]

#Merge data
dat <- cbind(subjdat, ydat, xdat)

#2. Extracts only the measurements on the mean and standard deviation for each measurement
# Extract feature names with mean or std

subfeatures <- features$V2[grep('mean\\(\\)|std\\(\\)', features$V2)] #Select features with mean() and std() in names
dat <- select(dat, subject, activity, all_of(subfeatures))

#3. Uses descriptive activity names to name the activities in the data set

# Reading activity labels
actlabels <- read.table(file.path(path,'activity_labels.txt'), header = F)

#Use descriptive names in activity.txt to name the activities in the data set
dat <- mutate(dat, activity = factor(activity, labels = actlabels$V2))

#4. Appropriately labels the data set with descriptive variable names
# Change variable names:
#t -> Time, Acc -> accelerometer, Gyro -> Gyroscope, Mag -> Magnitude, BodyBody -> Body
#-mean() ->Mean, -std() -> Std, -freq -> Frequency


names(dat)<-gsub("Acc", "Accelerometer", names(dat))
names(dat)<-gsub("Gyro", "Gyroscope", names(dat))
names(dat)<-gsub("BodyBody", "Body", names(dat))
names(dat)<-gsub("Mag", "Magnitude", names(dat))
names(dat)<-gsub("^t", "Time", names(dat))
names(dat)<-gsub("^f", "Frequency", names(dat))
names(dat)<-gsub("tBody", "TimeBody", names(dat))
names(dat)<-gsub("-mean\\(\\)", "Mean", names(dat), ignore.case = TRUE)
names(dat)<-gsub("-std\\(\\)", "STD", names(dat), ignore.case = TRUE)
names(dat)<-gsub("-freq\\(\\)", "Frequency", names(dat), ignore.case = TRUE)
names(dat)<-gsub("angle", "Angle", names(dat))
names(dat)<-gsub("gravity", "Gravity", names(dat))


#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dat2<-dat%>%group_by(subject, activity)%>%summarise_all(mean)

write.table(dat2, file = 'tidydata.txt', row.names = FALSE) 




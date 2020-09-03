# Getting-and-Cleaning-Data-Course-Project

The R program run_analysis.R first downloads the data to the sub-director "data" in the working directory and then does the following steps to create a tidy data set for analysis: 

1. Read data from the training and the test sets and merge into one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The final data set is named "tidydata.txt"
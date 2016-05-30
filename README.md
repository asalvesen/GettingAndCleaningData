# GettingAndCleaningData

##What you'll get out of run_analysis.R:

1. You'll get a data frame called "all". "all" combines the test and training
 data for the mean and std variables, as well as the subject and activity. It is  sorted by the subject ID. This satisfies these four requirements:
  * Merges the training and the test sets to create one data set.
  * Extracts only the measurements on the mean and standard deviation for each measurement.
  * Uses descriptive activity names to name the activities in the data set
  * Appropriately labels the data set with descriptive variable names.

2. You'll get a data frame called "as\_means". "as\_means" contains the
 average of each variable for each activity and each subject. This satisfies the final requirement:
  * Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##How to run this script:
1. Download the data from the original source provided in the code book.
2. Set your working directory to the parent folder where the folder 
 "UCI HAR Dataset" is now stored.
3. Run "run\_analysis". The script should install the data.table package for you.
4. The final versions of "all" and "as_means" will appear in your viewer window.

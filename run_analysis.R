library(data.table)

# READ IN FILES
# Note: Step 4: LABEL WITH DESCRIPTIVE VARIABLE NAMES is accomplished in this
#       section with the col.names argument of fread.

# features (for column labels):
features <- fread("./UCI HAR Dataset/features.txt")
features <- features$V2

# activity labels:
activity_labels <- fread("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- activity_labels$V2

# test data:
subject_test <- fread("./UCI HAR Dataset/test/subject_test.txt",
                      col.names = "Subject")
X_test <- fread("./UCI HAR Dataset/test/X_test.txt", col.names = features)
y_test <- fread("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")

# train data:
subject_train <- fread("./UCI HAR Dataset/train/subject_train.txt",
                       col.names = "Subject")
X_train <- fread("./UCI HAR Dataset/train/X_train.txt",
                 col.names = features)
y_train <- fread("./UCI HAR Dataset/train/y_train.txt",
                 col.names = "Activity")

# Step 2. EXTRACT ONLY MEAN AND STANDARD DEVIATION VARIABLES
extracted <- grep("mean|std", features, value = TRUE)
extracted2 <- grep("Freq", extracted, value = TRUE, invert = TRUE)
extracted_test <- subset(X_test, select = extracted2)
extracted_train <- subset(X_train, select = extracted2)

# Step 1. MERGE DATA
all_test <- cbind(subject_test, y_test, extracted_test)
all_train <- cbind(subject_train, y_train, extracted_train)
all <- rbind(all_test, all_train)
setkey(all, "Subject")

# Step 3: DESCRIPTIVE ACTIVITY NAMES
## This note is for me, graders can ignore it. This next bit of code says,
## go look at the numbers in the Activity column of all, and then go find that
## number in the activity_labels vector, then apply that value back to the
## Activty column. Here it goes, step by step:

# activity_labels[2]
# [1] "WALKING_UPSTAIRS"

# activity_labels[1:6]
# [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS"
# [4] "SITTING"            "STANDING"           "LAYING"    

# head(activity_labels[all$Activity])
# [1] "STANDING" "STANDING" "STANDING" "STANDING" "STANDING" "STANDING"

# activity_labels[2]
# [1] "WALKING_UPSTAIRS"
# activity_labels[1:6]
# [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS"
# [4] "SITTING"            "STANDING"           "LAYING"      

# head(all$Activity)
# [1] 5 5 5 5 5 5

# head(activity_labels[all$Activity])
# [1] "STANDING" "STANDING" "STANDING" "STANDING" "STANDING" "STANDING"

all$Activity <- activity_labels[all$Activity]

# Step 5: CREATE SECOND DATA SET WITH AVERAGES
melted <- melt(all, id = c("Subject", "Activity"), measure.vars = extracted2)

## Another note for me! Pay attention to how this code melts on two LHS
## variables. Took me forever to figure that out...
# ?dcast
# The cast formula takes the form LHS ~ RHS, ex: var1 + var2 ~ var3. The order of
# entries in the formula is essential. 

as_means <- dcast(melted, Subject + Activity ~ variable, mean)

## You could also do this with split, but I didn't fully figure that one out
## because I remembered the way more efficicient dcast.
## Would look something like:

# by_subject <- split(all, all$Subject)
# lapply (by_subject, function(x) {
#         mean(by_subject$`1`$`fBodyBodyGyroJerkMag-std()`)
# })
# then unlist it out

write.table(as_means, file = "./UCI HAR Dataset/tidy_data.txt",
            row.names = FALSE)

View(all)
View(as_means)

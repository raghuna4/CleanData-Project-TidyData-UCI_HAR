###################################################################################
## Coursera - Data Science Specialization : Course 3 - Getting and Cleaning Data ##
##                                Course Project                                 ##
###################################################################################
##                                                                               ##
##                       Tidy the dataset UCI HAR Data set                       ##
##                                                                               ##
###################################################################################
## The Following script 
##  1.  Reads & merges the Training and the Test data sets into one
##  2.  Extracts only the mean and SD of each measurements
##  3.  Uses descriptive activity names to name the activities in the dataset
##  4.  Renames the data set with suitable descriptive names
##  5.  From the dataset from 4., create independent data set with averages : Saved
##        as a dataframe named "summarized.data"
###################################################################################
##      Note on working directory. Save this run_analysis.R file in the folder
##  that contains the zip file downloaded from the UCI Machine Learning repo, or
##  the unzipped folder from the zip file exists. All references shall be made as 
##  "./<Unzipped>/.../"
###################################################################################

## Use dplyr packages. Ensure it is installed properly before loading
library(dplyr)

## Check the current working directory and assign it to a variable for further
## reference/use
workdir <- getwd()

## Set the data directory name in the environment
data.directory.name <- 'UCI HAR Dataset'

clean_varname <- function (var) {
  ## A method which Appropriately labels the data set with descriptive variable names.  
  ## Tidies up variable names by removing special characters, removing duplicate words, 
  ##   and expanding the prefixes
  ## Suitably hyphenate or add periods for long variable names to make them readable. 
  ##    - Make the name lowercase, but separate the components with periods.
  ## Arguments:
  ##   var: string containing the original variable name
  ##
  ## Returns:
  ##   A string containing the cleaned variable name
  
  # Remove parentheses and hyphens
  var <- gsub('[(]', '', var)
  var <- gsub('[)]', '', var)
  var <- gsub('[-]', '.', var)

  ## Add a human-readable prefix by converting 't' to 'time' and 'f' to 'frequency'
  prefix <- 'time'
  if (substr(var, 1, 1) == 'f') {
    prefix <- 'frequency'    
  }
  
  ## Remove the first character, since we're replacing it with the prefix
  var <- substring(var, 2)
  
  ## Cleanup double Body variable names
  var <- gsub("BodyBody", "Body", var)
  
  ## Also add the string 'mean' to the var because the final data set calculates
  ##    the mean of each variable
  return(paste('mean', prefix, tolower(var), sep = '.'))
}

LoadDataSet <- function (set) {
  ## Loads the train or test data sets from the disk into a data.frame; 
  ##      filters and names the columns as required
  ##
  ## Arguments:
  ##   set: string equal to 'train' or 'test'
  ##
  ## Returns:
  ##   data : A data.frame
  
  ## Set the base path based on the data set we are loading
  path = file.path(getwd(), data.directory.name, set)
  
  ## Load data from the disk
  subjects <- read.table(file.path(path, paste('subject_', set, '.txt', sep = '')))
  activities <- read.table(file.path(path, paste('y_', set, '.txt', sep = '')))
  metrics <- read.table(file.path(path, paste('X_', set, '.txt', sep = '')))
  
  ## Appropriately labels the data set with descriptive variable names. 
  metric.labels <- sapply(metric.labels, clean_varname)
  names(metrics) <- metric.labels
  
  ## Extracts only the measurements on the mean and standard deviation for each measurement. 
  columnIndexes = sapply(metric.labels, function(colname){ grepl(colname,  pattern = "\\.std") | (grepl(colname,  pattern = "\\.mean") & !grepl(colname,  pattern = "\\.meanfreq")) })
  metrics <- metrics[, columnIndexes]
  
  ## Bind together subject, activities and metrics in that order, in 2 steps
  data <- cbind(subjects, activities)
  names(data) <- c('subject', 'activity')
  data <- cbind(data, metrics)
  
  ## Release unnecessary variables to free up memory
  remove(activities)
  remove(metrics)
  remove(subjects)
  
  ## Return the "Tidy" data set
  data
}

## Load labels from disk
metric.labels <- read.table(file.path(getwd(), data.directory.name, 'features.txt'))[, 2]
activity.labels <- as.character(read.table(file.path(getwd(), data.directory.name, 'activity_labels.txt'))[, 2])

## Merges the training and the test sets to create one data set.
data <- rbind(LoadDataSet('train'), LoadDataSet('test'))

# Uses descriptive activity names to name the activities in the data set 
# Sort by activity so we can factor activities and apply the labels given in the dataset
data <- data[order(data[,2]), ]
data[,2] <- factor(data[,2], labels = activity.labels)

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summarized.data <- group_by(data, subject, activity) %>% summarise_each(funs(mean))

## Output data to disk in fulfillment of: upload your data set as a txt file created with write.table() using row.name=FALSE
write.table(summarized.data, row.name=FALSE, file='./tidyDataSet.txt')
message('Success')
message('Tidy data set in the dataframe "data" in the workspace')
message('Summarized mean data in the dataframe "summarized.data" in the workspace')
message('Tidy dataset saved as "tidyDataSet.txt" in the working directory')


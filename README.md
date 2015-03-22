# CleanData-Project-TidyData-UCI_HAR
Coursera Getting and Cleaning Data course project on tidying up data from UCI HAR dataset on study of Human Activity Recognition Using Smartphones
# Tidy Data Analysis of "Human Activity Recognition Using Smartphones"

This data set is a tidy subset of the ["Human Activity Recognition Using Smartphones" data set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). (Downloadable [here] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) )

### Reference
> [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

> This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

> Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

### The dataset includes the following files
* [**tidyDataSet.txt**:] (https://github.com/raghuna4/CleanData-Project-TidyData-UCI_HAR/blob/master/tidyDataSet.txt) 
    * The tidy subset of the UCI HAR data set. Provided for convenience. It can by exactly reproduced by running the run_analysis.R script.
* [**CodeBook.md**:] (https://github.com/raghuna4/CleanData-Project-TidyData-UCI_HAR/blob/master/CodeBook.md)
    * Information about all columns in the current Tidy data set including portions of the original code book and a full description of the present tidy-up transformation and summary of the original data set that is  reproduced in the tidy data set.
* **README.md**: 
    * This document which explains what the analysis file does. 
* [**run_analysis.R**:] (https://github.com/raghuna4/CleanData-Project-TidyData-UCI_HAR/blob/master/run_analysis.R) 
    * Source code in R for the transformation of the UCI HAR data set into the present tidy data set.

### The instruction list - R script details
* The only input to the **run_analysis.R** script is the UCI HAR data set which must be in the working directory. The script requires no arguments/parameters.
* The output from the script is the tidy data set saved in the file "tidyDataSet.txt"
* The tasks required for this analysis are fully scripted in R. The user is expected to get the final output by sourcing the script file and running it. The steps followed in the script:
    * Recombine the UCI data set in memory
        * Load the subject_\*.txt, y_\*.txt, X_\*.txt files.
      * Column bind the two data frames together.
    	* Name the columns using the names from features.txt.
    	* Factor the activities column and name the factors using values loaded from activity_labels.txt
    	* Repeat these steps for both the train and test data sets.
    	* Row bind the two data sets.
    	* The original data set loaded and bound into one.
    * Tidy up the column names
        * Rename all column names using these rules
        	* Replace prefixes 't' and 'f' with 'time' and 'frequency' respectively.
        	* Remove illegal characters and hyphens.
            * Remove duplicate phrases in variable names. eg. 'BodyBody' becomes 'Body'
            * Convert names to lower case
        	* Prefix the column name with 'mean' (See the codebook's 'Summarizing the data' section)
    * Remove some columns as required for this task
    	* Remove all columns where the original name does not contain -std or -mean including those containing "meanFreq" and those beginning with "angle." 
    	* The subject and activity columns are retained as reference columns to match the data.
    * Summarize the data
    	* Group by subject and activity
        * Calculate the mean for each metric.
    * Output
    	* Save the data.frame to disk
    * Note
        * The script assumes the dataset is saved as a folder with original unzipped name from the repository's zip file in the  working directory and also assumes appropriate version of dplyr package is installed and loadable from the R environment of the user.

### Reading the data
Read the tidy data set in R with the following command. First ensure the working directory contains the tidyDataSet.txt file.

```R
read.table('./tidyDataSet.txt', header = TRUE)
```

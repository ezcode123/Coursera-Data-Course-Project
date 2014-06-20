Coursera-Data-Course-Project
============================

Coursera course "Getting and Cleaning Data" Course Project Submission

## Description

This is a submission for the Coursera course "Getting and Cleaning Data" Course Project.  

The assignment involves reading in two files that contain accelerometer and gyroscope data taken from human sujects wearing a wearing a smartphone (Samsung Galaxy S II) on the waist, while each performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). The measurements are divided into test data and training data.  The two files of the raw data are combined, columns detailing the subject number and activity are appended, the variables are limited to a subset, averages of each of the variables are calculated, and a txt file is written out.

## Code

The file run_analysis.R contains all the code needed to perform the analysis detailed above.  The code does the following:

* Download the zipped data from the internet, unzip it, and create two dataframes, testdata and traindata, from the X_test.txt and X_train.txt files.  These are raw data files and contain no variable names or variables that describe each observation.  That information is stored in other files which are to be read into R.
* Combine the two dataframes into a new dataframe, combineddata.
* Variable names are then read in from features.txt into a dataframe called variables.  We are asked to keep only the measurements on the mean and standard deviation for each measurement.  I took this to mean that we should only include those variables with mean() and std() included within the variable name.  In order to select the variables to keep, the variable names are searched for the strings "mean()" or "std()" through a grep command and the resulting variables are stored in a dataframe called keepvar.
* Using the extracted reduced set of variable names, the columns are now selected from combineddata and a new dataframe, trimdata, is made.
* The suject numbers and activity numbers are then read into R from subject_test.txt/subject_train.txt and y_test.txt/y_train.txt, respectively .  These have to be appended together, since they are stored separately for the test and training datasets.  They are then added to the trimdata dataframe as two new variables, Subject and activityno.
* The key that can convert the activity number to a descriptive phrase is then read in, activity_labels.txt.  After changing the variable names, this dataframe is merged with trimdata to form a new dataframe, alldata.
* The variable names within the keepvar dataframe are then cleaned up to remove special characters such as () and -.  In addition, an additional variable V3 is created in keepvar with appends the original index number of the variable to the character V.  V3 is then used to update the variable name in the alldata dataframe.
* The dataframe is then reshaped to a long dataframe such that all the values are in a single column, with one entry for each original Subject, Activity, and Variable.  An aggregate command then summarizes the means of the data by Subject, Activity, and Variable, in a dataframe called datasum.  This dataframe is then transformed back into a wide format using a reshape command, forming the widemean dataframe.
* The widemean dataframe is then written out using a write.table command.

## Output

The results of running the code are the file tidy_data.txt.  This can be read into excel using a space as the delimitor.  Each row gives the means of each of the original mean and std variables, by Subject and Activity.  The original data had a variable number of replicates for each subject and activity.
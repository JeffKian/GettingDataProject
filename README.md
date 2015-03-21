# GettingDataProject
Repository that stores code for the Coursera Getting Data R Project
21-Mar-2015 - JK
This project contains a R script file  Run analysis.R script used for merging and tidying data for the coursera project assignment
It also contains a code book providing a description of each of the variables that are used or created

The script consists of 7 major sections

## Configure the environment
This section
Sets the working directory
Sets the path variables so that we can call variables instead of writing the full path when caling functions
Sources the packages that will be used (sqldf;dplyr)



## Source the required data
This section reads data into the environment
It populates local variables with the data read in from the source data
It uses the patch variables to locate the relevant source data files
Important things to note is that each meausurements file does not have any column headings in the source data file
These columns will be read in separately and assigned to the measurements file later


## Create a function that tidies up the test and train files
The function parameters requires:
A directory (test /  train)
The measure file name (test / train)
The activity file namethat has an acivitiyID and type of activity description 
Measure Column headings, subject IDs and acitvity descriptions have all been read into global variables in the source data step

Function key steps
Rename the measurement file column headings
Creates a column names variable that is a vector based on the act_features data table
Renames the columns in X_measurement data frame to their descriptive names from act_features using the col_names variable

Select Mean and std columns
In this new data frame only selects columns that have the words 'mean' or 'standard' in them  and store the result in a data frame 
Creates a new dataframe that only has these measure columns in them

Append the subjectID and activityID as a columns onto the measurement data set
Rename the appended columns to subjectID and activityId respectively they should be in column positions 87 and 88

Use the actvitiy ID to join tothe activity description data frame an return the activity description
Rename to columns in act_features so that you can join by column name
Join and merge the acticity description into the dataset

Create a flag indicating where the data originated (Test /Train)
Append this flag as a column onto the data set

Output the result file
If the input data file is from test data then output a dataframe called testoutfile
If the input data file is from train data then output a dataframe called trainoutfile

## end function


## Call the function for the test and train data set
Call the function for the test data set
Call the function for the train data set

## Merge the test and train files into a single data set

## You now have a tidy data set that has relevant factor variables describing each record
## These include subjectID, Activity Description and a datasetflag indicating where the data came from
## The test and train data sets have been merged but there is an indicator showing where the data came from

## Calculate the Mean forall variable columns and Group by subject ID,activity description and data set flag 
Create a column index variable that has indexes the measurement columns

Calculate the mean of the each of the variable columns using the column index vector
Group the results by the subjectID, Activity description and the dataset it came from 

## Write the data to a new data frame called filemean
## Export the filemean data frame to a text file using write.table function 

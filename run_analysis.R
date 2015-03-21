## This is the Run analysis.R script used for merging and tidying data for the coursera project assignment
## Set the working directory to your working directory

## 01. Configure the environment

setwd("C:/Users/jeffk_000/Dropbox/Work Files/BI/Information Management/07. Data Scientist Toolbox/03. Getting Data/Project/UCI HAR Dataset")

## specify the path variables to the test and train directories

testdir<-"C:/Users/jeffk_000/Dropbox/Work Files/BI/Information Management/07. Data Scientist Toolbox/03. Getting Data/Project/UCI HAR Dataset/test"
traindir<-"C:/Users/jeffk_000/Dropbox/Work Files/BI/Information Management/07. Data Scientist Toolbox/03. Getting Data/Project/UCI HAR Dataset/train"
subject_test_file<-"subject_test.txt"
subject_train_file<-"subject_train.txt"
xtest<-"X_test.txt"
ytestact<-"y_test.txt"
xtrain<-"X_train.txt"
ytrainact<-"y_train.txt"

## source the libraries you need

library(sqldf)
library(dplyr)



## 02. Source the required data

## Read  global / common data files
## Read in the activity features file this will eventually become the column headings for the measurements file. Read it in as a 2 column table
act_features<-read.table("features.txt")

## Read in the activity labels file this will eventually join to the activity label codes found in the y_test.txt and y_train.txt files indicating what activity each observation is related to

act_labels<-read.table("activity_labels.txt")

## 03. Create a function that tidies up the test and train files

cleanupdata<-function(directory,subjectfile,measurefile,activityfile){

## Read in the subject.txt file which indicates to which subject each observation pertains

subject<-read.table(file.path(directory,subjectfile))

## Read in the observed measurements from the X_measurestype.txt file.(measures type will either be test or train)
## depending on what measure file is passed to the function

xmeasure<-read.table(file.path(directory,measurefile))

## Read in the activity flag from the y_actvitytype.txt file that indicates what activity the subject was doing when the measurement was taken

yact<-read.table(file.path(directory,activityfile))

##Create a column names variable that is a vector based on the act_features data table

col_names<-act_features[[2]]

## Rename the columns in X_measuretype.txt to their descriptive names from act_features using the col_names variable

colnames(xmeasure)<-col_names

## Create a data frame that contains the act_features (column header) and the index of the position of that column in x_test
col_index<-data.frame(act_features)

## Use sqldef to select only the rows that have the words 'mean' or 'standard' in them  and store the result in a data frame 
act_feat_filtered<- sqldf("select * from col_index where V2 like '%mean%' or V2 like '%std%'")

## Store the relevant column indexes in a variable called correct_cols
correct_cols<-act_feat_filtered[[1]]

## Use the filtered col index correct_cols to select the from x_test that only relate to std or mean.  Select all rows and only those cols that relate to mean or std
xmeasure2<-xmeasure[,correct_cols]

## Use the subject_test variable to assign the subject ID to each observation
## Column bind the subject_ID and the activity indicator onto the X_test and create new data frame
xmeasure3<-(cbind(xmeasure2,subject,yact))

## rename the appended columns to subjectID and activityId respectively they should be in column positions 87 and 88

colnames(xmeasure3)[87] <- "subjectID"
colnames(xmeasure3)[88] <- "activityID"

## Rename to columns in act_features so that you can join by column name
## create another col_names vector that holds the column descriptions for the activity ID and activity description 
col_names2<-cbind("activityID","activity_desc")

## Rename the columns in the activity)labels data frame to have descriptions and so that the activityID column can be joined in to x_test3

colnames(act_labels)<-col_names2

## Do an inner join from x_test3 to act_labels using the activityID as they key to get the activity labels into a single data set use the merge function

xmeasure4<-merge(xmeasure3,act_labels,by="activityID")

## Next we need a column indicating where this data set originated

## First get the no of rows in the measurement data set
rowsdataset<-nrow(xmeasure4)

##create a vector that indicates the data set (test) and repeat it for the number of rows in the dataset  

## if the data is from the test data set then create flag called test Train and output a dataframe called testoutfile
if (measurefile=="X_test.txt"){
  datasetflag<-rep("Test",rowsdataset)
testmeasure<-cbind(xmeasure4,datasetflag)
testoutfile<<-testmeasure
}

## if the data is from the test data set then create flag called Train and output a dataframe called trainoutfile

if (measurefile=="X_train.txt"){
  datasetflag<-rep("Train",rowsdataset)
  testmeasure<-cbind(xmeasure4,datasetflag)
  trainoutfile<<-testmeasure
}

}

## end function



## 04. Call the function for the test data set
cleanupdata(testdir,subject_test_file,xtest,ytestact)

## This creates a dataframe for the test data set with subset of columns
## and factor variable indicators for ubjectID, Activity Description and a datasetflag 

## 05. Call the function of the train data set
cleanupdata(traindir,subject_train_file,xtrain,ytrainact)

## This creates a dataframe for the train data set with subset of columns
## and factor variable indicators for ubjectID, Activity Description and a datasetflag 

## 06. Merge the test and train files into a single data set

masterfile<-rbind(testoutfile,trainoutfile)

## You now have a tidy data set that has relevant factor variables describing each record
## These include subjectID, Activity Description and a datasetflag indicating where the data came from
## The test and train data sets have been merged but there is an indicator showing where the data came from

## 07. Calculate the Mean forall variable columns and Group by subject ID,activity description and data set flag 

##The columns that have the measurement variables are 2:87 in the master file data set, create an index vector that identifies these columns

cols<-2:87

## Calculate the mean of the each of the variable columns using the column index vector
## Group the results by the subjectID, Activity description and the dataset it came from 
## write the data to a new data frame called filemean

filemean<-aggregate(masterfile[cols],list(subjectID=masterfile$subjectID,activity_desc=masterfile$activity_desc,datasetflag=masterfile$datasetflag),mean)

## 08. Export the filemean data frame to a text file using write.table function 

write.table(filemean,"Filemean.csv",sep=",",row.names=FALSE)



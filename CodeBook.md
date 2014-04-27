Code Book for run_analysis.R script
==================================

The data set needed for this analysis is contained in a "data" folder.
The code is commented and does the following operations:

### 1. Merge training and test sets
   * read training data from original ".txt" files and create the variables:
        * X_train - Training set. 
         7352 training examples, each row is one observation, each of 561 columns is a variable. Detailed description of the data set and experiment is in the README.txt file in "data" directory.
        * subject_train - Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
        * y_train  - Training labels
        * features - all features names.
  * create one data set with complete training data 
  (by adding ids and labels, output is a "train" data frame with 563 columns)
  * read and bind test data in the same way: 
  output is a "test" data frame with 2947 rows and 563 columns
  * Combine "test" and "train" in one data frame ("all").
  * Create vector with features names and use it to column names to "all" data frame 
  * Remove all variables not needed for analysis any more, leave only "all" df.
        
### 2. Extracts only the measurements on the mean and standard deviation for each measurement.
* find column names containing "mean" or "std" in name 
* create variable "reduceddata" - data frame with columns selected above plus 2 variables (labels and subject ids):


```
selectcols <- grep("mean|std", names(all))
reduceddata <- all[,c(selectcols, 562, 563)]
```

 
### 3. Use descriptive activity names to name the activities in the data set
* extract activities names from original data set (from "data/activity_labels.txt")
* create a data frame ("activitylabels") with 2 columns: 
        "label" - id of an activity performed by subject 
        "activity" - descriptive name 
* merge data frames "reduceddata" and "activitylabels" 
The only common column for them is "labels". We can remove it after this opertaion. As a result "reduceddata" now contains 10299 rows and 81 columns - last 2 are "id" (subject id - integer between 1 and 30) and "activity" (descriptive name of one of 6 possible activities performed)   

### 4. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 
* use melt() and dcast() functions from "reshape2" package
* create molten data frame with melt() function, passing "id" and "activity" columns as id.vars and all remaining columns of "reduceddata" as measure.vars

```
meltdata <- melt(reduceddata, id.vars = c("id", "activity"), measure.vars =
names(reduceddata)[1:79])
```

* create clean data set ("tidydata") using dcast() function:

```
tidydata <- dcast(meltdata, id+activity ~ variable, mean)
```
        
* There are 180 rows: 30 subjects ("ids") x 6 activities for each person.
* There are 81 columns: "id", "actvity" and means for all 79 variables from original data set containing "mean" or "std" in thier name (extracted in step 2.)

* save "tidydata" as "cleandata.txt" in the working directory


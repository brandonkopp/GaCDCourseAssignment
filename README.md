# Getting and Cleaning Data Course Assignment
This repository contains code for completing a course assignment. Feel free to look at it and borrow from it, but it is not a functional piece of code you'll want to use.

###The Data
The dataset created by running the run_analysis.R script is a subset of a larger dataset collected when 30 participants participated in a range of physical activities while wearing a Samsung Galaxy S smartphone. The measures are summaries of data read from the smartphone's accelerometer and gyroscope.

###What This File Does
The run_analysis.R script downloads a multi-file dataset, combines those files into a single dataset, subsets and reorganizes the data, and provides meaningful lables for each of the activities and measurements listed in each row. The exact editing steps are in the next section and the code is also annotated.  

The final output of this script is a comma separated value text file with four variables and 11880 observations. An explanation of the four variables is outlined below.

###Data Editing Steps Performed By run_analysis.R
1. Download .zip and extract files 
2. Combine x, y, and subject test files into single dataset
    + Extract Test Variables
    + Assign variable names
    + Combine test files
    + Merge meaningful y-variable labels with dataset
    + Remove interim datasets from Global Environment
3. Combine x, y, and subject train files into single dataset
    + Extract Train Variables
    + Assign variable names
    + Combine train files
    + Merge meaningful y-variable labels with dataset
    + Remove interim datasets from Global Environment
4. Merge Test and Train datasets
    + Remove interim datasets from Global Environment
5. Subset the merged file so that it contains only varibles with mean and std
6. Give the variables meaninful labels by replacing abbreviations with full words
7. Create simplified dataset with one row per activity per person
    + Remove merged dataset from Global Environment
    + Sort dataset in ascending orderby person and activity
8. Reshape table so that each row consists of one mean observation for each activity for each person
9. Write simplified dataset to text file.
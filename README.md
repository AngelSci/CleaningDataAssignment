# CleaningDataAssignment
Final assignment materials for the Coursera Building and Cleaning Data Course.

The run_analysis.R code:

1. loads the raw Samsung data,
2. sets the field names from the activity type and features data,
3. merges the training and test data together,
4. merges the subject, activity, and device measurement data into a tidy dataset,
5. splits the tidy data into groups by activity, then aggrgates each subset dataset by the individual subject.
6. combines the aggregated data together to create a data table that summarizes the measurements by activity and individual subject,
7. cleans up the data,
8. saves the data to .txt files.

datacleaning_wearables
======================
#Raw Data
### Source
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
### Study design
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### Code Book
For each record it is provided:
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.
  The dataset includes the following files:
* 'README.txt'
* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

* 'train/subject_train.txt':  
 Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total_acc_x_train.txt':  
 The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body_acc_x_train.txt':  
 The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body_gyro_x_train.txt':  
 The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 
 
###Notes: 

* Features are normalized and bounded within [-1,1].
* Each feature vector is a row on the text file.


#Tidy Data
The script run_analysis.R takes the raw data as an input (raw data should be in the current working directory) and produces a cleaned data in a file named `tidyData.txt`

##Study Design
 The purpose of `run_analysis.R` script is to clean the raw data in a way that it is ready for doing data analysis on it. The original data is divided into test and training data-sets. For each kind of data-set, the data is further divided into multiple files i.e. feature names, data, labels etc. The script combines all different files into a single file. The script itself is well documented. There are 561 features in the original data and the data is based on numerous observations for 30 subjects. Instead of considering each observation for our analysis, we want to take the mean and standard deviation of the sensor signals. We want to see if mean and standard deviation of sensor signals are enough for classifying the final activity i.e. WALKING etc. In the following the transformation process is discussed.

##Transformation Process
First we read the files which contain the global information valid for both test and training data-sets i.e. `features.txt` and `activity_labels.txt` into data frames `features` and `labels` respectively. The first file contains the names of the features in test and training data-sets. The second file contains the information about which activity indexes belong to which activity labels.  
We read the training data-set and then assign feature names to it. Then we filter this data-set by keeping only those features which have "mean()" or "std()" in their names. These are the features which represent the mean ans standard deviation of sensor signals respectively. Then we read training activity indexes from a file `./train/y_train.txt` and add it as a column `actIndex` to the training data. The observations is the data are missing the `id` of the subject to which each observation belongs. We read this information from `./train/subject_train.txt` file and add it as a column `subj` to the training data.  
The same process is repeated for the test data-set. After this, we merge the two data-sets to make them one. After merging, the data is complete but does not contain any information about what activity does the activity index show. To add this information, we join the data with `labels` data frame. This adds the descriptive label information to the data. We call this feature as `activity`. Now we have the descriptive activity labels which means we don't need the activity indexes so we remove the `actIndex` feature from the data.  
We then clean the feature names. The feature names as is contain special characters like `()-.` etc. We put all feature names to lower case and remove special characters.  
To summarize the data to make it feasible for doing analysis, we aggregate the data based on subjects and activities. We have 30 subjects and 6 activities in total which lead to a clean data with `30*6=180` rows. The clean data is written to a file `tidydata.txt` in the current working directory.

##Code Book
The transformation process adds two new features to the data.
* `activity`: The activity the subject was doing when the reading was recorded.
* `subject`: The id of the person to which the observation belongs.  
The description of rest of the features is the same as the original data-set except that now the features are aggregated over `subject` and `activity`.


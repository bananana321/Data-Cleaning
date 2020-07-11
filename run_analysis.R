library(reshape2)
# make sure to set working directory in the file 'UCI HAR Dataset'

# get data from files
X_train = read.table("train/X_train.txt")
y_train = read.table("train/y_train.txt")
subject_train = read.table("train/subject_train.txt")
X_test = read.table("test/X_test.txt")
y_test = read.table("test/y_test.txt")
subject_test = read.table("test/subject_test.txt")
features = read.table("features.txt")
activity_labels = read.table("activity_labels.txt")

# combine the test and train dataset
X_data = rbind(X_train, X_test)
y_data = rbind(y_train, y_test)
subject_data = rbind(subject_train, subject_test)

# extract feature with relevant word
features_2ndCols = grep("-(mean|std).*", as.character(features[,2]))
features_2ndColsNames = features[features_2ndCols, 2]

# combine data
X_data = X_data[features_2ndCols]
allData = cbind(subject_data, y_data, X_data)

#assign column name
colnames(allData) = c("ids", "activity_labels", features_2ndColsNames)
allData$activity_labels = factor(allData$activity_labels, levels = activity_labels[,1], labels = activity_labels[,2])
allData$ids = as.factor(allData$ids)

meltedData = melt(allData, id = c("ids", "activity_labels"))
tidyData = dcast(meltedData, ids + activity_labels ~ variable, mean)
write.table(tidyData, "./tidy_data.txt", row.names = FALSE, quote = FALSE)

## This Script performance the Cleaning of the data 
## Retrieved from:
## You will obtain two tidy Data sets
## "dat_Total" = First tidy data set, contains all the mean and sd variables
## "new_data"  = Contains the average of each variable and activity  
x <- read.table("features.txt")	#Read the file with all the variable names
v_mean <- grep("mean",x[,2])	#Find the index with the word "mean"
v_std <- grep("std",x[,2])		#Find the index with the word "std"
v_total <-sort(c(v_mean,v_std)) #Merge and sort the index
files_list_test <- list.files("test", full.names = TRUE)#Read files in directory "test" and save them in variable "files_list_test"
	dat_Test <- read.table(files_list_test[3]) 			#Read "test/X_test.txt"and save the data in "dat_Test" 
	dat_Test <- dat_Test[,v_total] 						#Extract only the required data
	y_Test <- read.table(files_list_test[4]) 			#Read "y_test.txt" 
	y_Test <- y_Test[,1] 								#Save the data labels in "y_Test"
	dat_Test <- cbind(y_Test,dat_Test) 					#Merge data to obtain only one Test Data Set
	colnames(dat_Test) <- c("Activity",as.character(x[v_total,2])) #Add the variable names 
files_list_train <- list.files("train", full.names = TRUE)#Read files in directory "train" and save them in variable "files_list_train"
	dat_Train <- read.table(files_list_train[3])		#Read "test/X_train.txt"and save the data in "dat_Train"
	dat_Train <- dat_Train[,v_total]					#Extract only the required data
	y_Train <- read.table(files_list_train[4])			#Read "y_train.txt" 
	y_Train <- y_Train[,1]								#Save the data labels in "y_Train"
	dat_Train <- cbind(y_Train,dat_Train)				#Merge data to obtain only one Train Data Set
	colnames(dat_Train) <- c("Activity",as.character(x[v_total,2])) #Add the variable names 
dat_Total <- rbind(dat_Test,dat_Train) 					#Merge both data Sets
dat_Total$Activity <- gsub("1","WALKING",dat_Total$Activity) #Replace the number for the corresponding Activity
dat_Total$Activity <- gsub("2","WALKING_UPSTAIRS",dat_Total$Activity)
dat_Total$Activity <- gsub("3","WALKING_DOWNSTAIRS",dat_Total$Activity)
dat_Total$Activity <- gsub("4","SITTING",dat_Total$Activity)
dat_Total$Activity <- gsub("5","STANDING",dat_Total$Activity)
dat_Total$Activity <- gsub("6","LAYING",dat_Total$Activity)
dat_Total$Activity <- as.factor(dat_Total$Activity) #Convert Activities to factor
n <- ncol(dat_Total) 								#Obtain the number of columns
new_data <- data.frame(matrix(0,n,6)) 				#Make a data frame
for (i in 2:n){
	new_data[i,] <- tapply(dat_Total[,i],dat_Total[,1],mean) #Use "tapply" to obtain the mean for each column per Activity
}
new_data <- new_data[-1,]							#Remove the first row who has the Activities names and make the new tidy data set
colnames(new_data) <- c("WALKING_MEAN","WALKING_UPSTAIRS_MEAN","WALKING_DOWNSTAIRS_MEAN","SITTING_MEAN","STANDING_MEAN","LAYING_MEAN")#Add the Activities names
rownames(new_data) <- c(as.character(x[v_total,2]))		#Add the corresponding variable names

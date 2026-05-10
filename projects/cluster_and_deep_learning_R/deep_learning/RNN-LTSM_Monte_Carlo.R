
#
#
# Long Short-Term Memory Forecast Model with Monte Carlo Simulatin developed for CMA CGM - Created by Gustavo Oliveira
#
# Can be applied to Volume and Revenue data
#
#

set.seed(500)


library('gdata')
library('dplyr')
library(gtools)
library(rnn)
library(xlsx)

#Uploading the data - Each line can be changed to bring one set of data - this can be automated

#ForecastData <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/PACIFIC VOLUME FORECAST DATA.xlsx", sheet = "PACIFIC MGE CLSAI REEFER1"))#, row.names=NULL, stringsAsFactors= FALSE))
#ForecastData <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/PACIFIC VOLUME FORECAST DATA.xlsx", sheet = "PACIFIC MGE ECGYE DRY1"))#, row.names=NULL, stringsAsFactors= FALSE))
#ForecastData <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/PACIFIC VOLUME FORECAST DATA.xlsx", sheet = "PACIFIC MGE CLSAI DRY1"))#, row.names=NULL, stringsAsFactors= FALSE))
#ForecastData <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/PACIFIC VOLUME FORECAST DATA.xlsx", sheet = "NAM LAM CAGML USNYC DRY"))#, row.names=NULL, stringsAsFactors= FALSE))
ForecastData <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/PACIFIC VOLUME FORECAST DATA.xlsx", sheet = "NAM LAM CAGML USMIA DRY"))#, row.names=NULL, stringsAsFactors= FALSE))
#ForecastData <- data.frame(read.xls("/Users/Oliveiralgm/Downloads/PACIFIC VOLUME FORECAST DATA.xlsx", sheet = "PACIFIC MGE CLSAI REEFER1"))#, row.names=NULL, stringsAsFactors= FALSE))

#takes a look at the data
glimpse(ForecastData)

#Number of inputs for the Neural Network, can be changed
NumberofEntryData <- 8
#Number of outputs for the Neural Network - how many weeks ahead is to be forecasted.
NumberofPredictions <- 3

#Takes only the required data
NNCleanData <- data.frame(ForecastData[,2])
#Histograms the data so we can see how skewed is the distribution
hist(NNCleanData$ForecastData...2.)

#get rid of outliers - or not (Depends on how you want to treat the data - suggestion is to not delete the outliers)

outliers <- boxplot.stats(NNCleanData$ForecastData...2.)$out
outliers
#uncomment next line if you want to clean the data of outliers
#NNCleanData <- data.frame(lapply(NNCleanData, function(x) x[!x %in% outliers]))

#finding lags - this is an autocorrelation plot - shows the lags in the data which is used to identify seasonality
acf.results <- acf(NNCleanData, lag.max = 15, type = "correlation", plot = TRUE, na.action = na.pass)
plot(acf.results, main="Auto-correlation")
print(acf.results)


#Normalizing - Neural Networks train better if the data is between 0-1 - this is what we do here, later we need to convert the data back to original values
maxs <- apply(NNCleanData, 2, max)
mins <- apply(NNCleanData, 2, min)
scaled2NNData <- as.data.frame(scale(NNCleanData, center = mins, scale = maxs - mins))
hist(scaled2NNData)
#If you don't want to normalize the data, comment the 4 previous lines and uncomment the next line.  WARNING:: #**** NOT NORMALIZING DID NOT PREDICT WELL ****
#scaled2NNData <- NNCleanData 

#If the data is skewed we square root it to remove the skewness - there are many techiques to remove skeweness please check to see if this meets your data's needs
scaled2NNData <- sqrt(scaled2NNData)
Tscaled2NNData <- t(scaled2NNData)
hist(Tscaled2NNData)

#Initializes the variable NNDataEntry
NNDataEntry <- list()

#The next lines creates the data file in the format for the neural network - a sliding window of inputs and outputs.
for (i in 1:(nrow(ForecastData) - (NumberofEntryData + NumberofPredictions))) {
  
  NNDataEntry <- cbind(NNDataEntry, scaled2NNData[i:(i+NumberofEntryData + NumberofPredictions-1),1])
  
}

NNDataEntry <- as.data.frame(NNDataEntry)
NNDataEntrytranspose <- t(as.data.frame(NNDataEntry))
NNDataEntryfinal <- as.data.frame(NNDataEntrytranspose)
NNDataEntryfinal <- as.data.frame(na.omit(NNDataEntryfinal))


#create train and test dataset
# Train data = 2/3 of the data set
# Test data = 1/3 of the data set
#These numbers are usual in breaking down training and testing data, but can be changed

nrows <- nrow(NNDataEntryfinal)
cutpoint <- (nrows*2/3)

Data.train <- data.frame(NNDataEntryfinal[1:cutpoint,]) #Create train data
Data.test <- data.frame(NNDataEntryfinal[(cutpoint+1):nrows,]) #create test data


# unlist data - the neural network training function doesn't take lists which is coerced by the instructions above, so we need to unlist every vector.
Data.train$V1 <- unlist(Data.train$V1)
Data.train$V2 <- unlist(Data.train$V2)
Data.train$V3 <- unlist(Data.train$V3)
Data.train$V4 <- unlist(Data.train$V4)
Data.train$V5 <- unlist(Data.train$V5)
Data.train$V6 <- unlist(Data.train$V6)
Data.train$V7 <- unlist(Data.train$V7)
Data.train$V8 <- unlist(Data.train$V8)
Data.train$V9 <- unlist(Data.train$V9)
Data.train$V10 <- unlist(Data.train$V10)
Data.train$V11 <- unlist(Data.train$V11)
Data.train$V12 <- unlist(Data.train$V12)
Data.train$V13 <- unlist(Data.train$V13)
Data.train$V14<- unlist(Data.train$V14)
Data.train$V15<- unlist(Data.train$V15)
#unlist testing data
Data.test$V1 <- unlist(Data.test$V1)
Data.test$V2 <- unlist(Data.test$V2)
Data.test$V3 <- unlist(Data.test$V3)
Data.test$V4 <- unlist(Data.test$V4)
Data.test$V5 <- unlist(Data.test$V5)
Data.test$V6 <- unlist(Data.test$V6)
Data.test$V7 <- unlist(Data.test$V7)
Data.test$V8 <- unlist(Data.test$V8)
Data.test$V9 <- unlist(Data.test$V9)
Data.test$V10 <- unlist(Data.test$V10)
Data.test$V11 <- unlist(Data.test$V11)
Data.test$V12 <- unlist(Data.test$V12)
Data.test$V13 <- unlist(Data.test$V13)
Data.test$V14<- unlist(Data.test$V14)
Data.test$V15<- unlist(Data.test$V15)


#Prepare input and output for RNN

# Separating input and output data in both train and test

XTrain <- Data.train[,-(NumberofEntryData+1):-(NumberofEntryData+NumberofPredictions)]
YTrain <- Data.train[,(NumberofEntryData+1):(NumberofEntryData+NumberofPredictions)]

XTrain <- data.matrix(XTrain[,-(NumberofEntryData+1):-(NumberofEntryData+NumberofPredictions)])
YTrain <- data.matrix(YTrain)

XTest <- Data.test[,-(NumberofEntryData+1):-(NumberofEntryData+NumberofPredictions)]
YTest <- Data.test[,(NumberofEntryData+1):(NumberofEntryData+NumberofPredictions)]

XTest <- data.matrix(XTest[,-(NumberofEntryData+1):-(NumberofEntryData+NumberofPredictions)])
YTest <- data.matrix(YTest)

#Prepare 3d data for lstm

XTrain3D <- array(XTrain, c(1,nrow(XTrain),NumberofEntryData))
YTrain3D <- array(YTrain, c(1,nrow(YTrain),NumberofPredictions))
XTest3D <- array(XTest, c(1,nrow(XTest),NumberofEntryData))
YTest3D <- array(YTest, c(1,nrow(YTest),NumberofPredictions))

#Initialize vectors to save the results from the multiple results from the MC Simulation
predAll = list()
ErrorPredictAll <- list()

#Runs LSTM model n=20 times (n can be changed) to create the confidence interval for the MC simulation forecast
for (i in 1:20){

  #Parameters to be changed:
  # hidden_dim - number of hidden layers
  # sigmoid - activation functions for the neurons - 1- logistic 2- Gompertz 3- tanh
  # numepochs - number of iterations
  # learningrate - the step of learning
  LSTM_model <- trainr(Y=YTrain3D,X=XTrain3D, hidden_dim = 100, network_type = "lstm", use_bias = TRUE, sigmoid = "logistic", learningrate = 0.01, numepochs = 150 )

  # Predicts with the testing data
  pred <- predictr(LSTM_model,X=XTest3D)
  #
  # To see the plot of the results of the forecast compared to the real data, uncomment the next two lines of code
  #
  #plot(YTest3D[,,2],col="red",xlim=c(-1,30),ylim=c(-1,1.5)) 
  #points(pred[,,2],col="blue") 
  
  #Create data to predict the next NumberofPredictions=3 weeks
  LastData <- array(data.matrix(Tscaled2NNData[,76:83]), c(1,1,8))
  #Predicting the next NumberofPredictions=3 weeks
  pred2 <- predictr(LSTM_model,X=LastData)
  #Save the predictions in a vector
  predAll <- c(predAll, pred2)

  
 
  # Calculate MSE for the NumberofPredictions=3 predicted periods - If more than 3 weeks predicted make adjustments
  ErrorPredict1 <- mean((YTest[1,]-pred[,,1])^2)
  ErrorPredict2 <- mean((YTest[2,]-pred[,,2])^2)
  ErrorPredict3 <- mean((YTest[3,]-pred[,,3])^2)

  ErrorPredictAll <- c(ErrorPredictAll, c(ErrorPredict1*100,ErrorPredict2*100,ErrorPredict2*100))

}
  # PLOT THE RESULTS
  
  #seperate the results in number of weeks predicted - if more than 3 weeks was predicted make necessary adjustments

  ErrorPrediction <- t(as.data.frame(ErrorPredictAll)) 
  #Initialize the lists to save the errors for each week
  ErrorPrediction1 <- list()
  ErrorPrediction2 <- list()
  ErrorPrediction3 <- list()
  numberofrows <- (nrow(ErrorPrediction)/3)
  #Seperate each error in its respective week vector
  for (i in 1:(numberofrows)) {
    
    ErrorPrediction1 <- c(ErrorPrediction1, ErrorPrediction[3*i-2,])
    ErrorPrediction2 <- c(ErrorPrediction2, ErrorPrediction[3*i-1,])
    ErrorPrediction3 <- c(ErrorPrediction3, ErrorPrediction[3*i,])
    
  }
  
  #Plot histogram and plots of the errors for each week
  hist(unlist(ErrorPrediction1)) #Week 1
  hist(unlist(ErrorPrediction2)) #Week 2
  hist(unlist(ErrorPrediction3)) #Week 3
  #Add for more weeks
  plot(unlist(ErrorPrediction1)) #Week 1
  plot(unlist(ErrorPrediction2)) #Week 2
  plot(unlist(ErrorPrediction3)) #Week 3
  #Add for more weeks
  
  
  PredictionAll <- t(as.data.frame(predAll)) 
  #Initialize the lists to save the predictions for each week
  Prediction1 <- list() #Week 1
  Prediction2 <- list() #Week 2
  Prediction3 <- list() #Week 3
  numberofrows <- (nrow(PredictionAll)/3)
  
  #Seperate each prediction in its respective week vector
  
  for (i in 1:(numberofrows)) {
    
    Prediction1 <- c(Prediction1, PredictionAll[3*i-2,])
    Prediction2 <- c(Prediction2, PredictionAll[3*i-1,])
    Prediction3 <- c(Prediction3, PredictionAll[3*i,])
    
  }
  
  ForecastDist1 <- unlist(Prediction1)
  ForecastDist2 <- unlist(Prediction2)
  ForecastDist3 <- unlist(Prediction3)
  #Plot histogram and plot for each week
  # Week1
  hist(ForecastDist1)
  plot(ForecastDist1)
  # Week2
  hist(ForecastDist2)
  plot(ForecastDist2)
  # Week3
  hist(ForecastDist3)
  plot(ForecastDist3)

  # WEEK1
  # Plot distribution of the predictions with the actual density function and fitted density function
  #Convert normalized data into actual TEU Values
  
  PredDataFinal1 <- ForecastDist1*(maxs-mins)
  colnames(PredDataFinal1) <- "Pred"
  
  hist(PredDataFinal1, xlab ="TEU with HC factor", main = paste("Distribution of TEU for W", ForecastData[nrow(ForecastData),1]+1, sep = ""), prob = TRUE, col="red", breaks = 10)
  lines(density(PredDataFinal1), col="blue", lwd=2) # add a density estimate with defaults
  lines(density(PredDataFinal1, adjust=2), lty="dotted", col="darkgreen", lwd=2) 
  
  # WEEK2
  # Plot distribution of the predictions with the actual density function and fitted density function
  #Convert normalized data into actual TEU Values
  
  PredDataFinal2 <- ForecastDist2*(maxs-mins)
  colnames(PredDataFinal2) <- "Pred"
  
  hist(PredDataFinal2, xlab ="TEU with HC factor", main = paste("Distribution of TEU for W", ForecastData[nrow(ForecastData),1]+2, sep = ""), prob = TRUE, col="red", breaks = 10)
  lines(density(PredDataFinal2), col="blue", lwd=2) # add a density estimate with defaults
  lines(density(PredDataFinal2, adjust=2), lty="dotted", col="darkgreen", lwd=2) 
  
  # WEEK3
  # Plot distribution of the predictions with the actual density function and fitted density function
  #Convert normalized data into actual TEU Values
  PredDataFinal3 <- ForecastDist3*(maxs-mins)
  colnames(PredDataFinal3) <- "Pred"
  
  hist(PredDataFinal3, xlab ="TEU with HC factor", main = paste("Distribution of TEU for W", ForecastData[nrow(ForecastData),1]+3, sep = ""), prob = TRUE, col="red", breaks = 10)
  lines(density(PredDataFinal3), col="blue", lwd=2) # add a density estimate with defaults
  lines(density(PredDataFinal3, adjust=2), lty="dotted", col="darkgreen", lwd=2) 
  
 

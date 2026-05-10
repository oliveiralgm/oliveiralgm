#
# Hover Project for Presentation on April 18th - San Francisco California
#


#
#   Our finance and operations teams want to know how much demand (# of jobs) we will get in
# 2019. Specifically we’d like to know:
#       ● What is the overall # of jobs we can expect in 2019?
#       ● What is the demand of roof vs. complete models we can expect?
#       ● How much of the expected volume might come from weather events?
#


import time
import numpy as np
import matplotlib
import ssl
import pandas as pd
from sklearn import metrics



#   --- Read data ---

weatherDataFrame = pd.read_csv("weather.csv", encoding='ISO-8859-1')
jobsDataFrame = pd.read_csv("jobs.csv", encoding='ISO-8859-1')

# reduce size to debug code
# weatherDataFrame = weatherDataFrame[0:50]
#jobsDataFrame = jobsDataFrame[0:5000]



# Analyze jobs features


# Convert date column to datetime
# get column names
column = jobsDataFrame.columns.values
jobsDataFrame[column[4]] = pd.to_datetime(jobsDataFrame[column[4]], format='%m/%d/%y %H:%M')

# Create a column with year/month the job was uploaded
jobsDataFrame['year'] = jobsDataFrame[column[4]].dt.year
jobsDataFrame['month'] = jobsDataFrame[column[4]].dt.month
jobsDataFrame['day'] = jobsDataFrame[column[4]].dt.day
jobsDataFrame['time'] = jobsDataFrame[column[4]].dt.time
# jobsDataFrame['year_month'] = jobsDataFrame['year'].astype(str) + '/' + jobsDataFrame['month'].astype(str)

# get column names
column = jobsDataFrame.columns.values
print(jobsDataFrame.columns.values)

# create dict of unique values
uniqueJobValues = {}
for value in column:
    print(jobsDataFrame[value].unique())
    uniqueJobValues[value] = jobsDataFrame[value].unique()


# Function that slices the data frame in multiple dataframes for unique values of the feature
def getSlicedDF(originalDataFrame, sliceHeader, sliceValues):
    dataframeDict = {}
    sliceVal = sliceValues[sliceHeader]
    for x in range(0, len(sliceVal)):
        tempDataFrame = originalDataFrame.loc[originalDataFrame[sliceHeader] == sliceVal[x]]
        dataframeDict[sliceVal[x]] = tempDataFrame

    return dataframeDict


# slice dataframe into dicts of types of jobs
typeOfJob = getSlicedDF(jobsDataFrame, column[5], uniqueJobValues)


## create time series by year and region
# Function that slices the data frame in multiple dataframes for unique values of the feature

def createTimeSeries(newDict, year_header, month_header):
    seriesDict = {}

    for key in newDict.keys():
        dataFrametemp = newDict[key]
        timeSeries = dataFrametemp.groupby([year_header, month_header])
        temp = timeSeries.count()
        temp = temp.drop(temp.index[len(temp) - 1])  # remove last value with less than x days
        seriesDict[key] = temp.iloc[:, 0]
    #print(seriesDict)

    return seriesDict


# time series for roof and complete jobs for models

timeSeries = createTimeSeries(typeOfJob, column[9], column[10])

roofSeries = timeSeries['roof']
print(roofSeries)
completeSeries = timeSeries['complete']
print(completeSeries)

# timeSeries = timeSeries[column[10]]
timeSeries['roof'].plot()
timeSeries['complete'].plot()



# test_stationarity(roofSeries)
# test_stationarity(completeSeries)
# jobsRegionFreq = jobsDataFrame[column[3]].value_counts(dropna=False)
#
# print(column[3])
# print(jobsRegionFreq)
# print(jobsRegionFreq / jobsRegionFreq.sum())
# print(" ")


# LSTM Model Vanilla

# univariate lstm
from numpy import array
from keras.models import Sequential
from keras.layers import LSTM
from keras.layers import Dense

# split a univariate sequence into samples
def split_sequence(sequence, n_steps, numOutputs):
    X, y = list(), list()
    for i in range(len(sequence)):
        # find the end of this pattern
        end_ix = i + n_steps
        # check if we are beyond the sequence
        if end_ix + numOutputs > len(sequence)-1:
            break
        # gather input and output parts of the pattern
        seq_x, seq_y = sequence[i:end_ix], sequence[end_ix:end_ix+numOutputs]
        X.append(seq_x)
        y.append(seq_y)
    return array(X), array(y)

def predictRNNLSTM(series, nsteps, noutup):
    # define input sequence
    # raw_seq = [10, 20, 30, 40, 50, 60, 70, 80, 90]
    # choose a number of time steps
    n_steps = nsteps
    n_output = noutup
    # split into samples
    X1, y = split_sequence(series, n_steps, n_output)
    # reshape from [samples, timesteps] into [samples, timesteps, features]
    n_features = 1
    X = X1.reshape((X1.shape[0], X1.shape[1], n_features))
    # define model
    count = 0
    yhat_all = pd.DataFrame
    model = Sequential()
    model.add(LSTM(200, activation='relu', input_shape=(n_steps, n_features)))
    model.add(Dense(noutup))
    model.compile(optimizer='adam', loss='mse')
    # fit model
    model.fit(X, y, epochs=200, verbose=0)

    # calculate error with test
    #print(X1[0])
    #print(y[0])
    x_input = array(X1[0])
    x_input = x_input.reshape((1, n_steps, n_features))
    yhat = model.predict(x_input, verbose=0)
    yhat = yhat.ravel()
    MAE = metrics.mean_absolute_error(y[0], yhat)
    MSE = metrics.mean_squared_error(y[0], yhat)
    print(MAE)
    print(MSE)
    #print(yhat,y[0])
    # yhat.plot()
    # y[0].plot()
    # demonstrate prediction
    #print(y[len(y)-1-noutup:len(y)-1])
    x_input = array(series[len(series)-1-noutup:len(series)-1])
    x_input = x_input.reshape((1, n_steps, n_features))
    yhat = model.predict(x_input, verbose=0)
    #print(yhat)
    #yhat.reshape(10,1)
    yhat = pd.Series(yhat[0])

    SeriesNew = series.append(yhat)
    SeriesNew.plot()

    return SeriesNew, MAE, MSE

roofSeriesPred = {}
completeSeriesPred = {}
MAEroof = []
MSEroof = []
MAEcomp = []
MSEcomp = []
count = 0
while count < 5:
    roofSeriesPred[count], mae, mse = predictRNNLSTM(roofSeries,16,8)
    MAEroof.append(mae)
    MSEroof.append(mse)
    completeSeriesPred[count], mae, mse = predictRNNLSTM(completeSeries,16,8)
    MAEcomp.append(mae)
    MSEcomp.append(mse)
    count = count + 1

roofSeriesPred = pd.DataFrame(roofSeriesPred)
completeSeriesPred = pd.DataFrame(completeSeriesPred)

pause()
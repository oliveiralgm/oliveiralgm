#
# Hover Project for Presentation on April 18th - San Francisco California
#
#   Run from terminal to get results file, using command >> python ./plots.py > plotData.txt
#

#
#   Our finance and operations teams want to know how much demand (# of jobs) we will get in
# 2019. Specifically we’d like to know:
#       ● What is the overall # of jobs we can expect in 2019?
#       ● What is the demand of roof vs. complete models we can expect?
#       ● How much of the expected volume might come from weather events?
#

#
# data for lon, lat for cities from - https://simplemaps.com/data/us-cities
#

import datetime
import time
import numpy as np
import matplotlib
import geopy  # to associate weather events to cities
from geopy.geocoders import Nominatim
import certifi
import ssl
import pandas as pd
import geopy.distance
from numpy import array
from keras.models import Sequential
from keras.layers import LSTM
from keras.layers import Dense
from sklearn import metrics


#
#
# RNN LSTM Model - univariate
#

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
    series = np.array(series)
    series = np.nan_to_num(series)
    series = pd.Series(series)
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
    model.add(LSTM(50, activation='relu', input_shape=(n_steps, n_features)))
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
    #print(MAE)
    #print(MSE)
    #print(yhat,y[0])
    # yhat.plot()
    # y[0].plot()
    # demonstrate prediction
    #print(y[len(y)-1-noutup:len(y)-1])
    x_input = array(series[len(series)-1-n_steps:len(series)-1])
    x_input = x_input.reshape((1, n_steps, n_features))
    yhat = model.predict(x_input, verbose=0)
    #print(yhat)
    #yhat.reshape(10,1)
    yhat = pd.Series(yhat[0])

    SeriesNew = series.append(yhat)
    SeriesNew.plot()

    return yhat, MAE, MSE

def getAveragePrediction(series,inputNumber,outputNumber,numberOfSimulationss):
    SeriesPred = {}
    MAE = []
    MSE = []
    count = 0
    while count < numberOfSimulationss:
        SeriesPred[count], mae, mse = predictRNNLSTM(series,inputNumber,outputNumber)
        MAE.append(mae)
        MSE.append(mse)
        count = count + 1

    return SeriesPred, np.mean(np.array(MAE)), np.mean(np.array(MSE))


#   --- Read data ---

#weatherDataFrame = pd.read_csv("weather.csv", encoding='ISO-8859-1')
jobsDataFrame = pd.read_csv("jobFinalData.csv")#, encoding='ISO-8859-1')

# reduce size to debug code
# weatherDataFrame = weatherDataFrame[0:50]
# jobsDataFrame = jobsDataFrame[0:50]
# create dict of unique values
uniqueJobValues = {}
column = jobsDataFrame.columns.values
for value in column:
    # print(jobsDataFrame[value].unique())
    uniqueJobValues[value] = jobsDataFrame[value].unique()


# Analyze jobs features


# Convert date column to datetime
# get column names
column = jobsDataFrame.columns.values
jobsDataFrame[column[5]] = pd.to_datetime(jobsDataFrame[column[5]], format='%m/%d/%y %H:%M')



# slice weather dataframe for relevant states
# def sliceWeather(oldDataFrame, header, values):
#     newDataFrame = oldDataFrame.loc[oldDataFrame[header].isin(values)]
#
#     return newDataFrame


# slicedWeatherDF = sliceWeather(weatherDataFrame, 'STATE', uniqueJobValues['Job Location Region Code'])


# Create a column with year/month the job was uploaded
jobsDataFrame['year'] = jobsDataFrame[column[5]].dt.year
jobsDataFrame['month'] = jobsDataFrame[column[5]].dt.month
jobsDataFrame['day'] = jobsDataFrame[column[5]].dt.day
jobsDataFrame['time'] = jobsDataFrame[column[5]].dt.time
# jobsDataFrame['year_month'] = jobsDataFrame['year'].astype(str) + '/' + jobsDataFrame['month'].astype(str)

# get column names
column = jobsDataFrame.columns.values
#print(jobsDataFrame.columns.values)

# create dict of unique values
uniqueJobValues = {}
for value in column:
    #print(jobsDataFrame[value].unique())
    uniqueJobValues[value] = jobsDataFrame[value].unique()


# Function that slices the data frame in multiple dataframes for unique values of the feature
def getSlicedDF(originalDataFrame, sliceHeader, sliceValues):
    dataframeDict = {}
    sliceVal = sliceValues[sliceHeader]
    for x in range(0, len(sliceVal)):
        tempDataFrame = originalDataFrame.loc[originalDataFrame[sliceHeader] == sliceVal[x]]
        dataframeDict[sliceVal[x]] = tempDataFrame

    return dataframeDict


## create time series by year and region
# Function that slices the data frame in multiple dataframes for unique values of the feature

def createTimeSeries(newDict, year_header, month_header, type='month'):
    seriesDict = {}
    for key in newDict.keys():
        dataFrametemp = newDict[key]
        timeSeries = dataFrametemp.groupby([year_header, month_header])
        temp = timeSeries.count()
        temp = temp.drop(temp.index[len(temp) - 1])  # remove last value with less than x days
        seriesDict[key] = temp.iloc[:, 0]

    if type == 'month':

        #print(seriesDict)
        return seriesDict
    else:
        if type == 'quarter':

            seriesDataframe = pd.DataFrame(seriesDict)
            seriesDataframe = seriesDataframe.sort_index()
            dates = seriesDataframe.index.values
            newDates = []
            for date in dates:
                newDates.append(str(date[1]) + '/' + str(date[0]))
            newDataFrame = seriesDataframe.groupby(pd.PeriodIndex(newDates, freq='Q'), axis=0)

            return newDataFrame






# slice dataframe into dicts of types of jobs

typeOfJob = getSlicedDF(jobsDataFrame, column[6], uniqueJobValues)
roofDF = typeOfJob['roof']
completeDF = typeOfJob['complete']
# time series for roof and complete jobs for models

timeSeries = createTimeSeries(typeOfJob, column[11], column[12])
print('Roof time Series:') 
print(timeSeries['roof'])
print(" ")

print('Complete time Series:') 
print(timeSeries['complete'])
print(" ")

#slice by weather or not weather related

roofWeatherEvent = getSlicedDF(roofDF,'weatherRelated',uniqueJobValues)
completeWeatherEvent = getSlicedDF(completeDF,'weatherRelated',uniqueJobValues)

timeSeriesRoofWeat = createTimeSeries(roofWeatherEvent, column[11], column[12])
timeSeriesRoofWeatDF = pd.DataFrame(timeSeriesRoofWeat)
timeSeriesCompWeat = createTimeSeries(completeWeatherEvent, column[11], column[12])
timeSeriesCompWeatDF = pd.DataFrame(timeSeriesCompWeat)
print('Roof without weather event timeseries:')
print(timeSeriesRoofWeatDF[0])
print(" ")

print('Roof with weather event timeseries:')
print(timeSeriesRoofWeatDF[1])
print(" ")

print('Complete without weather event timeseries:')
print(timeSeriesCompWeatDF[0])
print(" ")

print('Complete with weather event timeseries:')
print(timeSeriesCompWeatDF[1])
print(" ")

# series by type of job >> Region >> weather Event

roof_Region = getSlicedDF(roofDF, column[4], uniqueJobValues)
comp_Region = getSlicedDF(completeDF, column[4], uniqueJobValues)

roof_NE_Weather = getSlicedDF(roof_Region['NE'],'weatherRelated',uniqueJobValues)
roof_OK_Weather = getSlicedDF(roof_Region['OK'],'weatherRelated',uniqueJobValues)
roof_KS_Weather = getSlicedDF(roof_Region['KS'],'weatherRelated',uniqueJobValues)
roof_TX_Weather = getSlicedDF(roof_Region['TX'],'weatherRelated',uniqueJobValues)
roof_ND_Weather = getSlicedDF(roof_Region['ND'],'weatherRelated',uniqueJobValues)
roof_SD_Weather = getSlicedDF(roof_Region['SD'],'weatherRelated',uniqueJobValues)

comp_NE_Weather = getSlicedDF(comp_Region['NE'],'weatherRelated',uniqueJobValues)
comp_OK_Weather = getSlicedDF(comp_Region['OK'],'weatherRelated',uniqueJobValues)
comp_KS_Weather = getSlicedDF(comp_Region['KS'],'weatherRelated',uniqueJobValues)
comp_TX_Weather = getSlicedDF(comp_Region['TX'],'weatherRelated',uniqueJobValues)
comp_ND_Weather = getSlicedDF(comp_Region['ND'],'weatherRelated',uniqueJobValues)
comp_SD_Weather = getSlicedDF(comp_Region['SD'],'weatherRelated',uniqueJobValues)

timeSeriesRoof_NE_Weath = createTimeSeries(roof_NE_Weather, column[11], column[12])
timeSeriesRoof_NE_WeathDF = pd.DataFrame(timeSeriesRoof_NE_Weath)

print('Roof without weather event timeseries NE REGION:')
print(timeSeriesRoof_NE_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_NE_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))


print('Roof with weather event timeseries NE REGION:')
print(timeSeriesRoof_NE_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_NE_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesRoof_OK_Weath = createTimeSeries(roof_OK_Weather, column[11], column[12])
timeSeriesRoof_OK_WeathDF = pd.DataFrame(timeSeriesRoof_OK_Weath)

print('Roof without weather event timeseries OK REGION:')
print(timeSeriesRoof_OK_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_OK_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Roof with weather event timeseries OK REGION:')
print(timeSeriesRoof_OK_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_OK_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesRoof_KS_Weath = createTimeSeries(roof_KS_Weather, column[11], column[12])
timeSeriesRoof_KS_WeathDF = pd.DataFrame(timeSeriesRoof_KS_Weath)

print('Roof without weather event timeseries KS REGION:')
print(timeSeriesRoof_KS_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_KS_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Roof with weather event timeseries KS REGION:')
print(timeSeriesRoof_KS_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_KS_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesRoof_TX_Weath = createTimeSeries(roof_TX_Weather, column[11], column[12])
timeSeriesRoof_TX_WeathDF = pd.DataFrame(timeSeriesRoof_TX_Weath)

print('Roof without weather event timeseries TX REGION:')
print(timeSeriesRoof_TX_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_TX_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Roof with weather event timeseries TX REGION:')
print(timeSeriesRoof_TX_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_TX_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))
#
timeSeriesRoof_ND_Weath = createTimeSeries(roof_ND_Weather, column[11], column[12])
timeSeriesRoof_ND_WeathDF = pd.DataFrame(timeSeriesRoof_ND_Weath)

print('Roof without weather event timeseries ND REGION:')
print(timeSeriesRoof_ND_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_ND_WeathDF[0],10,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Roof with weather event timeseries NE REGION:')
print(timeSeriesRoof_ND_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_ND_WeathDF[1],10,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))



timeSeriesRoof_SD_Weath = createTimeSeries(roof_SD_Weather, column[11], column[12])
timeSeriesRoof_SD_WeathDF = pd.DataFrame(timeSeriesRoof_SD_Weath)

print('Roof without weather event timeseries SD REGION:')
print(timeSeriesRoof_SD_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_SD_WeathDF[0],11,11,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Roof with weather event timeseries SD REGION:')
print(timeSeriesRoof_SD_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesRoof_SD_WeathDF[1],11,11,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

##  COMPLETE  ####

timeSeriesComp_NE_Weath = createTimeSeries(comp_NE_Weather, column[11], column[12])
timeSeriesComp_NE_WeathDF = pd.DataFrame(timeSeriesComp_NE_Weath)

print('Complete without weather event timeseries NE REGION:')
print(timeSeriesComp_NE_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_NE_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Complete with weather event timeseries NE REGION:')
print(timeSeriesComp_NE_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_NE_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesComp_OK_Weath = createTimeSeries(comp_OK_Weather, column[11], column[12])
timeSeriesComp_OK_WeathDF = pd.DataFrame(timeSeriesComp_OK_Weath)

print('Complete without weather event timeseries OK REGION:')
print(timeSeriesComp_OK_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_OK_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Complete with weather event timeseries OK REGION:')
print(timeSeriesComp_OK_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_OK_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesComp_KS_Weath = createTimeSeries(comp_KS_Weather, column[11], column[12])
timeSeriesComp_KS_WeathDF = pd.DataFrame(timeSeriesComp_KS_Weath)

print('Complete without weather event timeseries KS REGION:')
print(timeSeriesComp_KS_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_KS_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Complete with weather event timeseries KS REGION:')
print(timeSeriesComp_KS_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_KS_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesComp_TX_Weath = createTimeSeries(comp_TX_Weather, column[11], column[12])
timeSeriesComp_TX_WeathDF = pd.DataFrame(timeSeriesComp_TX_Weath)

print('Complete without weather event timeseries TX REGION:')
print(timeSeriesComp_TX_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_TX_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Complete with weather event timeseries TX REGION:')
print(timeSeriesComp_TX_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_TX_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesComp_ND_Weath = createTimeSeries(comp_ND_Weather, column[11], column[12])
timeSeriesComp_ND_WeathDF = pd.DataFrame(timeSeriesComp_ND_Weath)

print('Complete without weather event timeseries ND REGION:')
print(timeSeriesComp_ND_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_ND_WeathDF[0],11,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Complete with weather event timeseries ND REGION:')
print(timeSeriesComp_ND_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_ND_WeathDF[1],11,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

timeSeriesComp_SD_Weath = createTimeSeries(comp_SD_Weather, column[11], column[12])
timeSeriesComp_SD_WeathDF = pd.DataFrame(timeSeriesComp_SD_Weath)

print('Complete without weather event timeseries SD REGION:')
print(timeSeriesComp_SD_WeathDF[0])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_SD_WeathDF[0],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print('Complete with weather event timeseries SD REGION:')
print(timeSeriesComp_SD_WeathDF[1])
print(" ")

prediction, MAE, MSE = getAveragePrediction(timeSeriesComp_SD_WeathDF[1],14,10,10)
prediction = pd.DataFrame(prediction)
print('Prediction: ')
print(prediction.to_string())
print("MAE: " + str(MAE))
print("MSE: " + str(MSE))

print(timeSeries)
roofSeries = timeSeries['roof']
completeSeries = timeSeries['complete']

# timeSeries = timeSeries[column[10]]
timeSeries['roof'].plot()
timeSeries['complete'].plot()

# jobsRegionFreq = jobsDataFrame[column[10]].value_counts(dropna=False)
#
# print(column[10])
# print(jobsRegionFreq)
# print(jobsRegionFreq / jobsRegionFreq.sum())
# print(" ")



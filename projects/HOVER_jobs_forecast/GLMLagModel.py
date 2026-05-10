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
import geopy  # to associate weather events to cities
from geopy.geocoders import Nominatim
import certifi
import ssl
import pandas as pd
from statsmodels.tsa.stattools import adfuller
import matplotlib.pyplot as plot
from pandas import Series
from matplotlib import pyplot
from statsmodels.tsa.ar_model import AR
from sklearn.metrics import mean_squared_error

#tests stationarity
def test_stationarity(timeseries):
    # Determing rolling statistics
    rolmean = pd.rolling_mean(timeseries, window=12)
    rolstd = pd.rolling_std(timeseries, window=12)
    # Plot rolling statistics:
    plt.plot(timeseries, color='blue', label='Original')
    plt.plot(rolmean, color='red', label='Rolling Mean')
    plt.plot(rolstd, color='black', label='Rolling Std')
    plt.legend(loc='best')
    plt.title('Rolling Mean & Standard Deviation')
    plt.show()
    # Perform Dickey-Fuller test:
    print('Results of Dickey-Fuller Test:')
    dftest = adfuller(timeseries, autolag='AIC')
    dfoutput = pd.Series(dftest[0:4], index=['Test Statistic', 'p-value', '#Lags Used', 'Number of Observations Used'])
    for key, value in dftest[4].items():
        dfoutput['Critical Value (%s)' % key] = value
    print(dfoutput)

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
# timeSeries['roof'].plot()
# timeSeries['complete'].plot()


# Adding the lag of the target variable from 6 steps back up to 24
for i in range(8, 25):
    data["lag_{}".format(i)] = roofSeries.shift(i)


# series = completeSeries
# # split dataset
# X = series.values
# train, test = X[0:len(X)-8], X[len(X)-8:]
# # train autoregression
# model = AR(train)
# model_fit = model.fit()
# print('Lag: %s' % model_fit.k_ar)
# print('Coefficients: %s' % model_fit.params)
# # make predictions
# predictions = model_fit.predict(start=len(train), end=len(train)+len(test)-1, dynamic=False)
# for i in range(len(predictions)):
# 	print('predicted=%f, expected=%f' % (predictions[i], test[i]))
# error = mean_squared_error(test, predictions)
# print('Test MSE: %.3f' % error)
# # plot results
# pyplot.plot(test)
# pyplot.plot(predictions, color='red')
# pyplot.show()

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score

# for time-series cross-validation set 5 folds
tscv = TimeSeriesSplit(n_splits=5)


def timeseries_train_test_split(X, y, test_size):
    """
        Perform train-test split with respect to time series structure
    """

    # get the index after which test set starts
    test_index = int(len(X) * (1 - test_size))

    X_train = X.iloc[:test_index]
    y_train = y.iloc[:test_index]
    X_test = X.iloc[test_index:]
    y_test = y.iloc[test_index:]

    return X_train, X_test, y_train, y_test


def plotModelResults(model, X_train=X_train, X_test=X_test, plot_intervals=False, plot_anomalies=False, scale=1.96):
    """
        Plots modelled vs fact values, prediction intervals and anomalies

    """

    prediction = model.predict(X_test)

    plt.figure(figsize=(15, 7))
    plt.plot(prediction, "g", label="prediction", linewidth=2.0)
    plt.plot(y_test.values, label="actual", linewidth=2.0)

    if plot_intervals:
        cv = cross_val_score(model, X_train, y_train,
                             cv=tscv,
                             scoring="neg_mean_squared_error")
        # mae = cv.mean() * (-1)
        deviation = np.sqrt(cv.std())

        lower = prediction - (scale * deviation)
        upper = prediction + (scale * deviation)

        plt.plot(lower, "r--", label="upper bond / lower bond", alpha=0.5)
        plt.plot(upper, "r--", alpha=0.5)

        if plot_anomalies:
            anomalies = np.array([np.NaN] * len(y_test))
            anomalies[y_test < lower] = y_test[y_test < lower]
            anomalies[y_test > upper] = y_test[y_test > upper]
            plt.plot(anomalies, "o", markersize=10, label="Anomalies")

    error = mean_absolute_percentage_error(prediction, y_test)
    plt.title("Mean absolute percentage error {0:.2f}%".format(error))
    plt.legend(loc="best")
    plt.tight_layout()
    plt.grid(True);


def plotCoefficients(model):
    """
        Plots sorted coefficient values of the model
    """

    coefs = pd.DataFrame(model.coef_, X_train.columns)
    coefs.columns = ["coef"]
    coefs["abs"] = coefs.coef.apply(np.abs)
    coefs = coefs.sort_values(by="abs", ascending=False).drop(["abs"], axis=1)

    plt.figure(figsize=(15, 7))
    coefs.coef.plot(kind='bar')
    plt.grid(True, axis='y')
    plt.hlines(y=0, xmin=0, xmax=len(coefs), linestyles='dashed');


y = data.dropna().y
X = data.dropna().drop(['y'], axis=1)

# reserve 30% of data for testing
X_train, X_test, y_train, y_test = timeseries_train_test_split(X, y, test_size=0.3)

# machine learning in two lines
lr = LinearRegression()
lr.fit(X_train, y_train)

plotModelResults(lr, plot_intervals=True)
plotCoefficients(lr)
















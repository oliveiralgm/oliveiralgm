#
#
#   *****   Intercom Funnel Analysis  *****
#
#
#       Run from terminal to get results file, using command >> python Funnel Analysis.py >> MktFunnel.txt
#
#


import pandas as pd
import matplotlib
import numpy
#import squarify
import matplotlib.pyplot as plt

# -- read the data

funnelData = pd.read_csv("data.csv", delimiter="\t")

# reduce size to debug code
#funnelData = funnelData[0:6000]

#
#
#  ---  Feature engineering
#
#
#

#calculating lead-trial cycle in days - NOT USED (for later use)

funnelData['app_created_at'] = pd.to_datetime(funnelData['app_created_at'])
funnelData['created_at'] = pd.to_datetime(funnelData['created_at'])
funnelData['lead_trial_time'] = (funnelData['app_created_at'] - funnelData['created_at']).dt.days

#calculating trial-customer cycle in days - NOT USED (for later use

funnelData['first_invoice_created_at'] = pd.to_datetime(funnelData['first_invoice_created_at'])
funnelData['app_created_at'] = pd.to_datetime(funnelData['app_created_at'])
funnelData['trial_customer_time'] = (funnelData['first_invoice_created_at'] - funnelData['app_created_at']).dt.days

#
#
# -- Create a column with year and month the lead was created to be able to analyze conversions by year
#
#   Some customers have invoice dates before the dates they were created in the system, so we considered their invoice date
#   as their "Initial Lead Date" for conversion date analysis
#
#

# Fill NAN from 'created_at' with data from sfdc_created_at (Usually very similar)
funnelData.created_at.fillna(funnelData.sfdc_created_at, inplace=True)
#funnelData.app_created_at.fillna(funnelData.created_at, inplace=True)

# Convert to datetime
funnelData['created_at'] = pd.to_datetime(funnelData['created_at'])
funnelData.loc[funnelData['created_at'] > funnelData['first_invoice_created_at'], 'created_at'] = funnelData['first_invoice_created_at']


#Create a column with year and month the lead was created
funnelData['year'] = funnelData['created_at'].dt.year
funnelData['month'] = funnelData['created_at'].dt.month


headers = funnelData.columns.values
print(headers)

#frequency of types of leads
leadTypesFreq = funnelData[headers[1]].value_counts(dropna=False)
print(leadTypesFreq / leadTypesFreq.sum())

def freqTypesofLeads(dict):

    size = len(dict.keys())
    for x in range(0, size):
        dataframe = dict[list(dict)[x]]
        leadTypesFreq = dataframe[headers[1]].value_counts(dropna=False)

        print(list(dict)[x])
        print(leadTypesFreq)
        print(leadTypesFreq / leadTypesFreq.sum())
        print(" ")


#Treemap graph
# squarify.plot(sizes=leadTypesFreq, label=["Lead1","lead2","lead3","Lead4"], alpha=.5 )
# plt.axis('off')
# plt.show()

# Store column unique values for year, month, leads and prospects for programmatically slicing

year = funnelData.year.unique()
year.sort()
print(year)

month = funnelData.month.unique()
month.sort()
print(month)

leadTypes = funnelData.lead_type.unique()
print(leadTypes)

prospectTypes = funnelData.prospect_type.unique()
print(prospectTypes)

prospectChannelTypes = funnelData.prospect_channel.unique()
print(prospectChannelTypes)

prospectSubTypes = funnelData.prospect_channel_subtype.unique()
print(prospectSubTypes)

prospectConsTypes = funnelData.consolidated_lead_channel.unique()
print(prospectConsTypes)

# Function that slices the data frame in multiple dataframes for unique values of the feature
def getSlicedDF(originalDataFrame,sliceHeader,sliceValues):

    dataframeDict = {}

    for x in range(0,len(sliceValues)):

        tempDataFrame = originalDataFrame.loc[originalDataFrame[sliceHeader] == sliceValues[x]]
        dataframeDict[sliceValues[x]] = tempDataFrame

    return dataframeDict

# Function that counts frequency for unique values of the feature headerType
def getFreq(dictWithDataFrames,headerType,values):

    freqDict = {}

    for x in range (0, len(values)):
        freqTemp = dictWithDataFrames[values[x]][headerType].value_counts(dropna=False)

        freqDict[values[x]] = freqTemp

    return freqDict

# Function that calculates percentage for unique values of the feature headerType
def getRates(dictWithDataFrames,headerType,values):

    freqDict = {}

    for x in range (0, len(values)):
        freqTemp = dictWithDataFrames[values[x]][headerType].value_counts(dropna=False)

        freqDict[values[x]] = (freqTemp / freqTemp.sum())

    return freqDict

funnelDataYear = getSlicedDF(funnelData, headers[17],year)

funnelData2012 = funnelDataYear[year[0]]
funnelData2013 = funnelDataYear[year[1]]
funnelData2014 = funnelDataYear[year[2]]
funnelData2015 = funnelDataYear[year[3]]
funnelData2016 = funnelDataYear[year[4]]
funnelData2017 = funnelDataYear[year[5]]

#Function that slices and calculates distribution of Lead Types by Prospect Type per year

def getTimeseriesLeadTypes(dict):

    size = len(dict.keys())
    for x in range(0, size):
        dataframe = dict[list(dict)[x]]
        leadTypeDict = getSlicedDF(dataframe,headers[1],leadTypes)
        leadTypePerc = getRates(leadTypeDict,headers[2],leadTypes)
        leadTypeFreq = getFreq(leadTypeDict,headers[2],leadTypes)


        tempDataFrame = pd.DataFrame(leadTypePerc)
        tempDataFrameFreq = pd.DataFrame(leadTypeFreq)

        print(list(dict)[x])
        print(tempDataFrameFreq.to_string())
        print(tempDataFrame.to_string())
        print(" ")

freqTypesofLeads(funnelDataYear)
getTimeseriesLeadTypes(funnelDataYear)


def getTimeseriesProspTypes(dict):

    size = len(dict.keys())
    for x in range(0, size):
        dataframe = dict[list(dict)[x]]
        leadTypesDict = getSlicedDF(dataframe,headers[1],leadTypes)

        size1 = len(leadTypesDict.keys())
        for x1 in range(0, size1):
            dataframe1 = leadTypesDict[list(leadTypesDict)[x1]]
            prospTypeDict = getSlicedDF(dataframe1, headers[2], prospectTypes)
            prospTypePerc = getRates(prospTypeDict, headers[6], prospectTypes)
            prospTypeFreq = getFreq(prospTypeDict, headers[6], prospectTypes)

            tempDataFrame = pd.DataFrame(prospTypePerc)
            tempDataFrameFreq = pd.DataFrame(prospTypeFreq)

            print('YEAR: ' + str(list(dict)[x]))
            print('Lead Type: ' + str(list(leadTypesDict)[x1]))

            print(tempDataFrameFreq.to_string())
            print(tempDataFrame.to_string())
            print(" ")


def getTimeseriesConsLead(dict):

    size = len(dict.keys())
    for x in range(0, size):
        dataframe = dict[list(dict)[x]]
        leadTypesDict = getSlicedDF(dataframe,headers[1],leadTypes)

        size1 = len(leadTypesDict.keys())
        for x1 in range(0, size1):
            dataframe1 = leadTypesDict[list(leadTypesDict)[x1]]
            prospTypeDict = getSlicedDF(dataframe1, headers[6], prospectConsTypes)
            prospTypePerc = getRates(prospTypeDict, headers[2], prospectConsTypes)
            prospTypeFreq = getFreq(prospTypeDict, headers[2], prospectConsTypes)

            tempDataFrame = pd.DataFrame(prospTypePerc)
            tempDataFrameFreq = pd.DataFrame(prospTypeFreq)

            print('YEAR: ' + str(list(dict)[x]))
            print('Lead Type: ' + str(list(leadTypesDict)[x1]))

            print(tempDataFrameFreq.to_string())
            print(tempDataFrame.to_string())
            print(" ")

getTimeseriesProspTypes(funnelDataYear)
getTimeseriesConsLead(funnelDataYear)



# Pull the dataframes from the Dictionary
# selfServeLead = leadTypeDict[leadTypes[0]]
# mktQualLead = leadTypeDict[leadTypes[1]]
# salesOppLead = leadTypeDict[leadTypes[2]]
# salesWinLead = leadTypeDict[leadTypes[3]]
#
# #Slice and calculate distribution of Prospect Type by consolidated channel
# prospTypeDict_SSL = getSlicedDF(selfServeLead, headers[2], prospectTypes)
# prospTypeDict_MKTQ = getSlicedDF(selfServeLead, headers[2], prospectTypes)
# prospTypeDict_SALESO = getSlicedDF(selfServeLead, headers[2], prospectTypes)
# prospTypeDict_SALESW = getSlicedDF(selfServeLead, headers[2], prospectTypes)
#
# prospTypePerc_SSL = getRates(prospTypeDict_SSL,headers[6],prospectTypes)
# prospTypePerc_MKTQ = getRates(prospTypeDict_MKTQ,headers[6],prospectTypes)
# prospTypePerc_SALESQ = getRates(prospTypeDict_SALESO,headers[6],prospectTypes)
# prospTypePerc_SALESW = getRates(prospTypeDict_SALESW,headers[6],prospectTypes)

# print(prospTypePerc_SSL)




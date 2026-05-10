``` 
  Used K-means clustering to reduce customer quoting time in 40% & CNN-LSTM to optimize vessel load capacity. 
  
    > libraries used:
      - dplyr
      - cluster
      - Rtsne
      - ggplot2
      - gdata
      - xlsx
    
 ```

## More Details

I worked for a major container shipping company's Miami office and was requested to optimize their quoting system.

### Clustering

1- Situation: 
  There was no systematic way to define quoting for a certain client. It was very ad-hoc and would take too long.

2- Task: 
  Build a clusters for clients based on commodity transported, volume and portpair (port of loading -> port of destination). This way when a client requested a quote based on those three variables, there was a quote range well defined based on those clusters.

3- Actions:
  - Data cleaning to enable data quality and integrity using excel VBA routines. 
  - Meetings with major stakeholders for context and validation of variables. 
  - Actual building of model and testing results.
  - Using silhouette method to determin number of clusters
  - Associate clusters to prices
  - Meeting with stakeholders to validate the results

4- Results:
  - Reduced quoting time in around 75% - from an average of 4 days to 1 day.
  - Was later implemented in all offices around the world.
  
  ## Silhouette and Cluster Graphs
  
 ![Alt text](https://github.com/oliveiralgm/Cluster-and-Deep-Learning-in-R/blob/main/clustering/Clustering%20Results%20Graphs%20Tier%201.png)
 ![Alt text](https://github.com/oliveiralgm/Cluster-and-Deep-Learning-in-R/blob/main/clustering/Clustering%20Results%20Graphs%20Tier%202.png)


### Deep Learning Volume Prediction

1- Situation: 
  Client wanted to be able to predict load per shipping voyage to optimize allocation of cargo for maximum revenue.

2- Task: 
  Develop a forecasting model using historical timeseries data.

3- Actions:
  - Clean and prepare data for models - done in excel and VBA. 
  - Test multiple models, including ARIMA, SARIMA and Deep Learning.
  - Best model was CNN LSTM.
  - Create time series sliding windo data.
  - Create, train, test and cross validate model to determine the best hyper-parameters for the model.
  - Run model multiple times (20-100) to get a range and distribution of possible predictions.
  - Print results and make presentation.

4- Results:
  - Distribution of volume forecast for three weeks ahead for every voyage.
  - Compare forecast with total volume of vessel and optimize load.
  
  ## Schematics of Model.
  
 ![Alt text](https://github.com/oliveiralgm/Cluster-and-Deep-Learning-in-R/blob/main/deep_learning/Model.png)
 
 ## Training results.

 ![Alt text](https://github.com/oliveiralgm/Cluster-and-Deep-Learning-in-R/blob/main/deep_learning/Train%20results%20graph.png)
 
 ## Prediction distribution results.

 ![Alt text](https://github.com/oliveiralgm/Cluster-and-Deep-Learning-in-R/blob/main/deep_learning/Prediction%20Dist.png)
  
  
  

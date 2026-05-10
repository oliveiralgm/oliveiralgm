```
  K-means clustering cut quoting turnaround ~75% vs prior baseline; CNN-LSTM produced voyage-level capacity forecasts tied to routing optimization. 
  
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
  Build clusters for clients based on commodity transported, volume and port pair (port of loading → port of destination). This way when a client requested a quote based on those three variables, there was a quote range well defined based on those clusters.

3- Actions:
  - Data cleaning to enable data quality and integrity using excel VBA routines. 
  - Meetings with major stakeholders for context and validation of variables. 
  - Actual building of model and testing results.
  - Using silhouette method to determine number of clusters
  - Associate clusters to prices
  - Meeting with stakeholders to validate the results

4- Results:
  - Reduced quoting time by around **75%** — from an average of 4 days to 1 day.
  - Was later implemented in all offices around the world.
  
## Silhouette and Cluster Graphs
  
![Tier 1 clustering results](https://raw.githubusercontent.com/oliveiralgm/oliveiralgm/main/projects/cluster_and_deep_learning_R/clustering/Clustering%20Results%20Graphs%20Tier%201.png)

![Tier 2 clustering results](https://raw.githubusercontent.com/oliveiralgm/oliveiralgm/main/projects/cluster_and_deep_learning_R/clustering/Clustering%20Results%20Graphs%20Tier%202.png)


### Deep Learning Volume Prediction

1- Situation: 
  Client wanted to be able to predict load per shipping voyage to optimize allocation of cargo for maximum revenue.

2- Task: 
  Develop a forecasting model using historical time series data.

3- Actions:
  - Clean and prepare data for models — done in Excel and VBA. 
  - Test multiple models, including ARIMA, SARIMA and deep learning.
  - Best model was CNN-LSTM.
  - Create time series sliding-window data.
  - Create, train, test and cross validate model to determine the best hyper-parameters for the model.
  - Run model multiple times (20–100) to get a range and distribution of possible predictions.
  - Print results and make presentation.

4- Results:
  - Distribution of volume forecast for three weeks ahead for every voyage.
  - Compare forecast with total volume of vessel and optimize load.
  
## Schematics of Model

![Model schematic](https://raw.githubusercontent.com/oliveiralgm/oliveiralgm/main/projects/cluster_and_deep_learning_R/deep_learning/Model.png)
 
 ## Training results

![Training curve](https://raw.githubusercontent.com/oliveiralgm/oliveiralgm/main/projects/cluster_and_deep_learning_R/deep_learning/Train%20results%20graph.png)
 
 ## Prediction distribution results

![Prediction distribution](https://raw.githubusercontent.com/oliveiralgm/oliveiralgm/main/projects/cluster_and_deep_learning_R/deep_learning/Prediction%20Dist.png)

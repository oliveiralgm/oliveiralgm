 
 ``` 
EDA and recommendations for a major heart institute in the US to help prioritize resources aimed at lowering **Medicare readmission penalties**. 

 > Libraries used:  
    - plyr,
    - RColorBrewer, 
    - treemap, 
    - wordcloud, 
    - wordcloud2, 
    - e1071 & caret (Naive Bayes Regression, Linear Regression) 
```


## Context

This engagement supported a national heart failure network weighing how to prioritize programs that blunt **Medicare readmission penalties**.

Medicare penalizes hospitals when patients are **readmitted**, so directional insight into readmission cohorts directs operational planning.

EDA and visuals were scripted in **`R`**; linear regressions plus naive Bayes were used largely for interpretability/feature importance rather than deploying a finalized scoring model.

## Portfolio note on running scripts

Historical artifacts reference a **`read.csv`** path local to an analyst machine. Path hygiene + sample data plumbing are deferred on purpose (**code untouched**)—expect to repoint ingestion before executing end-to-end.

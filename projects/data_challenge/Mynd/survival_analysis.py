'''
To determine the effect of vacancy duration on investor retention, you could perform a survival analysis on the time to churn for investors.
You could use the Kaplan-Meier estimator to estimate the survival function for investors, and then compare the survival functions for 
investors with short vacancy durations to those with long vacancy durations. You could use the log-rank test to determine 
if there is a significant difference in survival between the two groups. 
Alternatively, you could fit a Cox proportional hazards model to estimate the hazard ratio for vacancy duration, 
controlling for other factors that may affect churn risk.
'''
import sqlite3
import pandas as pd
from lifelines import KaplanMeierFitter
from lifelines.statistics import logrank_test
from lifelines import CoxPHFitter

# Load data from mynd.db
conn = sqlite3.connect('mynd.db')
properties_df = pd.read_sql_query('SELECT * FROM properties', conn)
contracts_df = pd.read_sql_query('SELECT * FROM contracts', conn)

# Create a new column in contracts_df that calculates the time to churn for each investor
contracts_df['time_to_churn'] = (contracts_df['end_date'] - contracts_df['start_date']).dt.days

# Merge properties_df and contracts_df on property_id
merged_df = properties_df.merge(contracts_df, on='property_id')

# Filter out contracts that are not churned
churned_df = merged_df.loc[merged_df['end_date'].notnull()]

# Create a new column that calculates the vacancy duration for each investor
churned_df['vacancy_duration'] = (churned_df['move_in_date'] - churned_df['offboard_date']).dt.days

# Fit a Kaplan-Meier estimator to estimate the survival function for investors
kmf = KaplanMeierFitter()
T = churned_df['time_to_churn']
E = churned_df['offboard_date'].notnull()
kmf.fit(T, event_observed=E)

# Plot the estimated survival function
kmf.plot()

# Compare the survival functions for investors with short vacancy durations to those with long vacancy durations
median_vacancy_duration = churned_df['vacancy_duration'].median()
short_vacancy_df = churned_df.loc[churned_df['vacancy_duration'] <= median_vacancy_duration]
long_vacancy_df = churned_df.loc[churned_df['vacancy_duration'] > median_vacancy_duration]

results = logrank_test(short_vacancy_df['time_to_churn'], long_vacancy_df['time_to_churn'], event_observed_A=short_vacancy_df['offboard_date'].notnull(), event_observed_B=long_vacancy_df['offboard_date'].notnull())
print(results.summary)

# Fit a Cox proportional hazards model to estimate the hazard ratio for vacancy duration
cph = CoxPHFitter()
cph.fit(churned_df[['vacancy_duration', 'bedrooms', 'bathrooms', 'square_footage', 'year_built', 'rent']], duration_col='time_to_churn', event_col='offboard_date')
print(cph.summary)

-- ABC Corp is a mid-sized insurer in the US and in the recent past their fraudulent claims have increased significantly for their personal auto insurance portfolio. 
-- They have developed a ML based predictive model to identify propensity of fraudulent claims. 
-- Now, they assign highly experienced claim adjusters for top 5 percentile of claims identified by the model.
-- Your objective is to identify the top 5 percentile of claims from each state. 
-- Your output should be policy number, state, claim cost, and fraud score.

-- table: fraud_score

-- policy_num: varchar
-- state: varchar
-- claim_cost: int
-- fraud_score: float

-- Solution
with percentile as (
select 
    policy_num
    ,state
    ,claim_cost
    ,fraud_score
    ,percent_rank() over (partition by state order by fraud_score) as percentile_fraud
from fraud_score
)
select
    policy_num
    ,state
    ,claim_cost
    ,fraud_score
from percentile
where percentile_fraud >= 0.95

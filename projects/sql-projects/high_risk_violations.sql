-- Find details of the business with the highest number of high-risk violations. 
-- Output all columns from the dataset considering business_id which consist 'high risk' phrase in risk_category column.

-- sf_restaurant_health_violations

-- business_id:int
-- business_name:varchar
-- business_address:varchar
-- business_city:varchar
-- business_state:varchar
-- business_postal_code:float
-- business_latitude:float
-- business_longitude:float
-- business_location:varchar
-- business_phone_number:float
-- inspection_id:varchar
-- inspection_date:datetime
-- inspection_score:float
-- inspection_type:varchar
-- violation_id:varchar
-- violation_description:varchar
-- risk_category:varchar




with this as (
    select
        business_id,
        rank() over (order by num_violation desc) as rank_viol
    from (
             select
                 business_id,
                 count(distinct violation_id) as num_violation
             from sf_restaurant_health_violations
             where lower(risk_category) like 'high_risk'
             group by 1) n
)
select
    v.* from this t
                 left join sf_restaurant_health_violations v
                           on v. business_id = t.business_id
where rank_viol = 1

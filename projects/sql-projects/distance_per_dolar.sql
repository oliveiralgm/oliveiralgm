-- You’re given a dataset of uber rides with the traveling distance (‘distance_to_travel’) and cost (‘monetary_cost’) for each ride. For each date, find the difference between the distance-per-dollar for that date and the average distance-per-dollar for that year-month. Distance-per-dollar is defined as the distance traveled divided by the cost of the ride.
-- The output should include the year-month (YYYY-MM) and the absolute average difference in distance-per-dollar (Absolute value to be rounded to the 2nd decimal).
-- You should also count both success and failed request_status as the distance and cost values are populated for all ride requests. Also, assume that all dates are unique in the dataset. Order your results by earliest request date first.

-- uber_request_logs

-- request_id:int
-- request_date:datetime
-- request_status:varchar
-- distance_to_travel:float
-- monetary_costfloat
-- driver_to_client_distance:float

-- Solution:

-- avg for month
-- avg for date
-- calculate distance/dollar
-- calculate the abs difference month- date, 2 decimals

with avg_month as(
    select
        concat(extract(YEAR from request_date),'-',to_char(request_date,'MM')) as yearmonth,
        avg(distance_to_travel/monetary_cost) as avg_cost_month
    from uber_request_logs
    group by yearmonth
),
     avg_date as (
         select
             request_date,
             avg(distance_to_travel/monetary_cost) as avg_cost_date
         from uber_request_logs
         group by request_date
     )
select
    distinct yearmonth,
             round((abs(avg_cost_month - avg_cost_date)::decimal),2)
from avg_date
         left join avg_month on yearmonth = concat(extract(YEAR from request_date),'-', to_char(request_date,'MM'))
order by yearmonth

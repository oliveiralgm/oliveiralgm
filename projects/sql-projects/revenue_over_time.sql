-- Find the 3-month rolling average of total revenue from purchases given a table with users, their purchase amount, and date purchased. Do not include returns which are represented by negative purchase values. Output the year-month (YYYY-MM) and 3-month rolling average of revenue, sorted from earliest month to latest month. 
-- A 3-month rolling average is defined by calculating the average total revenue from all user purchases for the current month and previous two months. The first two months will not be a true 3-month rolling average since we are not given data from last year. Assume each month has at least one purchase.

-- amazon_purchases

-- user_id: int
-- created_at: datetime
-- purchase_amt: int

-- turn date into mmmm-yy
-- sum over date
with sum_month as (select concat(extract(YEAR from created_at), '-', to_char(created_at, 'MM')) as yearmonth,
                          sum(purchase_amt)                                                     as total_amount
                   from amazon_purchases
                   where purchase_amt > 0
                   group by yearmonth)
select yearmonth,
       avg(total_amount) over (order by yearmonth rows between 2 preceding and current row) as rolling_average
from sum_month
order by yearmonth

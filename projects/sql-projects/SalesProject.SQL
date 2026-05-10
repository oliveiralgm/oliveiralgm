
-- Sql written for a complex sales report project.

-- table with store, its first cycle and today's cycle.
-- This will be used to get all the cycles between the first cycle and today's and explode to one cycle a row for each store
WITH cycles AS (SELECT
    RIGHT (cycle
   , 4) AS cycle_name
   ,
start AS cycle_start_date
    ,
end AS cycle_end_date
FROM `tabDividers Cycle`
WHERE cycle_type = 'Ad Cycle'
    )
    ,
store_cycles as (
SELECT r.dividers_store
     , r.rsvn
     , {{start}} AS store_first_cycle
     , cc.todays_cycle_name
FROM dividers_reservation r
  , (SELECT cycle_name AS todays_cycle_name
      FROM cycles
      WHERE CURRENT_DATE BETWEEN cycle_start_date AND cycle_end_date) cc
    --   where dividers_store = 'STR01923'
GROUP BY r.dividers_store, r.rsvn
)

,
all_cycles as (
select c.dividers_store
     , s.chain
     , c.rsvn as reservation_id
     , s.banner
     , s.store_number
     , s.address_line1
     , s.city
     , s.state
    , store_first_cycle
    , todays_cycle_name
    , cycles_between_cycles(store_first_cycle, todays_cycle_name) as all_cycles_concat
from `tabDividers Store` s
left join store_cycles c
on c.dividers_store = s.name
-- where docstatus < 2{{snippet: Explode Cycles}}
-- where dividers_store='STR01876'
[[ where chain = {{chain}} ]]
-- and s.name = 'STR01923'

)
,
exploded_stores as (
SELECT
    chain
     , dividers_store
     , banner
     , store_number
     , address_line1
     , city
     , state
     , reservation_id
     , list_table.all_cycles_concat
FROM all_cycles
CROSS JOIN JSON_TABLE(CONCAT('["', REPLACE(all_cycles_concat, ',', '","'), '"]'),
                      '$[*]' COLUMNS (all_cycles_concat TEXT PATH '$')) list_table
where dividers_store = {{store}}
order by dividers_store, all_cycles_concat desc
limit {{numRows}}
)
,
rsvn_data as (
select
    r.dividers_contract as contract_id
    , s.banner
    , s.store_number
    , r.customer as customer_id
    , r.customer_name
    , r.rsvn as reservation_id
    , r.start_cycle
    , r.end_cycle
    , r.dividers_store as store_id
    , round(sr.rate,0) as rate
    , c.todays_cycle_name
    , case when r.end_cycle = 0 or r.end_cycle is null then c.todays_cycle_name else r.end_cycle end as end_cycle_adjusted
from dividers_reservation r
left join `tabDividers Store` s -- store => chain
on r.dividers_store = s.name
left join dividers_store_rate as sr
on r.dividers_store = sr.dividers_store
join store_cycles c
[[ where r.dividers_store = {{store}} ]]
group by start_cycle
)
,
adjusted_dates as (
    select contract_id
        , customer_id
        , customer_name
        , reservation_id
        , store_id
        , store_number
        , banner
        , start_cycle
        , end_cycle_adjusted
        , cycles_between_cycles(start_cycle ,end_cycle_adjusted) as all_cycles_concat_rsvn
        , round(rate,0) as rate
    from rsvn_data r
    -- group by customer_id
    )
    ,
exploded_rsvn_data as (
SELECT contract_id
    , customer_id
    , customer_name
    , reservation_id
    , store_id
    , store_number
    , banner
    , round(rate,0) as rate
    , list_table.all_cycles_concat_rsvn as cycle
FROM adjusted_dates
CROSS JOIN JSON_TABLE(CONCAT('["', REPLACE(all_cycles_concat_rsvn, ',', '","'), '"]'),
                      '$[*]' COLUMNS (all_cycles_concat_rsvn TEXT PATH '$')) list_table
                      order by store_id, cycle
                      )
,
final_query as (
    SELECT
        -- s.chain
         s.dividers_store
        -- , r.store_number
        , s.all_cycles_concat
        , round(r.rate,0)
        , r.contract_id
        , r.reservation_id
        , r.banner
        , r.customer_id
        , r.customer_name
        , case when (s.all_cycles_concat like '%13') then 'SKIP' else null end as skip
        , case when (s.all_cycles_concat like '%13') then 'SKIP'
                when r.customer_id is not null then 1 else null end as total_num_payments
        , case when (s.all_cycles_concat like '%13') then 'SKIP'
             when r.customer_id is not null then round(1*r.rate,0) else null end as total_amont_payments
        from exploded_stores s
        left join exploded_rsvn_data r
            on r.cycle = s.all_cycles_concat and r.store_id = s.dividers_store and r.reservation_id = s.reservation_id
        [[ where dividers_store = {{store}} ]]
        -- -- group by s.dividers_store, s.all_cycles_concat
        order by dividers_store, all_cycles_concat desc
)
,
windowed_data as (
    select         -- s.chain
     distinct all_cycles_concat
    , dividers_store
    , contract_id
    , reservation_id
    , banner
    , customer_id
    , customer_name
    , skip
    , total_num_payments
    , total_amont_payments
    , sum(total_num_payments) over (partition by all_cycles_concat) as total_payments_per_cycle
    , sum(total_amont_payments) over (partition by all_cycles_concat) as total_amount_payments_per_cycle
from final_query
-- group by all_cycles_concat
-- having total_amount_payments_per_cycle not null
order by all_cycles_concat desc
)
select *
from windowed_data
where (total_payments_per_cycle is null and reservation_id is null)
   or (total_payments_per_cycle is not null and reservation_id is not null)



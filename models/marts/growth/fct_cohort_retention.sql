with retention_base as (
    select * from {{ ref('int_user_retention_base') }}
),

cohort_sizes as (
    -- Initial User Count at every Cohort month 每个 Cohort 初始有多少人 (Month 0 size)
    select 
        cohort_month, 
        count(distinct user_id) as num_original_users
    from {{ ref('stg_users') }}
    group by 1
)

select
    r.cohort_month,
    r.period_number, -- 0, 1, 2...
    c.num_original_users,
    count(distinct r.user_id) as num_active_users,
    -- retention computation
    round(count(distinct r.user_id) * 100.0 / c.num_original_users, 2) as retention_rate_percent
from retention_base r
left join cohort_sizes c using (cohort_month)
group by 1, 2, 3
order by 1, 2

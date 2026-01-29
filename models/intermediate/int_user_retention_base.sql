with users as (
    select user_id, cohort_month from {{ ref('stg_users') }}
),

user_activities as (
    -- 将“活跃”定义为：有登录行为 或者 订阅状态为 Active define active as login or subscription
    select distinct user_id, event_date as active_date from {{ ref('stg_events') }}
    union 
    select distinct user_id, date_day as active_date from {{ ref('int_subscription_daily_status') }} where status = 'active'
)

select
    u.user_id,
    u.cohort_month,
    date_trunc('month', ua.active_date)::date as activity_month,
    -- 计算这是第几个月 (Month 0, Month 1...) compute which month this is
    datediff('month', u.cohort_month, date_trunc('month', ua.active_date)::date) as period_number
from users u
inner join user_activities ua using (user_id)

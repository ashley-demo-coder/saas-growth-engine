{{
    config(
        materialized='incremental',
        unique_key=['date_day', 'subscription_id']
    )
}}

with date_spine as (
    -- 生成连续日期 Generate a Date Spine
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2024-12-01' as date)",
        end_date="cast('2025-12-31' as date)"
    ) }}
),

subscriptions as (
    select * from {{ ref('stg_subscriptions') }}
)

select
    ds.date_day,
    s.subscription_id,
    s.user_id,
    s.status,
    s.plan,
    -- Simple Revenue Mapping Logic
    case 
        when s.status = 'active' and s.plan = 'pro' then 100
        when s.status = 'active' and s.plan = 'basic' then 50
        when s.status = 'active' and s.plan = 'enterprise' then 500
        else 0 
    end as daily_mrr
from date_spine ds
inner join subscriptions s
    on ds.date_day >= s.valid_from
    and ds.date_day < s.valid_to

{% if is_incremental() %}
-- Lookback Window: processing Late-arriving data
-- snapshot refresh, look back 3 days
where ds.date_day >= dateadd(day, -3, (select max(date_day) from {{ this }}))
{% endif %}

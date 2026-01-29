with user_events as (
    select * from {{ ref('stg_events') }}
),

-- Count active events per user over the past 30 days. 
-- Note: Simplified to a full aggregation for demo purposes; rolling windows should be used in production.
activity_counts as (
    select
        user_id,
        count(event_id) as event_count_last_30_days,
        max(event_timestamp) as last_active_at
    from user_events
    group by 1
)

select
    user_id,
    event_count_last_30_days,
    last_active_at,
    -- active user classification logic
    case
        when event_count_last_30_days >= 20 then 'Power User'
        when event_count_last_30_days >= 5 then 'Active User'
        else 'Casual User'
    end as activity_segment
from activity_counts

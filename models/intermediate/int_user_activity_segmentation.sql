with user_events as (
    select * from {{ ref('stg_events') }}
),

-- 统计每个用户在过去30天的活跃次数（这里为了Demo简化为全量统计，实际可用滑动窗口）
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
    -- 活跃分层逻辑 active user classification logic
    case
        when event_count_last_30_days >= 20 then 'Power User'
        when event_count_last_30_days >= 5 then 'Active User'
        else 'Casual User'
    end as activity_segment
from activity_counts

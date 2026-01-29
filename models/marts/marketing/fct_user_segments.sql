with segments as (
    select * from {{ ref('int_user_activity_segmentation') }}
)

select 
    activity_segment,
    count(user_id) as num_users,
    avg(event_count_last_30_days) as avg_events
from segments
group by 1

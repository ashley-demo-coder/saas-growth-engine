select
    event_id,
    user_id,
    event_type,
    event_timestamp::timestamp as event_timestamp,
    event_timestamp::date as event_date
from {{ source('saas', 'raw_events') }}

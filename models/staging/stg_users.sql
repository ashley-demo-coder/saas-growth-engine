select
    user_id,
    created_at::timestamp as created_at,
    -- Truncating timestamp to month for cohort calculation
    date_trunc('month', created_at::timestamp)::date as cohort_month,
    country
from {{ source('saas', 'raw_users') }}

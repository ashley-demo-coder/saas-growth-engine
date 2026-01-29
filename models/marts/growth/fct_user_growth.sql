with users as (
    select * from {{ ref('stg_users') }}
)

select
    created_at::date as date_day,
    country,
    count(user_id) as new_users_count
from users
group by 1, 2
order by 1 desc

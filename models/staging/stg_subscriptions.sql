select
    id as subscription_id,
    user_id,
    plan,
    status,
    updated_at,
    dbt_valid_from as valid_from,
    coalesce(dbt_valid_to, '2099-12-31'::timestamp) as valid_to
from {{ ref('sns_subscriptions') }}

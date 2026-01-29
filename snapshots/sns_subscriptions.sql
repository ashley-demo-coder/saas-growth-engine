{% snapshot sns_subscriptions %}

{{
    config(
      target_schema='snapshots',
      unique_key='id',
      strategy='timestamp',
      updated_at='updated_at',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ source('saas', 'raw_subscriptions') }}

{% endsnapshot %}



select
    refund_id,
    payment_id,
    cast(amount_cents as numeric) / 100  as refund_eur,
    cast(created_at as timestamp)        as refunded_at
from {{ source('creator-platform', 'refunds') }}
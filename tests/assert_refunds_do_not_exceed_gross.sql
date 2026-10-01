select *
from {{ ref('int_payments_with_refunds') }}
where refunded_eur > gross_eur
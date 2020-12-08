{{ config(
    materialized='incremental',
    snowflake_warehouse='bi_large_wh',
    tags='dimensional_models'
) }}

--
-- incrementally process this table
--

select
    tripduration, starttime, stoptime, start_station_id, end_station_id
    ,bikeid, usertype, birth_year, gender, current_timestamp() meta_updated_at
from {{ ref('trips') }}

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where meta_updated_at > (select max(meta_updated_at) from {{ this }})
{% endif %}
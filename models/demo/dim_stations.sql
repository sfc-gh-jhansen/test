{{ config(
    materialized='incremental',
    unique_key='station_id',
    tags='dimensional_models'
) }}

--
-- incrementally process this table
--

select
    station_id, station_name, station_lat, station_lon, station_geo
    ,station_type, station_capacity, rental_methods, region_name
    ,borough_name, neighborhood_name, current_timestamp() meta_updated_at
from {{ ref('stations') }}

{% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  where meta_updated_at > (select max(meta_updated_at) from {{ this }})
{% endif %}
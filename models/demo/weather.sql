{{ config(
    pre_hook='use warehouse bi_large_wh',
    post_hook='use warehouse load_wh',
    tags='base_models'
) }}

--
-- populate the weather table from the reset DB
--

select v,
       convert_timezone('UTC', 'US/Eastern', v:time::timestamp_ntz) t
from {{ source('citibike_reset', 'weather_json') }}
where v:city.country::string='US'
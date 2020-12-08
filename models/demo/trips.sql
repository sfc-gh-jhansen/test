{{ config(
    snowflake_warehouse='bi_large_wh',
    post_hook='alter table demo.trips set change_tracking = true',
    tags='base_models'
) }}

--
-- populate the trips table from the reset DB
-- TODO: Figure out how to make the post_hook object name dynamic
--

select *, current_timestamp() meta_updated_at
from {{ source('citibike_reset', 'trips') }}
{{ config(
    materialized='view',
    tags='base_models'
) }}

--
-- trip data enhanced with station location data
--

with
    t as (select * from {{ ref('trips') }}),
    ss as (select * from {{ ref('stations') }}),
    es as (select * from {{ ref('stations') }})
select starttime, stoptime, start_station_id,
    ss.station_name start_station, ss.region_name start_region,
    ss.borough_name start_borough, ss.neighborhood_name start_neighborhood,
    ss.station_lat start_lat, ss.station_lon start_lon, ss.station_geo start_geo,
    end_station_id, es.station_name end_station, es.region_name end_region,
    es.borough_name end_borough, es.neighborhood_name end_neighborhood,
    es.station_lat end_lat, es.station_lon end_lon, es.station_geo end_geo,
    bikeid, usertype, birth_year, gender
from t left outer join ss on t.start_station_id = ss.station_id
    left outer join es on t.end_station_id = es.station_id

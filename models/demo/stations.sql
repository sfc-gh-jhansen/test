{{ config(tags='base_models') }}

--- 
--- materialise the station records augmented with neighborhood data
---

with s as (
    select * from {{ ref('station_json') }}
      where row_inserted = (select max(row_inserted) from {{ ref('station_json') }})),
sn as (
    select station_v,
        last_updated,
        row_inserted,
        st_point(station_v:lon::float, station_v:lat::float) station_geo,
        borough borough_name,
        neighborhood neighborhood_name
    from s inner join {{ ref('neighborhood_json') }}
    where st_within(station_geo, geo)),
r as (
    select * from {{ ref('region_json') }}
      where row_inserted = (select max(row_inserted) from {{ ref('region_json') }}))
select station_v:station_id::number station_id,
    station_v:name::string station_name,
    station_v:lat::float station_lat,
    station_v:lon::float station_lon,
    station_geo,
    station_v:station_type::string station_type,
    station_v:capacity::number station_capacity,
    station_v:rental_methods rental_methods,
    region_v:name::string region_name,
    borough_name,
    neighborhood_name,
    current_timestamp() meta_updated_at
from sn left outer join r
    on station_v:region_id::integer = region_v:region_id::integer

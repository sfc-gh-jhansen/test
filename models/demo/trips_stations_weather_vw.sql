{{ config(
    materialized='view',
    secure=true,
    tags='base_models'
) }}

--
-- connecting the trip and the weather data together
--

with
    t as (
      select * from {{ ref('trips_stations_vw') }}),
    w as (
      select date_trunc('hour', t)                     observation_time
        ,utils.degKtoC(avg(v:main.temp::float))        temp_avg_c
        ,utils.degKtoF(avg(v:main.temp::float))        temp_avg_f
        ,avg(v:wind.deg::float)                        wind_dir
        ,avg(v:wind.speed::float)                      wind_speed_mph
        ,truncate(avg(v:wind.speed::float) * 1.61, 1)  wind_speed_kph
      from {{ ref('weather') }}
      where v:city.id::int = 5128638
      group by 1)
  select *
  from t left outer join w on date_trunc('hour', starttime) = observation_time

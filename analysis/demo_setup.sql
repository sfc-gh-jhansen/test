use role dba_citibike;
use database citibike;

create or replace procedure utils.add_trips (num_records double)
  returns string
  language javascript
  execute as caller
as
$$
  var sql_command = `insert into {{ ref('trips') }}
    (
       tripduration, starttime, stoptime, start_station_id, end_station_id
      ,bikeid, usertype, birth_year, gender, meta_updated_at
    )
    with most_recent_trips_cte as
    (
      select
         tripduration, starttime, stoptime, start_station_id, end_station_id
        ,bikeid, usertype, birth_year, gender
      from {{ ref('trips') }}
      order by stoptime desc
      limit `;
  sql_command += NUM_RECORDS;
  sql_command += `
    )
    select
       tripduration, dateadd(day, 1, starttime) as starttime, dateadd(day, 1, stoptime) as stoptime, start_station_id, end_station_id
      ,bikeid, usertype, birth_year, gender, current_timestamp()
    from most_recent_trips_cte`;

  try {
    snowflake.execute({sqlText: sql_command});
    return 'Success.';
  }
  catch(err) {
    return 'Failed: ' + err
  }
$$;

create or replace procedure utils.add_update_stations (num_records double)
  returns string
  language javascript
  execute as caller
as
$$

  var sql_command = `update {{ ref('stations') }}
    set
      station_name = concat(station_name, ' ** UPDATED **')
      ,meta_updated_at = current_timestamp()
    where station_id in
    (
      with row_samples as
      (
        select station_id
        from {{ ref('stations') }} sample (`;
  sql_command += NUM_RECORDS;
  sql_command += ` rows)
      )
      select station_id from row_samples
    )`;

  try {
    snowflake.execute({sqlText: sql_command});
  }
  catch(err) {
    return 'Failed: ' + err
  }

  var sql_command = `insert into {{ ref('stations') }}
    (
      station_id, station_name, station_lat, station_lon, station_geo
      ,station_type, station_capacity, rental_methods, region_name
      ,borough_name, neighborhood_name, meta_updated_at
    )
    with most_recent_stations_cte as
    (
      select
        station_id, station_name, station_lat, station_lon, station_geo
        ,station_type, station_capacity, rental_methods, region_name
        ,borough_name, neighborhood_name
      from {{ ref('stations') }}
      order by station_id desc
      limit `
  sql_command += NUM_RECORDS;
  sql_command += `
    )
    select
        station_id + 1000, concat(station_name, ' ** NEW **'), station_lat, station_lon, station_geo
        ,station_type, station_capacity, rental_methods, region_name
        ,borough_name, neighborhood_name, current_timestamp()
    from most_recent_stations_cte`;

  try {
    snowflake.execute({sqlText: sql_command});
    return 'Success.';
  }
  catch(err) {
    return 'Failed: ' + err
  }
$$;

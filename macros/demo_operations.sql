{% macro citibike_add_trips(num_records) %}

    {% if num_records is not defined %}
        {% set num_records = 100 %}
    {% endif %}

    {% set sql -%}
        call utils.add_trips({{ num_records }});
        commit;
    {%- endset %}

    {% do run_query(sql) %}
    {% do log("Added " ~ num_records ~ " records to the Citibike trip table.", info=True) %}

{% endmacro %}

{% macro citibike_add_update_stations(num_records) %}

    {% if num_records is not defined %}
        {% set num_records = 10 %}
    {% endif %}

    {% set sql -%}
        call utils.add_update_stations({{ num_records }});
        commit;
    {%- endset %}

    {% do run_query(sql) %}
    {% do log("Updated " ~ num_records ~ " records in the Citibike stations table.", info=True) %}

{% endmacro %}

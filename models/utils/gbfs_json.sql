--- 
--- get the source data from the GBFS web feeds
---

select data,
    url, citibike.utils.fetch_http_data(url) payload,
    current_timestamp() row_inserted
from {{ ref('gbfs_config') }}

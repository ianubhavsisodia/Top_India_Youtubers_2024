/*
# Data quality tests

1. The data needs to be 99 records of youtube channels
2. The data needs 5 fields (column count test)
3. The channel name and id column must be string
   and other columns must be numerical data type (data type check)
4. Each record must be unique (dupicate count check)

*/

-- row count check
select 
count(*) as no_of_rows
from 
view_india_youtubers_2024;

-- column count check

select 
count(*) as column_count 
from 
information_schema.columns
where 
table_name = 'view_india_youtubers_2024';

-- data type check

select 
COLUMN_NAME,
DATA_TYPE
from 
information_schema.columns
where 
table_name = 'view_india_youtubers_2024';

-- duplicate count check

select 
channel_name,
count(*) as duplicate_count
from 
view_india_youtubers_2024
group by channel_name
having count (*) > 1;


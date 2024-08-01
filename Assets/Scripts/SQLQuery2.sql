/*

# Data Cleaning Steps

1. Remove unnecessary columns by only selecting the ones we need
2. Extract the Youtube channel names from the first column
3. Rename the column names

*/

--Select 
--NAME, 
--total_subscribers, 
--total_views, 
--total_videos
--from top_india_youtubers_2024;


-- CHARINDEX (allows to find the starting position of one string inside another string)

-- select Charindex('@',NAME),NAME from top_india_youtubers_2024;

-- SUBSTRING

Create view 
view_india_youtubers_2024 as

select 
cast(SUBSTRING(NAME,1, Charindex('@',NAME)-1) as varchar(100)) as channel_name,
cast(SUBSTRING(NAME,Charindex('@',NAME),LEN(NAME) - CHARINDEX('@', NAME)) as varchar(100)) as channel_id,
total_subscribers, 
total_views, 
total_videos
from 
top_india_youtubers_2024;

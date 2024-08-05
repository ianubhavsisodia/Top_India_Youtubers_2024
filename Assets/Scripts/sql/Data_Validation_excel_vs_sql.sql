/*
1, Define the Variables
2. Create CTE that rounds the avergae views per videos
3. Select the columns that are required for the analysis 
4. Order by net_profit (from highest to lowest)

*/

declare @conversionRate Float = 0.02;    -- The conversion Rate @ 2%
declare @productCost Money = 5.0;        -- The product cost @ $5
declare @campaignCost Money = 50000.0;   -- The campaign cost @ $50,000


--2.
WITH ChannelData AS(
	SELECT
		channel_name,
		total_views,
		total_videos,
		ROUND((CAST(total_views  as FLOAT)/total_videos), -4) AS rounded_avg_views_per_video
		

	FROM
		view_india_youtubers_2024
)

--3.
SELECT 
	channel_name,
	rounded_avg_views_per_video,
	(rounded_avg_views_per_video * @conversionRate) AS potential_units_sold_per_video,
	(rounded_avg_views_per_video * @conversionRate * @productCost) AS potential_revenue_per_video,
	(rounded_avg_views_per_video * @conversionRate * @productCost) - (@campaignCost) AS net_profit

FROM ChannelData

--4.
WHERE channel_name in ('T-Series',
					   'SET India', 
					   'Zee Music Company', 
					   'Goldmines', 
					   'Sony SAB')
--5.
ORDER BY  
	net_profit DESC;
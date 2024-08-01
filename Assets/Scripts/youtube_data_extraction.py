import os
import pandas as pd
from dotenv import load_dotenv
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError

# Load environment variables from .env file
load_dotenv()

# Retrieve API key from environment variables
API_KEY = os.getenv("API_KEY")  # create a .env file of your API key in the same directory.
API_VERSION = 'v3'

# Verify API key is loaded
if not API_KEY:
    raise ValueError("API key not found. Please ensure it is set in the .env file.")

# Build the YouTube service
youtube = build('youtube', API_VERSION, developerKey=API_KEY)

def get_channel_stats(youtube, channel_id):
    try:
        request = youtube.channels().list(
            part='snippet,statistics',
            id=channel_id
        )
        response = request.execute()
    except HttpError as e:
        print(f"An HTTP error occurred: {e}")
        return None

    if 'items' in response and response['items']:
        data = dict(channel_name=response['items'][0]['snippet']['title'],
                    total_subscribers=response['items'][0]['statistics']['subscriberCount'],
                    total_views=response['items'][0]['statistics']['viewCount'],
                    total_videos=response['items'][0]['statistics']['videoCount'])
        return data
    else:
        print(f"No data found for channel ID: {channel_id}")
        return None

# Read CSV into dataframe 
df = pd.read_csv("youtube_data_india.csv")

# Print the columns to inspect
print("Columns in the DataFrame:")
print(df.columns)

# Ensure 'NAME' column exists
if 'NAME' not in df.columns:
    raise KeyError("Column 'NAME' does not exist in the DataFrame. Available columns are: " + ", ".join(df.columns))

# Extract channel IDs and remove potential duplicates
channel_ids = df['NAME'].str.split('@').str[-1].unique()

# Initialize a list to keep track of channel stats
channel_stats = []

# Loop over the channel IDs and get stats for each
for channel_id in channel_ids:
    stats = get_channel_stats(youtube, channel_id)
    if stats is not None:
        channel_stats.append(stats)

# Convert the list of stats to a df
stats_df = pd.DataFrame(channel_stats)

df.reset_index(drop=True, inplace=True)
stats_df.reset_index(drop=True, inplace=True)

# Concatenate the dataframes horizontally
combined_df = pd.concat([df, stats_df], axis=1)

# Drop the 'channel_name' column from stats_df (since 'NOMBRE' already exists)
combined_df.drop('channel_name', axis=1, inplace=True)

# Save the merged dataframe back into a CSV file
combined_df.to_csv('updated_youtube_data_india.csv', index=False)

print(combined_df.head(10))

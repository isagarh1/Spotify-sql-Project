-- Data Exploration :

SELECT * FROM spotify LIMIT 10;

SELECT COUNT(*) AS total_count FROM spotify;

SELECT DISTINCT artist FROM spotify;

SELECT DISTINCT album FROM spotify;

SELECT DISTINCT album_type FROM spotify;

SELECT DISTINCT channel FROM spotify;

SELECT DISTINCT most_playedon FROM spotify;

SELECT * FROM spotify WHERE duration_min = '0';
DELETE FROM spotify WHERE duration_min = '0';

-- Data Analysis : 

--Questions: Category - Easy

--Q1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT 
	track
FROM spotify 
WHERE stream > 1000000000;
	
--Q2. List all albums along with their respective artists.

SELECT 	
	album,
	artist
FROM spotify
GROUP BY 1,2;

--Q3. Get the total number of comments for each tracks where licensed = TRUE.

SELECT
	track,
	comments
FROM spotify
WHERE licensed = TRUE
ORDER BY 2 DESC

--Q4.Find all tracks that belong to the album type single.

SELECT 
	track
FROM spotify
WHERE album_type = 'single';

--Q5. Count the total number of tracks by each artist.

SELECT 
	artist,
	COUNT(track) AS total_tracks 
FROM spotify
GROUP BY 1
ORDER BY total_tracks DESC

-- Questions: Category - Intermediate

--Q1. Calculate the average danceability of tracks in each album.

SELECT 
	album,
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC

--Q2. Find the top 5 tracks with the highest energy values.
SELECT 
	track,
	MAX(energy) highest_enery 	
FROM spotify
GROUP BY 1
ORDER BY highest_enery DESC 
LIMIT 5;

--Q3. List all tracks along with their views and likes where official_video = TRUE.

SELECT 
	track,
	SUM(views) AS total_views,
	SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY track
ORDER BY total_views DESC;

--Q4. For each album, calculate the total views of all associated tracks.

SELECT 
	album,
	track,
	SUM(views) AS total_views
FROM spotify
GROUP BY 1,2
ORDER BY total_views DESC

--Q5. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM 
(SELECT 
	track,
	--stream,
	--most_playedon,
	COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS spotify_stream,
	COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS youtube_stream
FROM spotify
GROUP BY 1
)t
WHERE spotify_stream > youtube_stream
AND 
 youtube_stream != '0'
ORDER BY spotify_stream DESC

-- Questions: Category - Advanced

--Q1. Find the top 3 most-viewed tracks for each artist using window functions.

WITH top_track AS
(SELECT 
	artist,
	track,
	SUM(views) AS most_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS ranknum
FROM spotify
GROUP BY 1,2)
SELECT * FROM top_track
WHERE ranknum <=3

--Q2. Write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	liveness
FROM spotify
WHERE liveness >
		(SELECT AVG(liveness) --0.19
		FROM spotify)

--Q3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH difference AS
(SELECT 
	album,
	MAX(energy) AS highest,
	MIN(energy) AS lowest
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest - lowest AS energy_diff
FROM difference
ORDER BY 2 DESC;

--Q4. Find tracks where the energy-to-liveness ratio is greater than 1.2.

SELECT 
	track,
	energy,
	liveness,
	energy / liveness AS energy_to_liveness
FROM spotify
WHERE energy / liveness > 1.2;

--Q5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
	likes,
	views,
	track,
	SUM(likes) OVER (ORDER BY views ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_likes
FROM spotify
ORDER BY views DESC

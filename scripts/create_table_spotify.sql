-- Project : Spotify Streaming Analysis 

-- Creating Tables :
DROP TABLE IF EXISTS spotify;

CREATE TABLE spotify(
	artist					VARCHAR(100),
	Track					VARCHAR(255),
	album					VARCHAR(255),
	album_type				VARCHAR(25),
	danceability			DECIMAL,
	energy					DECIMAL,
	loudness				DECIMAL,
	speechiness				DECIMAL,
	acousticness			DECIMAL,
	instrumentalness		DECIMAL,
	liveness				DECIMAL,
	valence					DECIMAL,
	tempo					DECIMAL,
	duration_min			DECIMAL,
	title					VARCHAR(255),
	channel					VARCHAR(100),
	views					DECIMAL,
	likes					BIGINT,
	comments				BIGINT,
	licensed				BOOLEAN,
	official_video			BOOLEAN,
	stream					BIGINT,
	energyLiveness			DECIMAL,
	most_playedon			VARCHAR(100)
);





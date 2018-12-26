

/*create databasem schema and tables*/

USE master;
GO
CREATE DATABASE ProjectGroupB;
GO

USE ProjectGroupB;
GO
CREATE SCHEMA Music; 

-------------------------------------------------------------
CREATE TABLE Music.ARTIST(
	ArtistID INT NOT NULL PRIMARY KEY,
	ArtistName VARCHAR (45) NOT NULL
);
GO
CREATE TABLE Music.GENRE (
	GenreID INT NOT NULL PRIMARY KEY,
	GenreName VARCHAR(45) NOT NULL
);
GO
CREATE TABLE Music.ALBUM(
	AlbumID INT NOT NULL PRIMARY KEY,
	AlbumName TEXT NOT NULL,
	ReleaseDate DATE
);
GO
CREATE TABLE Music.Users
	(
	UserID INT NOT NULL PRIMARY KEY,
	First_Name VARCHAR(45) NOT NULL,
	Last_Name VARCHAR(45) NOT NULL,
	Email VARCHAR(45) NOT NULL,
	UserName VARCHAR(45) NOT NULL,
	User_Password VARCHAR(45) NOT NULL,
	User_Type VARCHAR(45) NOT NULL,
	);
GO
CREATE TABLE Music.Purchases (
    PurchaseID int IDENTITY NOT NULL PRIMARY KEY,
    UserID int NOT NULL 
    REFERENCES Music.Users(UserID),
    );  
GO
CREATE TABLE Music.Favorite (
    FavoriteID int IDENTITY NOT NULL PRIMARY KEY,
    UserID int NOT NULL 
    REFERENCES Music.Users(UserID)
    ); 
GO
------------------------------------------------------------
CREATE TABLE Music.Playlist
	(
	PlaylistID INT NOT NULL PRIMARY KEY,
	Playlist_Name VARCHAR(45) NOT NULL,
	No_Of_Songs AS Music.numSongsinPlaylist(PlaylistID) ,
	UserID INT NOT NULL 
	REFERENCES Music.Users(UserID)
	);

/* FUNCTION TO CALCULATE NO_OF_SONGS*/
CREATE FUNCTION Music.numSongsinPlaylist 
(@playlistid int)
RETURNS int 
AS 
BEGIN
	DECLARE @counter int;
	SELECT @counter = COUNT(*) FROM 
		(SELECT * FROM Music.Songs_Playlist sp 
		 WHERE sp.PlaylistID = @playlistid) t;
	RETURN @counter;
END;
--------------------------------------------------------

CREATE TABLE Music.Songs
	(
	SongsID INT NOT NULL PRIMARY KEY,
	Song_Name VARCHAR(45) NOT NULL,
	Song_Artist_Name VARCHAR(45) NOT NULL,
	Rating DECIMAL(1),
	Song_Length TIME NOT NULL,
	Song_Language VARCHAR(45) NOT NULL,
	FavouriteID INT 
		REFERENCES Music.Favorite(FavoriteID),
	PurchasesID INT
		REFERENCES Music.Purchases(PurchaseID),
	GenreID INT NOT NULL
		REFERENCES Music.Genre(GenreID)  
 	);
GO
CREATE TABLE Music.Lyrics (
    LyricID int IDENTITY NOT NULL PRIMARY KEY ,
    LyricText varchar(max) NOT NULL,
    SongID int NOT NULL REFERENCES Music.Songs(SongsID)
    );
GO
   
CREATE TABLE Music.Artist_Album (
    ArtistID int NOT NULL REFERENCES Music.Artist(ArtistID),
    AlbumID int NOT NULL REFERENCES Music.Album(AlbumID),
    CONSTRAINT PKArtistAlbum 
    PRIMARY KEY CLUSTERED (ArtistID, AlbumID)
    );
GO 
CREATE TABLE Music.Album_Genre(
	AlbumID int NOT NULL REFERENCES Music.Album(AlbumID),
	GenreID int NOT NULL REFERENCES Music.Genre(GenreID),
	Album_Genre int NOT NULL CONSTRAINT PKAlbumGenre 
	PRIMARY KEY CLUSTERED (AlbumID, GenreID)
);
GO
CREATE TABLE Music.Artist_Genre(
	ArtistID INT NOT NULL
	REFERENCES Music.Artist(ArtistID),
	GenreID INT NOT NULL
	REFERENCES Music.Genre(GenreID),
	CONSTRAINT PKArtist_Genre PRIMARY KEY CLUSTERED
	(ArtistID, GenreID)
	);
GO
CREATE TABLE Music.Songs_Playlist(
	SongsID INT NOT NULL
	REFERENCES Music.Songs(SongsID),
	PlaylistID INT NOT NULL
	REFERENCES Music.Playlist(PlaylistID),
	CONSTRAINT PKSongs_Playlist PRIMARY KEY CLUSTERED
	(SongsID, PlaylistID)
	);
GO
CREATE TABLE Music.Songs_Album(
	SongsID INT NOT NULL
	REFERENCES Music.Songs(SongsID),
	AlbumID INT NOT NULL
	REFERENCES Music.Album(AlbumID),
	CONSTRAINT PKSongs_Album PRIMARY KEY CLUSTERED
	(SongsID, AlbumID)
	);

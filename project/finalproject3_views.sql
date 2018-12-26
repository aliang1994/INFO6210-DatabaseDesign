
USE ProjectGroupB;



-- VIEWS
CREATE VIEW Music.Artist_Album_Song AS
SELECT a.ArtistName, b.AlbumName, s.Song_Name
FROM Music.Artist AS a
INNER JOIN Music.Artist_Album AS aa
ON a.ArtistID = aa.ArtistID
INNER JOIN Music.Album b 
ON aa.AlbumID = b.AlbumID
INNER JOIN Music.Songs_Album sa
ON sa.AlbumID = b.AlbumID
INNER JOIN Music.Songs s
ON s.SongsID = sa.SongsID;

SELECT * FROM Music.Artist_Album_Song;





CREATE VIEW Music.User_Favourite_Song AS
SELECT u.First_Name, u.Last_Name, s.Song_Name
FROM Music.Users as u
INNER JOIN Music.Favorite as f
ON u.UserID = f.UserID
INNER JOIN Music.Songs as s
ON s.FavouriteID = f.FavoriteID;


SELECT * FROM Music.User_Favourite_Song;





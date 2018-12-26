
USE ProjectGroupB;

/*populate tables*/
   
--genre
INSERT INTO Music.GENRE(GenreID,GenreName)
VALUES ('121','Rock'),
		('122','Pop'),
		('123','Hip Hop'),
		('124','Classical'),
		('125','Jazz'),
		('126','Reggae'),
		('127','Metal'),
		('128','Country'),
		('129','Electronic Dance Music'),	
		('130','Blues');
	

	
--artist

INSERT INTO Music.ARTIST(ArtistID,ArtistName)
VALUES ('130','Michael Jackson'),
		('131','Charlie Puth'),
		('132','Rihanna'),
		('133','Led Zeppelin'),
		('134','Backstreet Boys'),
		('135','Coldplay'),
		('136','Imagine Dragons'),
		('137','Maroon5'),
		('138','Pink Floyd'),
		('139','The Chainsmokers');

	
	 	
--album
INSERT INTO Music.ALBUM(AlbumID,AlbumName,ReleaseDate)
VALUES ('150','Thriller','11-30-1982'),
	('151','Millennium','05-18-1999'),
	('152','Collage','11-04-2016'),
	('153','Talk That Talk','11-18-2011'),
	('154','The Dark Side of the Moon','03-01-1973'),
	('155','Evolve','06-23-2017'),
	('156','V','08-29-2014'),
	('157','Led Zeppelin IV','11-08-1971'),
	('158','A Head Full of Dreams','12-04-2015'),
	('159','Nine Track Mind','01-29-2016');

-- songs


INSERT Music.Songs (SongsID, Song_Name, Song_Artist_Name, Rating, Song_Length, Song_Language, FavoriteID, PurchasesID, GenreID)
	VALUES	(110,'How Long','Charlie Puth','4.0','00:05:40','English',12, 8, 122),
			(111,'Stairway to heaven','Led Zepplin','4.1','00:04:10','English', 1, 2, 127),
			(112,'Thriller','Michael Jackson','4.2','00:06:30','English', 12, 5, 123),
			(113,'I want it that way','Backstreet Boys','4.3','00:04:30','English',2, 9, 122),
			(114,'Dont let me down','The Chainsmokers','4.4','00:07:00','English', 3, 1, 129),
			(115,'Paradise','Coldplay','4.5','00:06:50','English', 6, 4, 121),
			(116,'One more night','Maroon 5','4.6','00:05:30','English', 10, 3, 126),
			(117,'Whatever it takes','Imagine Dragons','4.7','00:05:40','English', 13, 10, 129),
			(118,'Work Work Work','Rihanna','4.8','00:04:48', 'English', 5, 7, 123),
			(119,'Comfortably numb','Pink Floyd','4.9','00:03:45', 'English', 7, 6, 121);

		
		
--users		
		
		
/*users password column encryption*/

CREATE MASTER KEY ENCRYPTION BY 
PASSWORD = 'Project@12345B';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE Project_B_Certificate
WITH SUBJECT = 'Project B Test Certificate',
EXPIRY_DATE = '2020-12-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY Project_B_SymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE Project_B_Certificate;

-- Open symmetric key
OPEN SYMMETRIC KEY Project_B_SymmetricKey
DECRYPTION BY CERTIFICATE Project_B_Certificate;


ALTER TABLE Music.Users 
ALTER COLUMN User_Password varchar(max);

-- insert values
INSERT Music.Users(UserID, First_Name, Last_Name, Email, UserName, User_Password, User_Type)
VALUES	(100,'Nirav','Patel','patel.nirav@gmail.com','nirav100',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'nirav12345')),'Standard'),
		(101,'Ameya','Patankar','patankar.ameya@gmail.com','ameya101',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'ameya12345')),'Standard'),
		(102,'Wenqing','Liang','liang.wenqing@gmail.com','wenqing102',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'wenqing12345')),'Premium'),
		(103,'Smeet','Patel','patel.smeet@gmail.com','smeet103',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'smeet12345')),'Premium'),
		(104,'Udayan','Anand','anand.udayan@gmail.com','udayan104',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'udayan12345')),'Standard'),
		(105,'Vijay','Nimbalkar','nimbalkar.vijay@gmail.com','vijay105',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'vijay12345')),'Student'),
		(106,'Saikiran','Yelshetty','yelshetty.saikiran@gmail.com','saikiran106',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'saikiran12345')),'Premium'),
		(107,'Harsh','Bansal','bansal.harsh@gmail.com','harsh107',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'harsh12345')),'Student'),
		(108,'Pankaj','Sahani','sahani.pankaj@gmail.com','pankaj108',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'pankaj12345')),'Standard'),
		(109,'Dheeraj','Shetty','shetty.dheeraj@gmail.com','dheeraj109',EncryptByKey(Key_GUID(N'Project_B_SymmetricKey'), convert(varbinary, 'dheeraj12345')),'Student');

		
SELECT * FROM Music.Users;

SELECT DecryptByKey(User_Password) 
FROM Music.Users;

SELECT CONVERT(VARCHAR, DecryptByKey(User_Password)) 
FROM Music.Users;


-------------------------------------------------------------------
		


--playlist
INSERT Music.Playlist (PlaylistID, Playlist_Name, UserID)
VALUES	(1111,'ABC', 109),
		(1112,'BCD', 108),
		(1113,'CDE', 107),
		(1114,'DEF', 106),
		(1115,'EFG', 105),
		(1116,'FGH', 104),
		(1117,'GHI', 103),
		(1118,'HIJ', 102),
		(1119,'IJK', 101),
		(1120,'JKL', 100);


	
--Lyrics

INSERT INTO Music.Lyrics(LyricText, SongID) 
VALUES ('hello from the other side', 112),
		('I must have called a thousand times', 110),
		('To tell you Im sorry for everything that Ive done', 118),
		('But when I call you never seem to be home', 111),
		('hello its me', 113),
		('Im in California dreaming about who we used to be', 115),
		('When we were younger and free', 117),
		('Ive forgotten how it felt before the world fell at our feet', 116),
		('Theres such a difference between us', 119),
		('And a million miles', 114);






--Artist_Album
INSERT INTO Music.Artist_Album(ArtistID, AlbumID)
VALUES (130, 150),
	   (131, 159),
	   (132, 153),
	   (133, 157),
	   (134, 151),
	   (135, 158),
	   (136, 155),
	   (137, 156),
	   (138, 154),
	   (139, 152);
	  
	  
	  
--Album_Genre
INSERT INTO Music.Album_Genre(AlbumID, GenreID)
VALUES (150, 123),
	   (151, 122),
	   (152, 129),
	   (153, 123),
	   (154, 121),
	   (155, 129),
	   (156, 126),
	   (157, 127),
	   (158, 121),
	   (159, 122);
	  
	  
--Artist_Genre
INSERT INTO Music.Artist_Genre(ArtistID, GenreID)
VALUES (130, 123),
	   (131, 122),
	   (132, 123),
	   (133, 127),
	   (134, 122),
	   (135, 121),
	   (136, 129),
	   (137, 126),
	   (138, 121),
	   (139, 129);
					
	  
	  
		
	  
INSERT INTO Music.Songs_Album(SongsID, AlbumID)
VALUES(110, 159),
	  (111, 157),
	  (112, 150),
	  (113, 151),
	  (114, 152),
	  (115, 158),
	  (116, 156),
	  (117, 155),
	  (118, 153),
	  (119, 154);



--Purchases

INSERT INTO Music.Purchases(UserID) 
VALUES (101), 
	  (102),
	  (103),
	  (100),
	  (101),
	  (104),
	  (105),
	  (103),
	  (103),
	  (106),
	  (107),
	  (108),
	  (109);
	 


---Favorites
INSERT INTO Music.Favorite(UserID) 
VALUES (101), 
	  (102),
	  (103),
	  (100),
	  (101),
	  (104),
	  (105),
	  (103),
	  (103),
	  (106),
	  (107),
	  (108),
	  (109);
						
	  
--Songs_Playlist
INSERT INTO Music.Songs_Playlist(SongsID, PlaylistID)
VALUES (110, 1120),
	   (111, 1120),
	   (112, 1120),
	   (111, 1111),
	   (113, 1111),
	   (112, 1112),
	   (114, 1112),
	   (115, 1112),
	   (116, 1113),
	   (117, 1114),
	   (115, 1114),
	   (114, 1114),
	   (118, 1114),
	   (112, 1115),
	   (112, 1117),
	   (112, 1116),
	   (114, 1116),
	   (115, 1116),
	   (116, 1117),
	   (117, 1117),
	   (112, 1118),
	   (113, 1118),
	   (112, 1119),
	   (115, 1119);	

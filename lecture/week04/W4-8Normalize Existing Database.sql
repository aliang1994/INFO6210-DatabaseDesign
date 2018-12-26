
/* Normalize Existing Database */

-- Set up the demo DB

CREATE DATABASE ExistingDB;
GO
USE ExistingDB;

CREATE TABLE [dbo].[Products](
	[ProductID] [int] NULL,
	[Name] [varchar](50) NULL,
	[UnitPrice] [money] NULL,
	[Color1] [varchar](20) NULL,
	[Color2] [varchar](20) NULL,
	[Color3] [varchar](20) NULL,
	[Color4] [varchar](20) NULL,
	[Color5] [varchar](20) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (520, N'LL Touring Seat Assembly', 133.3400, N'Yellow', N'Red', N'Green', NULL, NULL)
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (680, N'HL Road Frame - Black, 58', 1431.5000, N'Black', N'White', N'Red', N'Purple', N'Brown')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (720, N'HL Road Frame - Red, 52', 1431.5000, N'Red', N'Pink', N'Black', N'Green', NULL)
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (760, N'Road-650 Red, 60', 782.9900, N'Red', N'Yellow', N'Purple', N'Silver', N'Green')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (800, N'Road-550-W Yellow, 44', 1120.4900, N'Yellow', N'White', N'Black', NULL, NULL)
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (840, N'HL Road Frame - Black, 52', 1431.5000, N'Black', N'Red', N'Yellow', N'Pink', N'Brown')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (880, N'Hydration Pack - 70 oz.', 54.9900, N'Silver', N'White', N'Red', N'Green', N'Black')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (920, N'LL Mountain Frame - Silver, 52', 264.0500, N'Silver', N'Black', N'Gold', N'Purple', N'Red')
GO
INSERT [dbo].[Products] ([ProductID], [Name], [UnitPrice], [Color1], [Color2], [Color3], [Color4], [Color5]) VALUES (960, N'Touring-3000 Blue, 62', 742.3500, N'Blue', N'Yellow', N'Red', N'Silver', NULL)
GO

-- See what we have in the existing database
SELECT * FROM dbo.Products;

-- Use SQL UNPIVOT and SELECT DISTINCT to normalize the existing DB

SELECT ProductID, Color

into dbo.ColorOnly  -- New normalized color table

FROM
(
  SELECT ProductID, Color1, Color2, Color3, Color4, Color5
  FROM dbo.Products
) AS original
UNPIVOT 
(
  Color FOR Colors IN (Color1, Color2, Color3, Color4, Color5)
  /* Create a new row for every value found in the columns 
     Color1, Color2, Color3, Color4 and Color5 */

) AS unp;


select distinct ProductID, Name, UnitPrice
into dbo.ProductOnly -- New normalized product table
from dbo.Products;

-- See the normalized DB

SELECT * FROM dbo.ProductOnly;

SELECT * FROM dbo.ColorOnly;

-- Do housekeeping

USE Master;
DROP DATABASE ExistingDB;


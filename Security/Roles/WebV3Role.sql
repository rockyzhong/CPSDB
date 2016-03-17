CREATE ROLE [WebV3Role]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'WebV3Role', N'SPSAdmin'
GO

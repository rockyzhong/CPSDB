SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_GetGamblersAddictionIsoList]
@IsoId     bigint,
@BeginDate datetime,
@EndDate   datetime,
@TimeZone  varchar(50)

WITH EXECUTE AS 'dbo'
AS
BEGIN
  DECLARE @SQL nvarchar(max)
  SELECT @BeginDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @BeginDate, 20) + ' ' + @TimeZone,'+00:00'))
  SELECT @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
  SET @SQL='
  SELECT CASE WHEN LEN(g.SSN)>0 THEN ''XX-XX-''+RIGHT(RTRIM(g.SSN),4) ELSE g.SSN END SSN,i.RegisteredName,Convert(datetime,SWITCHOFFSET(CONVERT(VARCHAR, g.UpdatedDate, 20) + '' '' + ''+00:00'',@TimeZone)) UpdatedDate,CASE WHEN IdState=''O1'' THEN ''N/A'' ELSE IdState END AS IdState,CASE WHEN IdState=''O1'' THEN ''N/A'' ELSE IdNumber END AS IdNumber,FirstName,LastName,CONVERT(NVARCHAR(10),Birthday,111) AS BOD,c.CountryFullName
  FROM dbo.tbl_GamblersAddictionIso g
  JOIN dbo.tbl_Iso i ON i.Id=g.IsoId
  LEFT JOIN dbo.tbl_country c ON c.Id=g.CountryId
  WHERE g.UpdatedDate>=@BeginDate AND g.UpdatedDate<=@EndDate'
  IF @IsoId IS NOT NULL SET @SQL=@SQL+' AND g.IsoId=@IsoId'
  EXEC sp_executesql @SQL,N'@IsoId bigint,@BeginDate datetime,@EndDate datetime,@TimeZone varchar(50)',@IsoId,@BeginDate,@EndDate,@TimeZone
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_GetGamblersAddictionCardList] 
@BeginDate datetime = '1900-01-01',
@EndDate   datetime = '3999-12-30',
@TimeZone  varchar(50) = '+00:00'
AS
BEGIN
  SET NOCOUNT ON
  SELECT @BeginDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @BeginDate, 20) + ' ' + @TimeZone,'+00:00'))
  SELECT @EndDate=Convert(datetime, SWITCHOFFSET(CONVERT(VARCHAR, @EndDate, 20) + ' ' + @TimeZone,'+00:00'))
 -- OPEN SYMMETRIC KEY sk_EncryptionKey DECRYPTION BY CERTIFICATE ec_EncryptionCert 
  OPEN SYMMETRIC KEY SymKey_SPS_20150825 DECRYPTION BY ASYMMETRIC KEY AsymKey_SPS_20150825
  SELECT CONVERT(nvarchar(max),DECRYPTBYKEY(g.CustomerMediaDataEncrypted)) CardNumber,Convert(datetime,SWITCHOFFSET(CONVERT(VARCHAR, UpdatedDate, 20) + ' ' + '+00:00',@TimeZone)) UpdatedDate,u.FirstName+' '+u.LastName UpdatedUser 
  FROM dbo.tbl_GamblersAddictionCard g
  JOIN dbo.tbl_upm_User u ON u.Id=g.UpdatedUserId
  WHERE UpdatedDate>=@BeginDate AND UpdatedDate<=@EndDate AND Active = 1
END
GO

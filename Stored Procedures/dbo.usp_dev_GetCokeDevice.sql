SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetCokeDevice] (@MerchantId NVARCHAR(15),@TerminalName nvarchar(16))
WITH EXECUTE AS 'dbo'
AS
BEGIN
  SELECT dc.MERCID mid,dc.TERMID tid,dci.tc,dci.tti,s.TIMEZONE,s.ADDRESS1,s.ADDRESS2,s.CITYNAME city,s.PRVALPHA2 state,s.COUNTRY,s.POSTAL,
  dci.RTLID retailerid,dci.RTLGROUP retailerGroup,dci.RTLRGN retailerregion,dc.INDICATORS Status,dc.ALTCATEGORY category,'' salesOrg FROM dbo.tbl_DeviceCoke dc JOIN dbo.tbl_DeviceCokeIDP dci ON dc.TERMID=dci.TERMID JOIN dbo.tbl_DeviceCokeSite s ON dc.siteid=s.siteid
  WHERE dc.MERCID=@MerchantId AND dc.TERMID=@TerminalName
END
GO

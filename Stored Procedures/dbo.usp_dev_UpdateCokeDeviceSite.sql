SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_UpdateCokeDeviceSite]
	@SiteId NVARCHAR(8),
    @MerchantId NVARCHAR(15),
	@PosixTimeSec INT,
	@Address1 NVARCHAR(40),
	@Address2 NVARCHAR(40),
	@ProfitCenter NVARCHAR(40),
	@City NVARCHAR(40),
	@State NVARCHAR(2),
	@Postal NVARCHAR(20),
	@Contact NVARCHAR(40),
	@Phone NVARCHAR(30),
	@Country NVARCHAR(3) 
	AS
    BEGIN
	UPDATE dbo.tbl_DeviceCokeSite SET MERCID=@MerchantId,MODIFIED=@PosixTimeSec,ADDRESS1=@Address1,ADDRESS2=@Address2,ADDRESS3=@ProfitCenter,
	CITYNAME=@City,PRVALPHA2=@State,POSTAL=@Postal,CONTACT=@Contact,CONTACTPHNO=@Phone,COUNTRY=@Country WHERE SITEID=@SiteId
    END
GO

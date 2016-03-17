SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceCokeSite]
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
	INSERT INTO dbo.tbl_DeviceCokeSite
	        ( SITEID ,
	          MERCID ,
	          CREATED ,
	          ADDRESS1 ,
	          ADDRESS2 ,
	          ADDRESS3 ,
	          CITYNAME,
			  PRVALPHA2,
			  POSTAL,
			  CONTACT,
			  CONTACTPHNO,
			  COUNTRY
	        )
	VALUES  ( @SiteId,@MerchantId,@PosixTimeSec,@Address1,@Address2,@ProfitCenter,@City,@State,@Postal,@Contact,@Phone,@Country
	        )
	 
    END
GO

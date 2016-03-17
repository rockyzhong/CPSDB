SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[usp_dev_InsertCokeDevicesWorkingKey]
	@Id NVARCHAR(32),
	@CurrKey TINYINT,
	@PrevKey NVARCHAR(76),
	@CountUsed SMALLINT,
	@UpatedDate BIGINT
	AS
    BEGIN
	INSERT INTO dbo.tbl_DeviceCokeKeyWorking
	        ( Id ,
	          CurrKey ,
	          PrevKey ,
	          CountUsed ,
	          UpatedDate
	        )
	VALUES  ( @Id , -- Id - varchar(32)
	          @CurrKey , -- CurrKey - varchar(76)
	          @PrevKey , -- PrevKey - varchar(76)
	          @CurrKey, -- CountUsed - smallint
	          @UpatedDate  -- UpatedDate - bigint
	        )
    END
GO

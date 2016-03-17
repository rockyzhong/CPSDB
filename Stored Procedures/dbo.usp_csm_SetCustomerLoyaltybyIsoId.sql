SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_SetCustomerLoyaltybyIsoId] 
  @IsoId      BIGINT,
  @IdNumber   NVARCHAR(30),
  @Idstate    NVARCHAR(20),
  @Track1     NVARCHAR(79),
  @Track2     NVARCHAR(40),
  @PIN        VARBINARY(1024),
  @UpdateUserId BIGINT
AS
BEGIN 
  SET NOCOUNT ON
  DECLARE @Cid BIGINT,@err_message NVARCHAR(200)
  IF EXISTS (SELECT Id FROM dbo.tbl_Customer WHERE IdNumber=@IdNumber AND IdState=@Idstate)
  BEGIN
  SELECT @Cid=Id FROM dbo.tbl_Customer WHERE IdNumber=@IdNumber AND IdState=@Idstate
    IF EXISTS(SELECT Id FROM dbo.tbl_CustomerLoyalty WHERE IsoId=@IsoId AND CustomerId=@Cid)
	UPDATE dbo.tbl_CustomerLoyalty SET Track1=@Track1,Track2=@Track2, PIN=@PIN,UpdatedUserId=@UpdateUserId,UpdateTime=GETUTCDATE()
	WHERE IsoId=@IsoId AND CustomerId=@Cid
	ELSE
    INSERT INTO dbo.tbl_CustomerLoyalty
            ( IsoId ,
              CustomerId ,
              Track1 ,
			  Track2 ,
              PIN ,
              UpdatedUserId ,
              UpdateTime
            )
    VALUES  ( @IsoId , -- IsoId - bigint
              @Cid , -- CustomerId - bigint
              @Track1 ,  
			  @Track2 ,
              @PIN , -- PIN - nvarchar(512)
              @UpdateUserId , -- UpdatedUserId - bigint
              GETUTCDATE()  -- UpdateTime - datetime
            )
  END
  ELSE 
    BEGIN
    SET @err_message = 'IdNumber:'+@IdNumber + ' and Idstate:' + @Idstate + ' are not found in Customer table'
	RAISERROR (@err_message, 11,1)
	END
END
GO

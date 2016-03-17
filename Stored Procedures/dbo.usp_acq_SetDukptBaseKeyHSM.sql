SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_SetDukptBaseKeyHSM] 
@MasterKeyId BIGINT,
@SchemaId BIGINT,
@Cryptogram NVARCHAR(80),
@CheckDigits NVARCHAR(16)
AS
BEGIN
  SET NOCOUNT ON
  IF NOT EXISTS( SELECT id FROM dbo.tbl_AcqDukptBaseKeyHSM WHERE MasterKeyId=@MasterKeyId AND SchemaId=@SchemaId)
  INSERT INTO dbo.tbl_AcqDukptBaseKeyHSM
          ( MasterKeyId ,
            SchemaId ,
            Cryptogram ,
            CheckDigits ,
            AssignedDate
          )
  VALUES  ( @MasterKeyId,  
            @SchemaId,  
            @Cryptogram, -- SchemaId - bigint
            @CheckDigits,  
            GETUTCDATE()
          )
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_GetDukptBaseKeyHSM]
@MasterKeyId   BIGINT=null 
AS
BEGIN
  SET NOCOUNT ON
  IF @MasterKeyId IS NULL
  SELECT MasterKeyId,SchemaId,Cryptogram,CheckDigits FROM dbo.tbl_AcqDukptBaseKeyHSM 
  ELSE
  SELECT MasterKeyId,SchemaId,Cryptogram,CheckDigits FROM dbo.tbl_AcqDukptBaseKeyHSM WHERE MasterKeyId=@MasterKeyId

END
GO

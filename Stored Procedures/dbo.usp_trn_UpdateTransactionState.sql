SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_UpdateTransactionState]
  @DeviceName             nvarchar(50)
 ,@DeviceSequence         bigint
 ,@DeviceDate             datetime
 ,@CustomerMediaData      nvarchar(200)
 ,@TransactionState        bigint
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @DeviceId bigint,@CustomerMediaDataHash varbinary(512)
  SELECT @DeviceId=Id FROM dbo.tbl_Device WHERE TerminalName=@DeviceName
  EXEC dbo.usp_sys_Hash @CustomerMediaData,@CustomerMediaDataHash OUT

  UPDATE dbo.tbl_trn_Transaction SET TransactionState=@TransactionState
  WHERE CustomerMediaDataHash=@CustomerMediaDataHash AND DeviceId=@DeviceId AND DeviceSequence=@DeviceSequence 
 
  RETURN 0
END
GO

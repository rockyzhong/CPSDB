SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_iso_UpdateIsoTitle31]
@IsoTitle31Id     bigint,
@IsoId            bigint,
@ServiceUrl       nvarchar(100),
@EntityUID        nvarchar(10),
@CasinoID         nvarchar(1),
@TransactionCode  nvarchar(8),
@Flow             nvarchar(3),
@LogType          nvarchar(5),
@CashAdvance      bit,
@Encrypt          bit,
@Status           bit,
@UpdatedUserId    bigint
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @Flow0 bigint,@LogType0 bigint
  SELECT @Flow0=Value FROM dbo.tbl_TypeValue WHERE Typeid=133 AND Name=@Flow
  SELECT @LogType0=Value FROM dbo.tbl_TypeValue WHERE Typeid=135 AND Name=@LogType

  UPDATE dbo.tbl_IsoTitle31 SET 
  IsoId=@IsoId,ServiceUrl=@ServiceUrl,EntityUID=@EntityUID,CasinoID=@CasinoID,TransactionCode=@TransactionCode,Flow=@Flow0,
  LogType=@LogType0,CashAdvance=@CashAdvance,Encrypt=@Encrypt,Status=@Status,UpdatedUserId=@UpdatedUserId 
  WHERE Id=@IsoTitle31Id
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_UpdateIsoTitle31] TO [WebV4Role]
GO

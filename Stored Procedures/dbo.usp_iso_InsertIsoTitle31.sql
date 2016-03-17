SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_iso_InsertIsoTitle31]
@IsoTitle31Id     bigint OUTPUT,
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
  
  INSERT INTO dbo.tbl_IsoTitle31(IsoId,ServiceUrl,EntityUID,CasinoID,TransactionCode,Flow,LogType,CashAdvance,Encrypt,Status,UpdatedUserId)
  VALUES(@IsoId,@ServiceUrl,@EntityUID,@CasinoID,@TransactionCode,@Flow0,@LogType0,@CashAdvance,@Encrypt,@Status,@UpdatedUserId)
  SELECT @IsoTitle31Id=IDENT_CURRENT('tbl_IsoTitle31')
 -- EXEC usp_acq_InsertISOUpdateCommands @SmartAcquireId,@IsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_iso_InsertIsoTitle31] TO [WebV4Role]
GO

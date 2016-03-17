SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_trn_UpdateTransactionImageData]
  @TransactionId           BIGINT
 ,@TransactionDate         datetime                    
 ,@Imagedata               varbinary(MAX)
 ,@ExtendedColumn          NVARCHAR(200) =NULL
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_trn_TransactionreExtendedColumn SET ImageData=@Imagedata,ExtendedColumn=@ExtendedColumn
  WHERE TranId=@TransactionId
 
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateTransactionImageData] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_UpdateTransactionImageData] TO [WebV4Role]
GO

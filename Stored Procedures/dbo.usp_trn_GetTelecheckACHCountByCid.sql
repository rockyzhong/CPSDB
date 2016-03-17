SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetTelecheckACHCountByCid]
@CustomerId BIGINT
AS
BEGIN
SET NOCOUNT ON 
SELECT CustomerId,tc.FirstName,tc.LastName,EnrollDate,ACHTransCount,CONVERT(MONEY,ACHTransAmount)/100,NonACHTransCount,CONVERT(MONEY,NonACHTransAmount)/100 FROM dbo.tbl_trn_TransactionTeleCheckACHCount tt 
  JOIN dbo.tbl_Customer tc ON tt.CustomerId=tc.Id
  WHERE tt.CustomerId=@CustomerId
END
GO

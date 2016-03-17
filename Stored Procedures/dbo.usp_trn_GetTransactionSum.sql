SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_trn_GetTransactionSum] 
@CustomerId bigint,
@IsoId      bigint,
@BeginDate  datetime,
@EndDate    datetime,
@Sum1       money OUTPUT,
@Sum2       money OUTPUT,
@CheckCount       Int OUTPUT,
@CardCount       Int OUTPUT
AS
BEGIN
  SELECT @Sum1=SUM(AmountRequest),@CheckCount=COUNT(t.Id) 
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.CustomerId=@CustomerId
    AND t.SystemDate>=@BeginDate AND t.SystemDate<@EndDate
    AND t.TransactionType IN (52,54,56,61,63) AND t.PayoutStatus IN (3,4,5) AND t.ResponseCodeInternal=0
    AND d.IsoId=@IsoId
    
  SELECT @Sum2=SUM(AmountRequest) ,@CardCount=COUNT(t.Id) 
  FROM dbo.tbl_trn_Transaction t
  LEFT JOIN dbo.tbl_Customer c ON t.CustomerId=c.Id 
  LEFT JOIN dbo.tbl_Device d ON t.DeviceId=d.Id
  WHERE t.CustomerId=@CustomerId
    AND t.SystemDate>=@BeginDate AND t.SystemDate<@EndDate
    AND t.TransactionType IN (7,9) AND t.PayoutStatus IN (3,4,5) AND t.ResponseCodeInternal=0
    AND d.IsoId=@IsoId
    
  IF @Sum1 IS NULL  SET @Sum1=0
  IF @Sum2 IS NULL  SET @Sum2=0
    IF @CheckCount IS NULL  SET @CheckCount=0
  IF @CardCount IS NULL  SET @CardCount=0
END
GO
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionSum] TO [SAV4Role]
GRANT EXECUTE ON  [dbo].[usp_trn_GetTransactionSum] TO [WebV4Role]
GO

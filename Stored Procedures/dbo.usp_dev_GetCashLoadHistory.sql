SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetCashLoadHistory]
@DeviceId          bigint,
@PageSize          bigint,
@PageNumber        bigint,
@Count             bigint OUTPUT
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @StartRow bigint,@EndRow bigint
  SET @StartRow=(@PageNumber-1)*@PageSize+1
  SET @EndRow  =@PageNumber*@PageSize+1
  
  SELECT @Count=COUNT(*) FROM dbo.tbl_CashLoadHistory WHERE DeviceId=@DeviceId;
  
  WITH CashLoadHistory AS (
  SELECT DeviceId,CassetteId,ReplenishmentDate,ReplenishmentCount,Currency,MediaCode,MediaValue,OldCount,ROW_NUMBER() OVER(ORDER BY ReplenishmentDate DESC) AS RowNumber
  FROM dbo.tbl_CashLoadHistory
  WHERE DeviceId=@DeviceId
  )

  SELECT DeviceId,CassetteId,ReplenishmentDate,ReplenishmentCount,Currency,MediaCode,MediaValue,OldCount
  FROM CashLoadHistory WHERE RowNumber>=@StartRow AND RowNumber<@EndRow ORDER BY ReplenishmentDate DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetCashLoadHistory] TO [WebV4Role]
GO

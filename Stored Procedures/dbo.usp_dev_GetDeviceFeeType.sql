SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFeeType] 
--@FeeType bigint
AS
BEGIN
  SET NOCOUNT ON

  SELECT f.FeeType,f.TransactionType,f.DebitCredit
  FROM tbl_DeviceFeeType f
  --LEFT JOIN dbo.tbl_TypeValue tv1 ON tv1.TypeId=19  AND tv1.Value=f.TransactionType
  --LEFT JOIN dbo.tbl_TypeValue tv2 ON tv2.TypeId=147 AND tv2.Value=f.DebitCredit
 -- WHERE FeeType=@FeeType
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFeeType] TO [WebV4Role]
GO

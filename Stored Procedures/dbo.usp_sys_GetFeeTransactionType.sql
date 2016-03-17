SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetFeeTransactionType]
AS
BEGIN
  SELECT Name,Value,Description FROM dbo.tbl_TypeValue WHERE TypeId=19 AND Value<100 AND Value NOT IN (4,5,6,8,14,18,19,57,58,59,60,62,63,64)
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetFeeTransactionType] TO [WebV4Role]
GO

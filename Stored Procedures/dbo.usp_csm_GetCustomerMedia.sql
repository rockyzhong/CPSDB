SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerMedia] (
@CustomerId              bigint
)
AS
BEGIN
  SET NOCOUNT ON
  SELECT Id CustomerMediaId,CustomerId,CustomerMediaType,CustomerMediaDataPart1,CustomerMediaDataPart2,CustomerMediaDataHash,CustomerMediaExpiryDate
  FROM dbo.tbl_CustomerMedia WHERE CustomerId=@CustomerId
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetCustomerMedia] TO [WebV4Role]
GO

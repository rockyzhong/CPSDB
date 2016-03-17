SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_csm_GetCustomerMembership] (@IsoId bigint,@CustomerId bigint)
AS
BEGIN
    SET NOCOUNT ON
    SELECT MembershipNumber FROM dbo.tbl_CustomerMembership WHERE IsoId=@IsoId AND CustomerId=@CustomerId
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetCustomerMembership] TO [WebV4Role]
GO

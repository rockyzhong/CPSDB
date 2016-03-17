SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_csm_UpdateCustomerMembership] (
@IsoId                bigint,
@CustomerId           bigint,
@MembershipNumber     nvarchar(60),
@UpdatedUserId        bigint
)
AS
BEGIN
  SET NOCOUNT ON
  
  UPDATE dbo.tbl_CustomerMembership SET MembershipNumber=@MembershipNumber,UpdatedUserId=@UpdatedUserId WHERE IsoId=@IsoId AND CustomerId=@CustomerId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_UpdateCustomerMembership] TO [WebV4Role]
GO

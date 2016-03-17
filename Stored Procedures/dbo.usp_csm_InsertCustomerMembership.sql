SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_csm_InsertCustomerMembership] (
@IsoId                bigint,
@CustomerId           bigint,
@MembershipNumber     nvarchar(60),
@UpdatedUserId        bigint
)
AS
BEGIN
  SET NOCOUNT ON
  
  INSERT INTO dbo.tbl_CustomerMembership(IsoId,CustomerId,MembershipNumber,UpdatedUserId) VALUES(@IsoId,@CustomerId,@MembershipNumber,@UpdatedUserId)
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_InsertCustomerMembership] TO [WebV4Role]
GO

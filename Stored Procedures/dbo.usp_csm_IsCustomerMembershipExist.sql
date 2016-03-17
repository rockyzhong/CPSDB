SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_IsCustomerMembershipExist] 
@IsoId        bigint,
@CustomerId   bigint
AS
BEGIN
  SET NOCOUNT ON
  DECLARE @IsExist bigint
--  SET @IsExist=0
  IF EXISTS(SELECT IsoId FROM dbo.tbl_CustomerMembership WHERE IsoId=@IsoId AND CustomerId=@CustomerId)
    SET @IsExist=1
  ELSE
    SET @IsExist=0
  SELECT @IsExist
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_IsCustomerMembershipExist] TO [WebV4Role]
GO

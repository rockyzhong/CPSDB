SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_UpdateCustomerOTB] (
@CustomerOTBId    bigint,
@CustomerId       bigint       = NULL,
@MerchantId       nvarchar(50) = NULL,
@TransactionClass nvarchar(50) = NULL,
@FullMICR         nvarchar(25) = NULL,
@OTBLimit         bigint       = NULL,
@CustomerLimit    bigint       = NULL,
@ActiveStatus     nvarchar(1)  = NULL,
@EnrollmentType   nvarchar(1)  = NULL,
@EnrollmentDate   datetime     = NULL,
@UpdatedUserId    bigint
)
AS
BEGIN
  SET NOCOUNT ON
  UPDATE dbo.tbl_CustomerOTB SET CustomerId=@CustomerId,MerchantId=@MerchantId,TransactionClass=@TransactionClass,FullMICR=@FullMICR,OTBLimit=@OTBLimit,CustomerLimit=@CustomerLimit,ActiveStatus=@ActiveStatus,EnrollmentType=@EnrollmentType,EnrollmentDate=@EnrollmentDate,UpdatedUserId=@UpdatedUserId
  WHERE Id=@CustomerOTBId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_UpdateCustomerOTB] TO [WebV4Role]
GO

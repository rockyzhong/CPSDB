SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_GetCustomerAccountList]
@CustomerId BIGINT,
@TransactionClass VARCHAR(50) = "ACL"
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT DISTINCT FullMICR,EnrollmentDate 
  FROM dbo.tbl_CustomerOTB WITH (nolock)
  WHERE CustomerId = @CustomerId AND TransactionClass = @TransactionClass AND ActiveStatus='A'
  ORDER BY EnrollmentDate DESC  
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_GetCustomerAccountList] TO [WebV4Role]
GO

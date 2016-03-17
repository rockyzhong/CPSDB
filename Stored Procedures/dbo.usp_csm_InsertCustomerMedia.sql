SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_InsertCustomerMedia] (
@CustomerId              bigint,
@CustomerMediaType       bigint,
@CustomerMediaDataPart1  nvarchar(50) = NULL,
@CustomerMediaDataPart2  nvarchar(50) = NULL,
@CustomerMediaDataHash   varbinary(512),
@CustomerMediaExpiryDate varchar(50)  = NULL,
@UpdatedUserId           bigint
)
AS
BEGIN
  SET NOCOUNT ON
  IF NOT EXISTS(SELECT * FROM dbo.tbl_CustomerMedia WHERE CustomerId=@CustomerId AND CustomerMediaDataHash=@CustomerMediaDataHash)
    INSERT INTO dbo.tbl_CustomerMedia(CustomerId,CustomerMediaType,CustomerMediaDataPart1,CustomerMediaDataPart2,CustomerMediaDataHash,CustomerMediaExpiryDate,UpdatedUserId)
    VALUES(@CustomerId,@CustomerMediaType,@CustomerMediaDataPart1,@CustomerMediaDataPart2,@CustomerMediaDataHash,@CustomerMediaExpiryDate,@UpdatedUserId)
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_InsertCustomerMedia] TO [WebV4Role]
GO

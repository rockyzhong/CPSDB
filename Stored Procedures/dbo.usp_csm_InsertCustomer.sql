SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_csm_InsertCustomer] (
@CustomerId       bigint        OUTPUT,
@FirstName        nvarchar(25),
@LastName         nvarchar(25),
@MiddleInitial    nvarchar(1)   =NULL,
@Suffix           nvarchar(1)   =NULL,
@Birthday         datetime      =NULL,
@Gender           nvarchar(1)   =NULL,
@SSN              VARBINARY(512)  =NULL,
@CompanyName      nvarchar(40)  =NULL,
@IdNumber         nvarchar(30)  =NULL,
@IdType           nvarchar(10)  ='DL',
@IdState          nvarchar(20)  =NULL,
@IdExpiryDate     datetime      =NULL,
@IdEntryMode      nvarchar(1)   =NULL,
@IdEntryCode      nvarchar(10)  =NULL,
@RegionShortName  nvarchar(10)  =NULL,
@City             nvarchar(20)  =NULL,
@Address          nvarchar(50)  =NULL,
@PostalCode       nvarchar(10)  =NULL,
@Phone            nvarchar(20)  =NULL,
@UpdatedUserId    bigint)
AS
BEGIN
  SET NOCOUNT ON

  DECLARE @AddressId bigint,@RegionId bigint
  SELECT @RegionId=Id FROM dbo.tbl_Region WHERE RegionShortName=@RegionShortName
  INSERT INTO dbo.tbl_Address(RegionId,City,AddressLine1,PostalCode,Telephone1,UpdatedUserId) VALUES(@RegionId,@City,@Address,@PostalCode,@Phone,@UpdatedUserId)
  SELECT @AddressId=(SELECT SCOPE_IDENTITY())

  INSERT INTO dbo.tbl_Customer(FirstName,LastName,MiddleInitial,Suffix,Birthday,Gender,SSN,CompanyName,IdNumber,IdType,IdState,IdExpiryDate,IdEntryMode,IdEntryCode,CreationDate,AddressId,UpdatedUserId)
  VALUES(@FirstName,@LastName,@MiddleInitial,@Suffix,@Birthday,@Gender,@SSN,@CompanyName,@IdNumber,@IdType,@IdState,@IdExpiryDate,@IdEntryMode,@IdEntryCode,getdate(),@AddressId,@UpdatedUserId)
  SELECT @CustomerId=(SELECT SCOPE_IDENTITY())
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_InsertCustomer] TO [WebV4Role]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_csm_UpdateCustomer] (
@CustomerId       bigint        ,
@FirstName        nvarchar(25)  ,
@LastName         nvarchar(25)  ,
@MiddleInitial    nvarchar(1)   ,
@Suffix           nvarchar(1)   ,
@Birthday         datetime      ,
@Gender           nvarchar(1)   ,
@SSN              VARBINARY(512)  ,
@CompanyName      nvarchar(40)  ,
@IdNumber         nvarchar(30)  ,
@IdType	          nvarchar(10)  ,
@IdState          nvarchar(20)  ,
@IdExpiryDate     datetime      ,
@IdEntryMode      nvarchar(1)   ,
@IdEntryCode      nvarchar(10)  ,
@RegionShortName  nvarchar(10)  ,
@City             nvarchar(20)  ,
@Address          nvarchar(50)  ,
@PostalCode       nvarchar(10)  ,
@Phone            nvarchar(20)  ,
@UpdatedUserId    bigint)
AS
BEGIN
  SET NOCOUNT ON

  UPDATE dbo.tbl_Customer SET 
  FirstName=@FirstName,LastName=@LastName,MiddleInitial=@MiddleInitial,Suffix=@Suffix,Birthday=@Birthday,Gender=@Gender,SSN=@SSN,CompanyName=@CompanyName,
  IdNumber=@IdNumber,IdType=@IdType,IdState=@IdState,IdExpiryDate=@IdExpiryDate,IdEntryMode=@IdEntryMode,IdEntryCode=@IdEntryCode,UpdatedUserId=@UpdatedUserId 
  WHERE Id=@CustomerId

  DECLARE @AddressId bigint,@RegionId bigint
  SELECT @AddressId=AddressId FROM dbo.tbl_Customer WHERE Id=@CustomerId
  SELECT @RegionId=Id FROM dbo.tbl_Region WHERE RegionShortName=@RegionShortName
  UPDATE dbo.tbl_Address SET RegionId=@RegionId,City=@City,AddressLine1=@Address,PostalCode=@PostalCode,Telephone1=@Phone,UpdatedUserId=@UpdatedUserId WHERE Id=@AddressId
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_csm_UpdateCustomer] TO [WebV4Role]
GO

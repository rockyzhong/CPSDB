SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_UpdateGamblersAddictionIso]
@GamblersAddictionIsoId bigint,
@IsoId                  bigint,
@CustomerId             bigint,
@SSN                    nvarchar(50),
@IdState                nvarchar(2),
@IdNumber               nvarchar(30),
@FirstName              NVARCHAR(50),
@LastName               NVARCHAR(50),
@Birthday               DATETIME,
@CountryId              BIGINT,
@UpdatedUserId          bigint
AS
BEGIN
  SET NOCOUNT ON
  IF @IdState<>''
  UPDATE dbo.tbl_GamblersAddictionIso SET IsoId=@IsoId,CustomerId=@CustomerId,SSN=@SSN,IdState=@IdState,IdNumber=@IdNumber,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId,FirstName=ISNULL(@FirstName,''),LastName=ISNULL(@LastName,''),Birthday=@Birthday,CountryId=ISNULL(@CountryId,'')
  WHERE Id=@GamblersAddictionIsoId
  ELSE
  UPDATE dbo.tbl_GamblersAddictionIso SET IsoId=@IsoId,CustomerId=@CustomerId,SSN=@SSN,UpdatedDate=GETUTCDATE(),UpdatedUserId=@UpdatedUserId,FirstName=ISNULL(@FirstName,''),LastName=ISNULL(@LastName,''),Birthday=@Birthday,CountryId=ISNULL(@CountryId,'')
  WHERE Id=@GamblersAddictionIsoId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_UpdateGamblersAddictionIso] TO [WebV4Role]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_InsertGamblersAddictionIso]
@GamblersAddictionIsoId bigint OUT,
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
  SET @IdState=ISNULL(@IdState,'')
  SET @IdNumber=ISNULL(@IdNumber,'')
  IF @IdState =''
  BEGIN
  SELECT @GamblersAddictionIsoId=IDENT_CURRENT('tbl_GamblersAddictionIso')
  SET @IdNumber=@GamblersAddictionIsoId+2
  SET @IdState='O1' --- no idstate and idnumber insert 
  END
  INSERT INTO dbo.tbl_GamblersAddictionIso(IsoId,CustomerId,SSN,IdState,IdNumber,UpdatedDate,UpdatedUserId,FirstName,LastName,Birthday,CountryId) 
  VALUES(@IsoId,@CustomerId,@SSN,@IdState,@IdNumber,GETUTCDATE(),@UpdatedUserId,ISNULL(@FirstName,''),ISNULL(@LastName,''),@Birthday,ISNULL(@CountryId,''))
  
  SELECT @GamblersAddictionIsoId=IDENT_CURRENT('tbl_GamblersAddictionIso')

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_InsertGamblersAddictionIso] TO [WebV4Role]
GO

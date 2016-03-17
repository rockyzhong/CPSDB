SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_gam_GetGamblersAddictionIso]
@IsoId                  BIGINT,
@SSN                    NVARCHAR(50),
@IdState                NVARCHAR(2),
@IdNumber               NVARCHAR(30),                 
@FirstName              NVARCHAR(50),
@LastName               NVARCHAR(50),
@Birthday               DATETIME
AS
BEGIN
  IF @SSN =''
  SELECT Id,IsoId,CustomerId,SSN,IdState,IdNumber,FirstName,LastName,CONVERT(NVARCHAR(10),Birthday,111) AS BOD,CountryId
  FROM dbo.tbl_GamblersAddictionIso 
  WHERE IsoId=@IsoId AND IdState=@IdState AND IdNumber=@IdNumber
  UNION 
  SELECT Id,IsoId,CustomerId,SSN,CASE WHEN IdState='O1' THEN '' ELSE IdState END AS IdState,CASE WHEN IdState='O1' THEN '' ELSE IdNumber END AS IdNumber,FirstName,LastName,CONVERT(NVARCHAR(10),Birthday,111) AS BOD,CountryId
  FROM dbo.tbl_GamblersAddictionIso
  WHERE IsoId=@IsoId AND dbo.udf_RemoveSpecialChars(FirstName)=@FirstName AND dbo.udf_RemoveSpecialChars(LastName)=@LastName AND Birthday=@Birthday
  ELSE
  SELECT Id,IsoId,CustomerId,SSN,CASE WHEN IdState='O1' THEN '' ELSE IdState END AS IdState,CASE WHEN IdState='O1' THEN '' ELSE IdNumber END AS IdNumber,FirstName,LastName,CONVERT(NVARCHAR(10),Birthday,111) AS BOD,CountryId
  FROM dbo.tbl_GamblersAddictionIso
  WHERE SSN=@SSN
  UNION
  SELECT Id,IsoId,CustomerId,SSN,IdState,IdNumber,FirstName,LastName,CONVERT(NVARCHAR(10),Birthday,111) AS BOD,CountryId
  FROM dbo.tbl_GamblersAddictionIso 
  WHERE IsoId=@IsoId AND IdState=@IdState AND IdNumber=@IdNumber
  UNION 
  SELECT Id,IsoId,CustomerId,SSN,CASE WHEN IdState='O1' THEN '' ELSE IdState END AS IdState,CASE WHEN IdState='O1' THEN '' ELSE IdNumber END AS IdNumber,FirstName,LastName,CONVERT(NVARCHAR(10),Birthday,111) AS BOD,CountryId
  FROM dbo.tbl_GamblersAddictionIso
  WHERE IsoId=@IsoId AND dbo.udf_RemoveSpecialChars(FirstName)=@FirstName AND dbo.udf_RemoveSpecialChars(LastName)=@LastName AND Birthday=@Birthday
END
GO
GRANT EXECUTE ON  [dbo].[usp_gam_GetGamblersAddictionIso] TO [WebV4Role]
GO

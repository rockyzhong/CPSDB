SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[udf_GetTaxPercent] (@SourceType bigint,@SourceId bigint)
RETURNS money
AS
BEGIN
  DECLARE @RegionId bigint
  IF @SourceType=1        -- Device
    SELECT @RegionId=a.RegionId
    FROM dbo.tbl_Device d 
    JOIN dbo.tbl_Address a ON d.AddressId=a.Id
    WHERE d.Id=@SourceId
  ELSE IF @SourceType=2   -- User
    SELECT TOP 1 @RegionId=a.RegionId
    FROM dbo.tbl_upm_User u 
    JOIN dbo.tbl_IsoAddress i ON u.IsoId=i.IsoId
    JOIN dbo.tbl_Address a ON i.AddressId=a.Id
    WHERE u.Id=@SourceId
    
  DECLARE @TaxPercent money  
  SET @TaxPercent=0  
  SELECT @TaxPercent=TaxPercent FROM dbo.tbl_RegionTax WHERE RegionId=@RegionId
  RETURN @TaxPercent
END
GO

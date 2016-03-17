SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[usp_iso_GetIsoTelecheckTypeList] 
@NetworkMerchantId bigint
AS
BEGIN
SET NOCOUNT ON 
DECLARE @SplitCheckType SourceTable,@TotalCheckType NVARCHAR(100)
SELECT  @TotalCheckType=CheckType FROM tbl_NetworkMerchantTeleCheck WHERE NetworkMerchantId=@NetworkMerchantId
INSERT INTO @SplitCheckType EXEC dbo.usp_sys_Split @TotalCheckType  
    
SELECT ttv.Id, ttv.Value, ttv.Name, ttv.Description from tbl_TypeValue ttv (NOLOCK) 
JOIN  @SplitCheckType sct ON ttv.Value=sct.Id and ttv.TypeId =59 
	        
END
GO

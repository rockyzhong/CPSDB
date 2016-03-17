SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_iso_GetCardTypes]
@IsoId BIGINT,
@cardTypeValue BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;
    IF @cardTypeValue is NULL
    -- Insert statements for procedure here
	SELECT t.Id, t.Name, t.Value, t.[Description], CASE WHEN c.id is null THEN 0 ELSE 1 END AS Allowed 
	FROM dbo.tbl_IsoCardTypeAllow c 
		RIGHT JOIN tbl_TypeValue t ON t.Value=c.CardTypeValue AND c.IsoId=@IsoId
	WHERE t.TypeId=45 AND t.Value NOT IN (256,512,635)
	ELSE
	SELECT t.Id, t.Name, t.Value, t.[Description], CASE WHEN c.id is null THEN 0 ELSE 1 END AS Allowed 
	FROM dbo.tbl_IsoCardTypeAllow c 
		RIGHT JOIN tbl_TypeValue t ON t.Value=c.CardTypeValue AND c.IsoId=@IsoId
	WHERE t.TypeId=45 AND c.CardTypeValue=@cardTypeValue AND t.Value NOT IN (256,512,635)
END
GO

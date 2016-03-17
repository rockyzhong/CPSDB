SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetAgreements]
@Active bigint = 1
AS
BEGIN
  SET NOCOUNT ON
  
  IF @Active=0   -- get all agreements
    SELECT a.Id, a.AgreementType, v.Description AgreementTypeName, a.Description,a.StartDate,a.EndDate
    FROM tbl_Agreement a JOIN tbl_TypeValue v ON v.TypeId=71 AND a.AgreementType=v.Value
  IF @Active=1   -- get active agreements
    SELECT a.Id, a.AgreementType, v.Description AgreementTypeName, a.Description,a.StartDate,a.EndDate
    FROM tbl_Agreement a JOIN tbl_TypeValue v ON v.TypeId=71 AND a.AgreementType=v.Value
    WHERE a.EndDate > GETUTCDATE()
  ELSE           -- get inactive agreements
    SELECT a.Id, a.AgreementType, v.Description AgreementTypeName, a.Description,a.StartDate,a.EndDate
    FROM tbl_Agreement a JOIN tbl_TypeValue v ON v.TypeId=71 AND a.AgreementType=v.Value
    WHERE a.EndDate < GETUTCDATE()
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetAgreements] TO [WebV4Role]
GO

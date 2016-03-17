SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_GetAgreement]
@AgreementTypeName nvarchar(200),
@Date              datetime
AS
BEGIN
  SELECT TOP 1 a.Description FROM  dbo.tbl_Agreement a, dbo.tbl_TypeValue b WHERE a.AgreementType = b.Value AND a.StartDate<=@Date AND a.EndDate>=@Date AND b.Name=@AgreementTypeName ORDER BY a.StartDate DESC
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_GetAgreement] TO [WebV4Role]
GO

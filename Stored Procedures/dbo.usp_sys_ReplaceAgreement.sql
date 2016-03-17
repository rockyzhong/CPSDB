SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_sys_ReplaceAgreement]
@AgreementTypeName    nvarchar(200),
@AgreementDescription nvarchar(3000),
@StartDate            datetime,
@EndDate              datetime,
@UpdatedUserId        bigint
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY
    DECLARE @AgreementType bigint
    SELECT @AgreementType=Value FROM dbo.tbl_TypeValue WHERE TypeId=71 AND Name=@AgreementTypeName

    DECLARE @Id bigint
    SELECT TOP 1 @Id=Id FROM dbo.tbl_Agreement WHERE StartDate<=@StartDate AND EndDate>@StartDate AND AgreementType=@AgreementType ORDER BY StartDate DESC

    INSERT INTO dbo.tbl_Agreement(AgreementType,Description,StartDate,EndDate,UpdatedUserId) VALUES (@AgreementType,@AgreementDescription,@StartDate,@EndDate,@UpdatedUserId)

    IF @Id IS NOT NULL
      UPDATE dbo.tbl_Agreement SET EndDate=@StartDate,UpdatedUserId=@UpdatedUserId WHERE Id=@Id
  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage varchar(1000),@ErrorSeverity int,@ErrorState int
    SET @ErrorMessage=ERROR_MESSAGE();
    SET @ErrorSeverity=ERROR_SEVERITY();
    SET @ErrorState=ERROR_STATE();
    RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState)  
  END CATCH  
  
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_sys_ReplaceAgreement] TO [WebV4Role]
GO

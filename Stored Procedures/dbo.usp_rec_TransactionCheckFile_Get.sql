SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rec_TransactionCheckFile_Get]
@paramSettlementDate datetime
AS
SELECT FileDate, MerchantId, UploadFileName, ResponseFileName
FROM [tbl_rec_TransactionCheckFile]
WHERE SettlementDate = @paramSettlementDate
ORDER BY MerchantId
GO

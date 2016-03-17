SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_rec_TransactionCheckFile_Add]
@paramSettlementDate datetime,
@paramFileDate datetime,
@paramMerchantId nvarchar(50),
@paramUploadFileName nvarchar(200),
@paramResponseFileName nvarchar(200)
AS
INSERT INTO [tbl_rec_TransactionCheckFile]
(
  SettlementDate,
  FileDate,
  MerchantId,
  UploadFileName,
  ResponseFileName
)
VALUES
(
  @paramSettlementDate,
  @paramFileDate,
  @paramMerchantId,
  @paramUploadFileName,
  @paramResponseFileName
)
GO

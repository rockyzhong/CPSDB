SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_set_GetAchFiles]
@pACHFileID int = -1
AS
BEGIN
  SELECT Id AchFileId,ACHFileFormat,InstitutionName,InstitutionNumber,FileID,CompanyID,CompanyName,CompanyShortName,
         StandardEntryClassCode,SettlementLabel,SurchargeLabel, InterchangeLabel,
         SeparateBatches,BlockSizeLines,BlockFillFlag,BlockFillChar,
         FileCreationNo,AchFileStatus,UpdatedUserId, BatchHeaderCompanyName, TraceNumber
  FROM dbo.tbl_AchFile
  WHERE Id = @pACHFileID OR @pACHFileID=-1
END
GO

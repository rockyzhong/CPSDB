SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*

EXEC dbo.usp_ach_GetACHFiles 840
select * from tbl_ACHFile
update tbl_ACHFile set achfileformat = 0
update tbl_ACHFile set achfileformat = 3
*/

CREATE PROCEDURE [dbo].[usp_ach_GetACHFiles]
	@pCurrency smallint = NULL
	,@pStatus int = 1 -- AC

AS
BEGIN
-- Get complete list of ACH File Specs
-- Revision 1.00 2004-03-24 by Adam Glover
-- Initial Revision
-- Revision 1.01 2004-05-06 by Adam Glover
-- Added new columns
-- Revision 1.01 2004-05-10 by Adam Glover
-- Added ISNULL calls to prevent NULL values.
-- Revision 1.02 2004-05-11 by Adam Glover
-- Added SeparateBatches field.
-- Revision 1.03 2005-01-17 by Adam Glover
-- Added ACHFormatID field.
-- Revision 1.04 2005.11.03 by Adam Glover
-- Added columns BlockSizeLines, BlockFillFlag and BlockFillChar
-- Revision 1.05 2005.11.07 by Adam Glover
-- Added column BatchHeaderCompanyName
-- Revision 1.06 2005.11.09 by Adam Glover
-- Added column TraceNumber to allow it
-- to be separate from InstRT.
SELECT ACHFileID = CAST(Id AS int), -- Col 00
InstName = InstitutionName, -- Col 01
InstRT = InstitutionNumber, -- Col 02
ISNULL(CAST(FileCreationNo AS VARCHAR), '') AS CurrentFile, -- Col 03
FileID, -- Col 04
CompanyID, -- Col 05
CompanyName, -- Col 06
'' AS HeaderData, -- Col 07
CAST(0 AS smallint) AS OffsetDebitCode, -- Col 08
1 AS OffsetDebitAccountID, -- Col 09
SettlementLabel, -- Col 10
SurchargeLabel, -- Col 11
InterchangeLabel, -- Col 12
StandardEntryCode = StandardEntryClassCode, -- Col 13
Status = CASE WHEN AchFileStatus = 1 THEN 'AC' ELSE 'XX' END, -- Col 14
'' AS Comment, -- Col 15
SeparateBatches = CAST(SeparateBatches AS smallint), -- Col 16
ACHFormatID = CAST(AchFileFormat AS int), -- Col 17
BlockSizeLines = CAST(BlockSizeLines AS smallint), -- Col 18
BlockFillFlag =CAST(BlockFillFlag AS smallint) , -- Col 19
BlockFillChar, -- Col 20
ISNULL(BatchHeaderCompanyName, '') AS BatchHeaderCompanyName, -- Col 21
ISNULL(TraceNumber, '') AS TraceNumber -- Col 22
FROM dbo.tbl_AchFile (NOLOCK)
WHERE (@pStatus IS NULL OR AchFileStatus = @pStatus)
	AND (@pCurrency IS NULL OR Currency = @pCurrency)
ORDER BY ACHFileID
END
GO
GRANT EXECUTE ON  [dbo].[usp_ach_GetACHFiles] TO [WebV4Role]
GO

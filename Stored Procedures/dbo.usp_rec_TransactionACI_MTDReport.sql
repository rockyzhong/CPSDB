SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
SELECT * FROM dbo.tbl_rec_TransactionACIImport
SELECT * INTO dbo.tbl_rec_TransactionACIBak FROM dbo.tbl_rec_TransactionACI
SELECT * FROM dbo.tbl_rec_TransactionACI
SELECT * FROM dbo.tbl_rec_TransactionACINode
SELECT * FROM dbo.tbl_rec_TransactionACISummary
EXEC dbo.usp_rec_TransactionACI_MTDReport '2015-04-19'

truncate table dbo.tbl_rec_TransactionACISummary

*/

CREATE PROCEDURE [dbo].[usp_rec_TransactionACI_MTDReport]
	@pSettDate datetime,
	@pCurrency smallint = 124
AS
BEGIN
SET NOCOUNT ON

OPEN SYMMETRIC KEY sk_EncryptionKey DECRYPTION BY CERTIFICATE ec_EncryptionCert

DECLARE @AcqCPA char(4)
SET @AcqCPA = '1127'

DECLARE @FrwrdrCPA char(4)
SET @FrwrdrCPA = '1127'

DECLARE @UTCOffsetMinutes int
SET @UTCOffsetMinutes = datediff(n, getdate(), getutcdate())

DECLARE @IsSpringDaylightSavingsDay int
DECLARE @IsFallDaylightSavingsDay int
DECLARE @DaylightChangeTime datetime

SET @IsSpringDaylightSavingsDay = 0
SET @IsFallDaylightSavingsDay = 0
SET @DaylightChangeTime = dateadd(hour, 2, @pSettDate)

IF (datepart(month, @pSettDate) = 3 AND datepart(dw, @pSettDate) = 1
    AND datepart(day, @pSettDate) BETWEEN 8 AND 14)
BEGIN
  SET @IsSpringDaylightSavingsDay = 1
END
ELSE IF (datepart(month, @pSettDate) = 11 AND datepart(dw, @pSettDate) = 1
    AND datepart(day, @pSettDate) BETWEEN 1 AND 7)
BEGIN
  SET @IsFallDaylightSavingsDay = 1
END
SELECT (CASE 
  WHEN tr.ExtMsgType = '0430' THEN '0430'
  WHEN tr.ExtMsgType = '0420' THEN '0430'
  WHEN tr.ExtMsgType = '0630' THEN '0630'
  WHEN tr.ExtMsgType = '0620' THEN '0630'
  WHEN tr.ExtMsgType = '0632' THEN '0632'
  WHEN tr.ExtMsgType = '0622' THEN '0632'
  WHEN tr.ExtMsgType = '0210' THEN '0210'
  WHEN tr.ExtMsgType = '0200' THEN '0210'
  WHEN tr.IntMsgType = '0420' THEN '0430'
  WHEN tr.IntMsgType = '0620' THEN '0630'
  WHEN tr.IntMsgType = '0622' THEN '0632'
  WHEN tr.IntMsgType = '0200' THEN '0210'
  WHEN tr.IntMsgType IS NULL THEN tr.ExtMsgType
  WHEN tr.IntMsgType = '' THEN tr.ExtMsgType
  ELSE tr.IntMsgType END) AS MsgType,
  ISNULL(RTRIM(convert(varchar(30), DecryptByKey(tr.PAN_Encrypted))), '000000000000000') AS PAN,
  '01' + (CASE WHEN tr.IntMsgFromAcctType = '01' THEN '20'
      WHEN tr.IntMsgFromAcctType = '11' THEN '10'
      WHEN tr.IntMsgFromAcctType = '31' THEN '30'
      ELSE '00' END)
    + (CASE WHEN tr.IntMsgToAcctType = '01' THEN '20'
      WHEN tr.IntMsgToAcctType = '11' THEN '10'
      WHEN tr.IntMsgToAcctType = '31' THEN '30'
      ELSE '00' END) AS ProcCode,
  REPLICATE('0', 12 - len(convert(varchar(12), convert(bigint, tr.IntMsgAmount1 * 100))))
      + convert(varchar(12), convert(bigint, tr.IntMsgAmount1 * 100)) AS Amt,
  RIGHT(
    REPLACE(
      REPLACE(
        REPLACE(
          convert(varchar(30), dateadd(n,
            (CASE WHEN @IsSpringDaylightSavingsDay = 1 AND tr.IntMsgTranDateTime < @DaylightChangeTime THEN 300
                WHEN @IsSpringDaylightSavingsDay = 1 AND tr.IntMsgTranDateTime >= @DaylightChangeTime THEN 240
                WHEN @IsFallDaylightSavingsDay = 1 AND tr.IntMsgTranDateTime < @DaylightChangeTime THEN 240
                WHEN @IsFallDaylightSavingsDay = 1 AND tr.IntMsgTranDateTime >= @DaylightChangeTime THEN 300
                ELSE @UTCOffsetMinutes
              END),
            --@UTCOffsetMinutes,
            tr.IntMsgTranDateTime), 120)
          ,'-', '')
        , ':', '')
      , ' ', '')
    , 10) AS GMTDateTime,
  REPLACE(convert(varchar(30), tr.IntMsgTranDateTime, 8), ':', '') AS TimeLoc,
  REPLACE(LEFT(convert(varchar(30), tr.IntMsgTranDateTime, 1), 5), '/', '') AS DateLoc,
  REPLACE(LEFT(convert(varchar(30), tr.DateTimeSettlement, 1), 5), '/', '') AS CapDate,
  (CASE WHEN tr.IntMsgType LIKE '06%' THEN '0000'
    ELSE '6011' END) AS MerchType,
  RTRIM(tr.IntMsgTermID) AS TermID,
  (CASE WHEN tr.ExtMsgType LIKE '06%' THEN '0'
    WHEN (RTRIM(tr.IntMsgMbrNum) <> '' OR tr.TKNB4 LIKE '3035%'
          OR (ai.FunctionFlags & 16777216 > 0 AND tr.IntMsgType = '0420' AND tr.TKNB4 NOT LIKE '3931%' AND tr.TKNB4 NOT LIKE '3930%'))
        AND (tr.ServiceCode LIKE '2%' OR tr.ServiceCode LIKE '6%')
      THEN '5' -- Chip Terminal, Chip Card, Chip Trans
    WHEN (tr.TKNB4 LIKE '3931%' OR tr.TKNB4 LIKE '3930%')
        AND RTRIM(tr.IntMsgMbrNum) = '' AND (tr.ServiceCode LIKE '2%' OR tr.ServiceCode LIKE '6%')
      THEN '4' -- Chip Terminal, Chip Card, Fallback to Mag Trans
    WHEN (tr.TKNB4 NOT LIKE '3931%' AND tr.TKNB4 NOT LIKE '3930%')
        AND (tr.ServiceCode LIKE '2%' OR tr.ServiceCode LIKE '6%')
      THEN '3' -- Mag Terminal, Chip Card, Mag Trans
    WHEN (tr.TKNB4 LIKE '3931%' OR tr.TKNB4 LIKE '3930%')
        AND tr.ServiceCode NOT LIKE '2%' AND tr.ServiceCode NOT LIKE '6%'
      THEN '2' -- Chip Terminal, Mag Card, Mag Trans
    ELSE '1' -- Mag Stripe Terminal, Mag Stripe Card, Mag Stripe Trans
    END) AS ChipInd,
  RIGHT(tr.IntMsgAcqInstID, 6) AS AcqID,
  RIGHT(tr.IntMsgAcqInstID, 6) AS FrwrdrID,
  (CASE WHEN tr.Substate IN (5, 23, 43) THEN '  '
    WHEN (tr.ExtMsgRespCode = '' OR tr.ExtMsgRespCode LIKE '  %') AND tr.ExtMsgType LIKE '06%' THEN '00'
    WHEN tr.ExtMsgRespCode = '' AND tr.ExtMsgType NOT LIKE '06%' THEN '  '
    WHEN len(rtrim(tr.ExtMsgRespCode)) = 1 THEN '0' + rtrim(tr.ExtMsgRespCode)
    ELSE LEFT(tr.ExtMsgRespCode, 2) END) AS RespCode,
  (CASE WHEN tr.ISO42 <> '' AND tr.ExtMsgType LIKE '06%' THEN tr.ISO42
    ELSE RIGHT(tr.IntMsgAcqInstID, 6) END) AS AccID,
  '0000000' AS POSCondCode,
  (CASE WHEN tr.ExtMsgType LIKE '06%' THEN '000000'
    WHEN ad.PostalCode IS NOT NULL AND len(RTRIM(ad.PostalCode)) = 7
        AND UPPER(substring(ad.PostalCode, 1, 1)) BETWEEN 'A' AND 'Z'
        AND substring(ad.PostalCode, 2, 1) BETWEEN '0' AND '9'
        AND UPPER(substring(ad.PostalCode, 3, 1)) BETWEEN 'A' AND 'Z'
        AND substring(ad.PostalCode, 5, 1) BETWEEN '0' AND '9'
        AND UPPER(substring(ad.PostalCode, 6, 1)) BETWEEN 'A' AND 'Z'
        AND substring(ad.PostalCode, 7, 1) BETWEEN '0' AND '9'
      THEN UPPER(substring(ad.PostalCode, 1, 3) + substring(ad.PostalCode, 5, 3))
    WHEN ad.PostalCode IS NOT NULL AND len(RTRIM(ad.PostalCode)) = 6
        AND UPPER(substring(ad.PostalCode, 1, 1)) BETWEEN 'A' AND 'Z'
        AND substring(ad.PostalCode, 2, 1) BETWEEN '0' AND '9'
        AND UPPER(substring(ad.PostalCode, 3, 1)) BETWEEN 'A' AND 'Z'
        AND substring(ad.PostalCode, 4, 1) BETWEEN '0' AND '9'
        AND UPPER(substring(ad.PostalCode, 5, 1)) BETWEEN 'A' AND 'Z'
        AND substring(ad.PostalCode, 6, 1) BETWEEN '0' AND '9'
      THEN UPPER(RTRIM(ad.PostalCode))
    ELSE '000000' END) AS PostalCode,
  (CASE WHEN tr.IntMsgType IN ('0420', '0430')
    THEN REPLICATE('0', 12 - len(convert(varchar(12), convert(int, tr.IntMsgAmount2 * 100))))
      + convert(varchar(12), convert(int, tr.IntMsgAmount2 * 100))
    ELSE '000000000000' END) AS ReplacementAmount,
  (CASE WHEN tr.IntMsgType LIKE '06%' THEN '000000'
    WHEN tr.IntMsgIssuerID = '' THEN '000000'
    WHEN tr.IntMsgIssuerID LIKE '%100402' AND tr.ISO100 <> '' THEN tr.ISO100
    ELSE RIGHT(tr.IntMsgIssuerID, 6) END) AS RecvrID,
  RIGHT(tr.IntMsgSeqNum, 6) AS RetRefNo,
  (CASE WHEN tr.IntMsgType LIKE '06%' THEN '000000'
    ELSE tr.IntMsgAuthIDResponse END) AS AuthIDResp,
  (CASE WHEN tr.IntMsgType LIKE '06%' THEN SPACE(40)
    ELSE LEFT(tr.IntMsgTerminalOwnerName, 25)
      + SPACE(25 - len(LEFT(tr.IntMsgTerminalOwnerName, 25)))
      + LEFT(tr.IntMsgTerminalCity, 10)
      + SPACE(10 - len(LEFT(tr.IntMsgTerminalCity, 10)))
      + LEFT(tr.IntMsgTerminalState, 2)
      + SPACE(2 - len(LEFT(tr.IntMsgTerminalState, 2)))
      + 'CAN' END) AS CardAcceptorNameLocation,
  (CASE WHEN tr.IntMsgType LIKE '06%' THEN SPACE(25)
    ELSE RTRIM(LEFT(tr.IntMsgTerminalLocationName, 19))
      + SPACE(19 - len(RTRIM(LEFT(tr.IntMsgTerminalLocationName, 19))))
      +   (CASE WHEN ad.PostalCode IS NOT NULL AND len(RTRIM(ad.PostalCode)) = 7
          AND UPPER(substring(ad.PostalCode, 1, 1)) BETWEEN 'A' AND 'Z'
          AND substring(ad.PostalCode, 2, 1) BETWEEN '0' AND '9'
          AND UPPER(substring(ad.PostalCode, 3, 1)) BETWEEN 'A' AND 'Z'
          AND substring(ad.PostalCode, 5, 1) BETWEEN '0' AND '9'
          AND UPPER(substring(ad.PostalCode, 6, 1)) BETWEEN 'A' AND 'Z'
          AND substring(ad.PostalCode, 7, 1) BETWEEN '0' AND '9'
        THEN UPPER(substring(ad.PostalCode, 1, 3) + substring(ad.PostalCode, 5, 3))
      WHEN ad.PostalCode IS NOT NULL AND len(RTRIM(ad.PostalCode)) = 6
          AND UPPER(substring(ad.PostalCode, 1, 1)) BETWEEN 'A' AND 'Z'
          AND substring(ad.PostalCode, 2, 1) BETWEEN '0' AND '9'
          AND UPPER(substring(ad.PostalCode, 3, 1)) BETWEEN 'A' AND 'Z'
          AND substring(ad.PostalCode, 4, 1) BETWEEN '0' AND '9'
          AND UPPER(substring(ad.PostalCode, 5, 1)) BETWEEN 'A' AND 'Z'
          AND substring(ad.PostalCode, 6, 1) BETWEEN '0' AND '9'
        THEN UPPER(RTRIM(ad.PostalCode))
      ELSE '000000' END)
  END) AS CivicAddr,
  SPACE(6) AS AcqAttributedID
FROM dbo.tbl_rec_TransactionACI tr(NOLOCK)
LEFT JOIN dbo.tbl_Device ai(NOLOCK) ON ai.TerminalName = tr.IntMsgTermID
LEFT JOIN dbo.tbl_Address ad(NOLOCK) ON ai.AddressId = ad.Id
--LEFT JOIN tblRegion rg ON rg.RegionID = ai.LocationRegion
WHERE tr.DateTimeSettlement = @pSettDate
  AND tr.ExtMsgType NOT IN ('0600', '0610', '0602', '0612', '0800')
  AND tr.PAN_BINRange <> '' AND tr.PAN_Last4 <> ''
  AND tr.RecordType = 1
  AND tr.PAN_BINrange <> '453819'
ORDER BY DateLoc, TimeLoc, MsgType



END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionACI_MTDReport] TO [WebV4Role]
GO

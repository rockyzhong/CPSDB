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
EXEC dbo.usp_rec_TransactionACI_Load '2015-04-19'

truncate table dbo.tbl_rec_TransactionACISummary


CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Password0'
GO
CREATE CERTIFICATE [ec_EncryptionCert] WITH SUBJECT = 'Key Protection';
GO
CREATE SYMMETRIC KEY [sk_EncryptionKey] WITH
    KEY_SOURCE = 'My key generation bits. This is a shared secret!',
    ALGORITHM = AES_256, 
    IDENTITY_VALUE = 'Key Identity generation bits. Also a shared secret'
    ENCRYPTION BY CERTIFICATE [ec_EncryptionCert];
GO
*/
CREATE PROC [dbo].[usp_rec_TransactionACI_Load]
	@pSettDate datetime,
	@pCurrency smallint = 124,
	@pFilePrefix char(2) = 'ID',
	@pForceACSSLoad int = 1
AS
BEGIN
SET NOCOUNT ON

--DECLARE @TestEncryptedPAN varbinary(80)

-- Try setting encrypted PAN value without opening key
--SET @TestEncryptedPAN = EncryptByKey(Key_GUID('SymKey_SPS_20110113'), '999999')

--IF @TestEncryptedPAN IS NULL
--BEGIN
--  OPEN SYMMETRIC KEY SymKey_SPS_20110113
--    DECRYPTION BY ASYMMETRIC KEY AsymKey_SPS_01
--END

IF EXISTS(SELECT TOP 1 1 FROM dbo.tbl_rec_TransactionACIImport (NOLOCK))
BEGIN
	DELETE FROM dbo.tbl_rec_TransactionACI
	WHERE DateTimeSettlement = @pSettDate
		AND Currency = @pCurrency
		AND FilePrefix = @pFilePrefix
END

INSERT INTO dbo.tbl_rec_TransactionACI
(
    DateTimeSettlement,
	Currency,
    FilePrefix,
    RecordID,
    RecordType,
    Substate,
    DateTimeAdded,
    IntMsgType,
    IntMsgTranCode,
    IntMsgFromAcctType,
    IntMsgToAcctType,
    IntMsgCardFIID,
    IntMsgIssuerID,
    IntMsgTranDateTime,
    IntMsgSettlementPostDate,
    IntMsgAcqInterchangeSettlementDate,
    IntMsgIssInterchangeSettlementDate,
    IntMsgTermFIID,
    IntMsgTermID,
    IntMsgSeqNum,
    PAN_BINRange,
    PAN_Last4,
    PAN_Encrypted,
    ServiceCode,
    IntMsgMbrNum,
    IntMsgAcqInstID,
    IntMsgReversalCode,
    IntMsgAmount1,
    IntMsgAmount2,
    IntMsgOrigDateTime,
    IntMsgTerminalLocationName,
    IntMsgTerminalOwnerName,
    IntMsgTerminalCity,
    IntMsgTerminalState,
    IntMsgTerminalCountry,
    IntMsgAuthIDResponse,
    ExtMsgType,
    ExtMsgRespCode,
    ExtMsgRevCode,
    ExtMsgTraceNum,
    ISO7,
    ISO17,
    ISO42,
    ISO48,
    ISO49,
    ISO50,
    ISO90,
    ISO95,
    ISO100,
    TKNB2,
    TKNB3,
    TKNB4,
    TKNB5,
    TKNB6,
    FillerField
)
SELECT 
    @pSettDate,
	@pCurrency,
    @pFilePrefix,
    ROW_NUMBER() OVER (ORDER BY ExtCurrentDateTime ASC),
    RecType,
    Substate,
    (CASE WHEN ExtCurrentDateTime LIKE '0000%' OR RTRIM(ExtCurrentDateTime) = '' THEN convert(datetime, '1900-01-01')
      WHEN ISDATE('20' + substring(ExtCurrentDateTime, 1, 2) + '-' + substring(ExtCurrentDateTime, 3, 2)
        + '-' + substring(ExtCurrentDateTime, 5, 2)
        + ' ' + substring(ExtCurrentDateTime, 7, 2) + ':' + substring(ExtCurrentDateTime, 9, 2)
        + ':' + substring(ExtCurrentDateTime, 11, 2) + '.' + substring(ExtCurrentDateTime, 13, 2) + '0') = 0 THEN convert(datetime, '1900-01-01')
      ELSE convert(datetime, '20' + substring(ExtCurrentDateTime, 1, 2) + '-' + substring(ExtCurrentDateTime, 3, 2)
        + '-' + substring(ExtCurrentDateTime, 5, 2)
        + ' ' + substring(ExtCurrentDateTime, 7, 2) + ':' + substring(ExtCurrentDateTime, 9, 2)
        + ':' + substring(ExtCurrentDateTime, 11, 2) + '.' + substring(ExtCurrentDateTime, 13, 2) + '0') END),
    IntMsgType,
    substring(IntMsgProcCode, 1, 2),
    substring(IntMsgProcCode, 3, 2),
    substring(IntMsgProcCode, 5, 2),
    IntMsgCardFIID,
    IntMsgIssuerID,
    (CASE WHEN IntMsgTranDateTime LIKE '0000%' OR rtrim(IntMsgTranDateTime) = '' THEN convert(datetime, '1900-01-01')
      WHEN ISDATE('20' + substring(IntMsgTranDateTime, 1, 2) + '-' + substring(IntMsgTranDateTime, 3, 2)
        + '-' + substring(IntMsgTranDateTime, 5, 2)
        + ' ' + substring(IntMsgTranDateTime, 7, 2) + ':' + substring(IntMsgTranDateTime, 9, 2)
        + ':' + substring(IntMsgTranDateTime, 11, 2) + '.' + substring(IntMsgTranDateTime, 13, 2) + '0') = 0
        THEN convert(datetime, '1900-01-01')
      ELSE convert(datetime, '20' + substring(IntMsgTranDateTime, 1, 2) + '-' + substring(IntMsgTranDateTime, 3, 2)
        + '-' + substring(IntMsgTranDateTime, 5, 2)
        + ' ' + substring(IntMsgTranDateTime, 7, 2) + ':' + substring(IntMsgTranDateTime, 9, 2)
        + ':' + substring(IntMsgTranDateTime, 11, 2) + '.' + substring(IntMsgTranDateTime, 13, 2) + '0') END),
    (CASE WHEN rtrim(IntMsgSettlementPostDate) IN ('', '000000') THEN @pSettDate
      WHEN ISDATE('20' + substring(IntMsgSettlementPostDate, 1, 2) + '-' + substring(IntMsgIssInterchangeSettlementDate, 3, 2)
        + '-' + substring(IntMsgSettlementPostDate, 5, 2)) = 0 THEN @pSettDate
      ELSE convert(datetime, '20' + substring(IntMsgSettlementPostDate, 1, 2) + '-' + substring(IntMsgSettlementPostDate, 3, 2)
        + '-' + substring(IntMsgSettlementPostDate, 5, 2)) END),
    (CASE WHEN rtrim(IntMsgAcqInterchangeSettlementDate) IN ('', '000000') THEN convert(datetime, '1900-01-01')
      WHEN ISDATE('20' + substring(IntMsgAcqInterchangeSettlementDate, 1, 2) + '-' + substring(IntMsgAcqInterchangeSettlementDate, 3, 2)
        + '-' + substring(IntMsgAcqInterchangeSettlementDate, 5, 2)) = 0 THEN convert(datetime, '1900-01-01')
      ELSE convert(datetime, '20' + substring(IntMsgAcqInterchangeSettlementDate, 1, 2) + '-' + substring(IntMsgAcqInterchangeSettlementDate, 3, 2)
        + '-' + substring(IntMsgAcqInterchangeSettlementDate, 5, 2)) END),
    (CASE WHEN rtrim(IntMsgIssInterchangeSettlementDate) IN ('', '000000') THEN convert(datetime, '1900-01-01')
      WHEN ISDATE('20' + substring(IntMsgIssInterchangeSettlementDate, 1, 2) + '-' + substring(IntMsgIssInterchangeSettlementDate, 3, 2)
        + '-' + substring(IntMsgIssInterchangeSettlementDate, 5, 2)) = 0 THEN convert(datetime, '1900-01-01')
      ELSE convert(datetime, '20' + substring(IntMsgIssInterchangeSettlementDate, 1, 2) + '-' + substring(IntMsgIssInterchangeSettlementDate, 3, 2)
        + '-' + substring(IntMsgIssInterchangeSettlementDate, 5, 2)) END),
    IntMsgTermFIID,
    IntMsgTermID,
    IntMsgSeqNum,
    LEFT(PAN, 6),
    RIGHT(RTRIM(PAN), 4),
	EncryptByKey(KEY_GUID('sk_EncryptionKey'),RTRIM(PAN)) AS PAN_Encrypted,
    ServiceCode,
    IntMsgMbrNum,
    IntMsgAcqInstID,
    IntMsgReversalCode,
    convert(money, IntMsgAmount1) / 100,
    convert(money, IntMsgAmount2) / 100,
    (CASE WHEN IntMsgOrigDateTime LIKE '0000%' OR rtrim(IntMsgOrigDateTime) = '' THEN convert(datetime, '1900-01-01')
      WHEN ISDATE('20' + substring(IntMsgOrigDateTime, 1, 2) + '-' + substring(IntMsgOrigDateTime, 3, 2)
        + '-' + substring(IntMsgOrigDateTime, 5, 2)
        + ' ' + substring(IntMsgOrigDateTime, 7, 2) + ':' + substring(IntMsgOrigDateTime, 9, 2)
        + ':' + substring(IntMsgOrigDateTime, 11, 2) + '.' + substring(IntMsgOrigDateTime, 13, 2) + '0') = 0 THEN convert(datetime, '1900-01-01')
      ELSE convert(datetime, '20' + substring(IntMsgOrigDateTime, 1, 2) + '-' + substring(IntMsgOrigDateTime, 3, 2)
        + '-' + substring(IntMsgOrigDateTime, 5, 2)
        + ' ' + substring(IntMsgOrigDateTime, 7, 2) + ':' + substring(IntMsgOrigDateTime, 9, 2)
        + ':' + substring(IntMsgOrigDateTime, 11, 2) + '.' + substring(IntMsgOrigDateTime, 13, 2) + '0') END),
    IntMsgTerminalLocationName,
    IntMsgTerminalOwnerName,
    IntMsgTerminalCity,
    IntMsgTerminalState,
    IntMsgTerminalCountry,
    IntMsgAuthIDResponse,
    ExtMsgType,
    ExtMsgRespCode,
    ExtMsgRevCode,
    ExtMsgTraceNum,
    ISO7,
    ISO17,
    LEFT(ISO42, 6),
    ISO48,
    ISO49,
    ISO50,
    ISO90,
    ISO95,
    ISO100,
    TKNB2,
    TKNB3,
    TKNB4,
    TKNB5,
    LEFT(TKNB6, 255),
    LEFT(FillerField, 255)
FROM dbo.tbl_rec_TransactionACIImport(NOLOCK)
ORDER BY ExtCurrentDateTime ASC

IF @pFilePrefix IN ('ID') OR @pForceACSSLoad <> 0
BEGIN
	DELETE FROM dbo.tbl_rec_TransactionACISummary
	WHERE DateTimeSettlement = @pSettDate
		AND Currency = @pCurrency

	INSERT INTO dbo.tbl_rec_TransactionACISummary
	(
		DateTimeSettlement,
		Currency,
		[Service],
		NodeID,
		InstName,
		ACSSDebitCount,
		ACSSDebitAmount,
		ACSSCreditCount,
		ACSSCreditAmount,
		NetDepositAmount,
		SettlementRegion
	)
	SELECT @pSettDate AS DateTimeSettlement,
	@pCurrency AS Currency,
	'SCD' AS Service,
	tNodeID.NodeID AS NodeID,
	max(tNodeID.FIIDDesc) AS InstName,
	ISNULL(sum(CASE WHEN t210.IntMsgType IN ('0200', '0210') THEN 1
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '14' THEN 1
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '16' THEN 1
		ELSE 0 END), 0) AS ACSSDebitCount,
	ISNULL(sum(CASE WHEN t210.IntMsgType IN ('0200', '0210') AND t420.IntMsgAmount2 IS NOT NULL THEN t420.IntMsgAmount2
		WHEN t210.IntMsgType IN ('0200', '0210') AND t420.IntMsgAmount2 IS NULL THEN t210.IntMsgAmount1
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '14' THEN t210.IntMsgAmount1
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '16' THEN t210.IntMsgAmount1
		ELSE 0 END), 0)
	+ ISNULL(sum(CASE
		WHEN RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = '000202'
		AND (t210.IntMsgTermID = 'TNSFV007'
			OR (t210.IntMsgTermID LIKE 'B%' AND t210.IntMsgTermID NOT LIKE 'BM%'
			AND t210.IntMsgTermID NOT LIKE 'BW%' AND t210.IntMsgTermID NOT LIKE 'B6%')
		) THEN 0 -- Scotia On Us transaction, no interchange
		WHEN t210.IntMsgType IN ('0200', '0210') THEN 0.75
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '14' THEN 0.75
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '16' THEN 0.75
		ELSE 0 END), 0) AS ACSSDebitAmount,
	ISNULL(sum(CASE WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '16' THEN 1
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '14' THEN 1
		ELSE 0 END), 0) AS ACSSCreditCount,
	ISNULL(sum(CASE WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '16' THEN t210.IntMsgAmount1
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '14' THEN t210.IntMsgAmount1
		ELSE 0 END), 0)
	+ ISNULL(sum(CASE
		WHEN RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = '000202'
		AND (t210.IntMsgTermID = 'TNSFV007'
			OR (t210.IntMsgTermID LIKE 'B%' AND t210.IntMsgTermID NOT LIKE 'BM%'
			AND t210.IntMsgTermID NOT LIKE 'BW%' AND t210.IntMsgTermID NOT LIKE 'B6%')
		) THEN 0
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '16' THEN 0.75
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '14' THEN 0.75
		ELSE 0 END), 0) AS ACSSCreditAmount,
	ISNULL(sum(CASE WHEN t210.IntMsgType IN ('0200', '0210') AND t420.IntMsgAmount2 IS NOT NULL THEN t420.IntMsgAmount2
		WHEN t210.IntMsgType IN ('0200', '0210') AND t420.IntMsgAmount2 IS NULL THEN t210.IntMsgAmount1
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '14' THEN t210.IntMsgAmount1
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '16' THEN t210.IntMsgAmount1
		ELSE 0 END), 0)
	- ISNULL(sum(CASE WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '16' THEN t210.IntMsgAmount1
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '14' THEN t210.IntMsgAmount1
		ELSE 0 END), 0)
	+ ISNULL(sum(CASE
		WHEN RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = '000202'
		AND (t210.IntMsgTermID = 'TNSFV007'
			OR (t210.IntMsgTermID LIKE 'B%' AND t210.IntMsgTermID NOT LIKE 'BM%'
			AND t210.IntMsgTermID NOT LIKE 'BW%' AND t210.IntMsgTermID NOT LIKE 'B6%')
		) THEN 0
		WHEN t210.IntMsgType IN ('0200', '0210') THEN 0.75
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '14' THEN 0.75
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '16' THEN 0.75
		ELSE 0 END), 0)
	- ISNULL(sum(CASE
		WHEN RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = '000202'
		AND (t210.IntMsgTermID = 'TNSFV007'
			OR (t210.IntMsgTermID LIKE 'B%' AND t210.IntMsgTermID NOT LIKE 'BM%'
			AND t210.IntMsgTermID NOT LIKE 'BW%' AND t210.IntMsgTermID NOT LIKE 'B6%')
		) THEN 0
		WHEN t210.IntMsgType IN ('0620', '0630') AND substring(t210.ISO48, 13, 2) = '16' THEN 0.75
		WHEN t210.IntMsgType IN ('0622', '0632') AND substring(t210.ISO48, 13, 2) = '14' THEN 0.75
		ELSE 0 END), 0) AS NetDepositAmount,
	(CASE WHEN tNodeID.NodeID LIKE '0002%' THEN 'SETTLEMENT BANK'
		ELSE 'CENTRAL REGION' END) AS SettlementRegion

	FROM dbo.tbl_rec_TransactionACINode tNodeID (NOLOCK)
	LEFT JOIN dbo.tbl_rec_TransactionACI t210 (NOLOCK)
		ON t210.DateTimeSettlement = @pSettDate
		AND t210.Currency = @pCurrency
		AND ((tNodeID.NodeID NOT LIKE '0002%' AND RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = tNodeID.NodeID)
			OR (tNodeID.NodeID = '000202' AND RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = tNodeID.NodeID
			AND (t210.IntMsgTermID NOT LIKE 'B%' OR t210.IntMsgTermID LIKE 'BM%'
				OR t210.IntMsgTermID LIKE 'BW%' OR t210.IntMsgTermID LIKE 'B6%')
			AND t210.IntMsgTermID <> 'TNSFV007'
			) -- BNS Not On Us
			OR (tNodeID.NodeID = '000210' AND RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = '000202'
			AND (t210.IntMsgTermID = 'TNSFV007'
				OR (t210.IntMsgTermID LIKE 'B%' AND t210.IntMsgTermID NOT LIKE 'BM%'
				AND t210.IntMsgTermID NOT LIKE 'BW%' AND t210.IntMsgTermID NOT LIKE 'B6%')
			)
			AND t210.PAN_BINRange NOT IN ('453819')
			) -- BNS On Us Non-Schooner
			OR (tNodeID.NodeID = '000211' AND RIGHT((CASE WHEN t210.intmsgissuerid = '0000000000' THEN t210.iso48 ELSE t210.intmsgissuerid END), 6) = '000202'
			AND (t210.IntMsgTermID = 'TNSFV007'
				OR (t210.IntMsgTermID LIKE 'B%' AND t210.IntMsgTermID NOT LIKE 'BM%'
				AND t210.IntMsgTermID NOT LIKE 'BW%' AND t210.IntMsgTermID NOT LIKE 'B6%')
			)
			AND t210.PAN_BINRange IN ('453819')
			) -- BNS Schooner
			OR (t210.IntMsgIssuerID = '00000000000' AND t210.ISO48 LIKE tNodeID.NodeID + '%')
			OR (t210.IntMsgIssuerID = '00000000000' AND t210.ISO48 LIKE '______' + tNodeID.NodeID + '%')
		)
		AND (t210.ExtMsgRespCode LIKE '00%' OR (t210.ExtMsgType IN ('0620', '0622', '0630', '0632')
			AND (t210.ExtMsgRespCode = '' OR t210.ExtMsgRespCode LIKE '  %')))
		AND NOT (t210.IntMsgType IN ('0620', '0630', '0622', '0632') AND substring(t210.ISO48, 13, 2) NOT IN ('14', '16'))
		AND t210.IntMsgType NOT IN ('0420', '0600', '0610', '0800')
		AND t210.ExtMsgType NOT IN ('0420', '0430', '0600', '0610', '0800')
		AND t210.RecordType = 1 -- SCD
	LEFT JOIN dbo.tbl_rec_TransactionACI t420 (NOLOCK)
		ON t420.DateTimeSettlement = t210.DateTimeSettlement
		AND t420.IntMsgTermID = t210.IntMsgTermID AND t420.IntMsgSeqNum = t210.IntMsgSeqNum
		AND t420.IntMsgTranDateTime = t210.IntMsgTranDateTime AND t420.ExtMsgType IN ('0420', '0430')
		AND t420.Currency = @pCurrency
	WHERE tNodeID.NodeType = 'SCD' AND (t420.IntMsgAmount2 IS NULL OR t420.IntMsgAmount2 <> 0)
	GROUP BY tNodeID.NodeID
END

END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionACI_Load] TO [WebV4Role]
GO

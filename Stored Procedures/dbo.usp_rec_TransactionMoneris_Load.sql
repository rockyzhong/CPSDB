SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

/*
BCP CPS.dbo.tbl_rec_TransactionMonerisImport IN "c:\recfile\GWRAW01.20150419.0R03.txt" -Sitwsjw01  -T -c
SELECT * FROM dbo.tbl_rec_TransactionMonerisImport
SELECT * FROM dbo.tbl_rec_TransactionMoneris
EXEC dbo.usp_rec_TransactionMoneris_Load '2015-04-19', 124

SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' and msgtype = 5220
SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' and msgtype = 5240
SELECT * FROM dbo.tbl_rec_TransactionMoneris where DateTimeSettlement = '2015-04-19' and msgtype = 5270
*/

CREATE PROCEDURE [dbo].[usp_rec_TransactionMoneris_Load]
	@pSettDate datetime
	,@pCurrency smallint = 124
AS
BEGIN
SET NOCOUNT ON

DELETE FROM dbo.tbl_rec_TransactionMoneris
WHERE DateTimeSettlement = @pSettDate
	AND CurrencyCode = @pCurrency

INSERT INTO dbo.tbl_rec_TransactionMoneris
(
	DateTimeSettlement
	,CurrencyCode
	,TerminalID
	,TraceNum
	,RefNum
	,DateTimeTerminalEvent
	,PAN
	,MsgType
	,PCode
	,CondCode
	,AccNo1
	,AccNo2
	,AmountRequested
	,AmountAuthorized
	,AmountSettlement
	,AmountInterchange
	,SwitchNo
	,ReceiptDate
	,IssProcessorID
	,IssInstitutionID
	,AcqProcessorID
	,AcqInstitutionID
	,ABMLocation
	,RespCode
	,CompCode
	,ConvRate
	,ProcFee
	,Settled
	,AcqNetCode
	,IssNetCode
)
SELECT 
	DateTimeSettlement = @pSettDate
	,CurrencyCode = CAST(RTRIM(SUBSTRING(LineData, 226, 3)) AS smallint)
	,TerminalID = RTRIM(SUBSTRING(LineData, 158, 8))
	,TraceNum = CONVERT(int, SUBSTRING(LineData, 94, 6))
	,RefNum = RTRIM(SUBSTRING(LineData, 86, 8))
	,DateTimeTerminalEvent = CONVERT(datetime, 
									CONVERT(varchar(4),(CASE 
															WHEN CONVERT(int, SUBSTRING(LineData, 100, 2)) > MONTH(@pSettDate) THEN YEAR(@pSettDate) - 1 
															ELSE YEAR(@pSettDate) 
														END))
									+ '-' + SUBSTRING(LineData, 100, 2) + '-' + SUBSTRING(LineData, 102, 2)
									+ ' ' + SUBSTRING(LineData, 112, 2) + ':' + SUBSTRING(LineData, 114, 2)
									+ ':' + SUBSTRING(LineData, 116, 2))
	,PAN = RIGHT(RTRIM(SUBSTRING(LineData, 13, 19)), 4)
	,MsgType = 5220
	,PCode = CONVERT(int, SUBSTRING(LineData, 7, 4))
	,CondCode = CONVERT(int, SUBSTRING(LineData, 5, 2))
	,AccNo1 = SUBSTRING(CONVERT(varchar(19), CONVERT(numeric(25, 0), RTRIM(SUBSTRING(LineData, 13, 19)))), 1, 6)
	,AccNo2 = ''
	,AmountRequested = CONVERT(money, REPLACE(SUBSTRING(LineData, 53, 8), ' ', '0')) / 100 
	,AmountAuthorized = CONVERT(money, REPLACE(SUBSTRING(LineData, 61, 8), ' ', '0')) / 100
	,AmountSettlement = CONVERT(money, REPLACE(SUBSTRING(LineData, 69, 8), ' ', '0')) / 100 
	,AmountInterchange = (CONVERT(money, REPLACE(SUBSTRING(LineData, 69, 8), ' ', '0')) - CONVERT(money, REPLACE(SUBSTRING(LineData, 61, 8), ' ', '0'))) / 100
	,SwitchNo = RTRIM(SUBSTRING(LineData, 77, 9))
	,ReceiptDate = SUBSTRING(LineData, 100, 4)
	,IssProcessorID = RTRIM(SUBSTRING(LineData, 118, 10))
	,IssInstitutionID = RTRIM(SUBSTRING(LineData, 128, 10)) 
	,AcqProcessorID = RTRIM(SUBSTRING(LineData, 138, 10))
	,AcqInstitutionID = RTRIM(SUBSTRING(LineData, 148, 10))
	,ABMLocation = RTRIM(SUBSTRING(LineData, 193, 15))
	,RespCode = RTRIM(SUBSTRING(LineData, 208, 8))
	,CompCode = RTRIM(SUBSTRING(LineData, 216, 10))
	,ConvRate = CONVERT(money, SUBSTRING(LineData, 230, 7)) / 1000000
	,ProcFee = CONVERT(money, SUBSTRING(LineData, 258, 6)) / 10000
	,Settled = SUBSTRING(LineData, 270, 1)
	,AcqNetCode = SUBSTRING(LineData, 264, 3) 
	,IssNetCode = SUBSTRING(LineData, 267, 3)
FROM dbo.tbl_rec_TransactionMonerisImport (NOLOCK)
WHERE LEFT(LineData, 4) = '5220'

INSERT INTO dbo.tbl_rec_TransactionMoneris
(
	DateTimeSettlement
	,CurrencyCode
	,TerminalID
	,TraceNum
	,RefNum
	,DateTimeTerminalEvent
	,PAN
	,MsgType
	,PCode
	,CondCode
	,AccNo1
	,AccNo2
	,AmountRequested
	,AmountAuthorized
	,AmountSettlement
	,AmountInterchange
	,SwitchNo
	,ReceiptDate
	,IssProcessorID
	,IssInstitutionID
	,AcqProcessorID
	,AcqInstitutionID
	,ABMLocation
	,RespCode
	,CompCode
	,ConvRate
	,ProcFee
	,Settled
	,AcqNetCode
	,IssNetCode
	,[AmountOrig] 
	,[AmountNew]
	,AmountRevDebit
	,AmountRevCredit
	,[OrigMsgType]
	,[OrigDataElements]
)
SELECT 
	DateTimeSettlement = @pSettDate
	,CurrencyCode = CAST(RTRIM(SUBSTRING(LineData, 286, 3)) AS smallint)
	,TerminalID = RTRIM(SUBSTRING(LineData, 214, 8)) 
	,TraceNum = CONVERT(int, SUBSTRING(LineData, 114, 6))
	,RefNum = RTRIM(SUBSTRING(LineData, 106, 8))
	,DateTimeTerminalEvent = CONVERT(datetime, 
									CONVERT(varchar(4), (CASE 
															WHEN CONVERT(int, SUBSTRING(LineData, 156, 2)) > Month(@pSettDate) THEN Year(@pSettDate) - 1 
															ELSE Year(@pSettDate) 
														END))
														+ '-' + SUBSTRING(LineData, 156, 2) + '-' + SUBSTRING(LineData, 158, 2)
														+ ' ' + SUBSTRING(LineData, 168, 2) + ':' + SUBSTRING(LineData, 170, 2)
														+ ':' + SUBSTRING(LineData, 172, 2))
	,PAN = RIGHT(RTRIM(SUBSTRING(LineData, 13, 19)), 4)
	,MsgType = 5240
	,PCode = CONVERT(int, SUBSTRING(LineData, 7, 4))
	,CondCode = CONVERT(int, SUBSTRING(LineData, 5, 2))
	,AccNo1 = SUBSTRING(CONVERT(varchar(19), CONVERT(numeric(25, 0), RTRIM(SUBSTRING(LineData, 13, 19)))), 1, 6)
	,AccNo2 = ''
	,AmountRequested = 0
	,AmountAuthorized = 0
	,AmountSettlement = (CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 69, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 69, 8)) / 100 
						END)
	,AmountInterchange = (CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 69, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 69, 8)) / 100 
						END)- 
						(CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 61, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 61, 8)) / 100 
						END)
	,SwitchNo = RTRIM(SUBSTRING(LineData, 97, 9))
	,ReceiptDate = SUBSTRING(LineData, 156, 4) 
	,IssProcessorID = RTRIM(SUBSTRING(LineData, 174, 10)) 
	,IssInstitutionID = RTRIM(SUBSTRING(LineData, 184, 10))
	,AcqProcessorID = RTRIM(SUBSTRING(LineData, 194, 10))
	,AcqInstitutionID = RTRIM(SUBSTRING(LineData, 204, 10))
	,ABMLocation = RTRIM(SUBSTRING(LineData, 249, 15))
	,RespCode = RTRIM(SUBSTRING(LineData, 268, 8))
	,CompCode = RTRIM(SUBSTRING(LineData, 276, 10)) 
	,ConvRate = CONVERT(money, SUBSTRING(LineData, 290, 7)) / 1000000
	,ProcFee = CONVERT(money, SUBSTRING(LineData, 297, 6)) / 10000 
	,Settled = SUBSTRING(LineData, 309, 1) 
	,AcqNetCode = SUBSTRING(LineData, 303, 3) 
	,IssNetCode = SUBSTRING(LineData, 306, 3)
	,AmountOrig = (CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 53, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 53, 8)) / 100 
						END) -- AmountOrig
	,AmountNew = (CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 61, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 61, 8)) / 100 
						END) -- AmountNew
	,AmountRevDebit = (CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 77, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 77, 8)) / 100 
						END) 
	,AmountRevCredit = (CASE 
							WHEN ISNUMERIC (SUBSTRING(LineData, 87, 8)) = 0 THEN CONVERT(money, 0)
							ELSE CONVERT(money, SUBSTRING(LineData, 87, 8)) / 100 
						END) 
	,OrigMsgType = CONVERT(int, SUBSTRING(LineData, 264, 4))
	,OrigDataElements = RTRIM(SUBSTRING(LineData, 120, 36))
FROM dbo.tbl_rec_TransactionMonerisImport (NOLOCK)
WHERE LEFT(LineData, 4) = '5240'

INSERT INTO dbo.tbl_rec_TransactionMoneris
(
	DateTimeSettlement
	,CurrencyCode
	,TerminalID
	,TraceNum
	,RefNum
	,DateTimeTerminalEvent
	,PAN
	,MsgType
	,PCode
	,CondCode
	,AccNo1
	,AccNo2
	,AmountRequested
	,AmountAuthorized
	,AmountSettlement
	,AmountInterchange
	,SwitchNo
	,ReceiptDate
	,IssProcessorID
	,IssInstitutionID
	,AcqProcessorID
	,AcqInstitutionID
	,ABMLocation
	,RespCode
	,CompCode
	,ConvRate
	,ProcFee
	,Settled
	,AcqNetCode
	,IssNetCode
	,[AmountOrig] 
	,[AmountNew]
	,AmountRevDebit
	,AmountRevCredit
	,[OrigMsgType]
	,[OrigDataElements]
)
SELECT 
	DateTimeSettlement = @pSettDate
	,CurrencyCode = @pCurrency
	,TerminalID = RTRIM(SUBSTRING(LineData, 142, 8))
	,TraceNum = CONVERT(int, SUBSTRING(LineData, 78, 6)) 
	,RefNum = RTRIM(SUBSTRING(LineData, 70, 8))
	,DateTimeTerminalEvent = CONVERT(datetime, 
							CONVERT(varchar(4),/* Set Transaction Year */
									(CASE 
										WHEN CONVERT(int, SUBSTRING(LineData, 84, 2)) > Month(@pSettDate) THEN Year(@pSettDate) - 1 
										ELSE Year(@pSettDate) 
									END))
							+ '-' + SUBSTRING(LineData, 84, 2) + '-' + SUBSTRING(LineData, 86, 2)
							+ ' ' + SUBSTRING(LineData, 96, 2) + ':' + SUBSTRING(LineData, 98, 2)
							+ ':' + SUBSTRING(LineData, 100, 2))
	,PAN = RIGHT(RTRIM(SUBSTRING(LineData, 13, 19)), 4)
	,MsgType = 5270
	,PCode = CONVERT(int, SUBSTRING(LineData, 7, 4))
	,CondCode = CONVERT(int, SUBSTRING(LineData, 5, 2))
	,AccNo1 = SUBSTRING(CONVERT(varchar(19), CONVERT(numeric(25, 0), RTRIM(SUBSTRING(LineData, 13, 19)))), 1, 6)
	,AccNo2 = ''
	,AmountRequested = 0
	,AmountAuthorized = 0
	,AmountSettlement = CONVERT(money, SUBSTRING(LineData, 53, 8)) / 100
	,AmountInterchange = CONVERT(money, SUBSTRING(LineData, 53, 8)) / 100 
	,SwitchNo = RTRIM(SUBSTRING(LineData, 61, 9))
	,ReceiptDate = SUBSTRING(LineData, 84, 4)
	,IssProcessorID = RTRIM(SUBSTRING(LineData, 102, 10)) 
	,IssInstitutionID = RTRIM(SUBSTRING(LineData, 112, 10)) 
	,AcqProcessorID = RTRIM(SUBSTRING(LineData, 122, 10))
	,AcqInstitutionID = RTRIM(SUBSTRING(LineData, 132, 10))
	,ABMLocation = RTRIM(SUBSTRING(LineData, 177, 15))
	,RespCode = RTRIM(SUBSTRING(LineData, 192, 8)) 
	,CompCode = RTRIM(SUBSTRING(LineData, 200, 10))
	,ConvRate = 0
	,ProcFee = CONVERT(money, SUBSTRING(LineData, 231, 6)) / 10000
	,Settled = SUBSTRING(LineData, 243, 1)
	,AcqNetCode = null
	,IssNetCode = null
	,[AmountOrig] = null
	,[AmountNew] = null
	,AmountRevDebit = null
	,AmountRevCredit = null
	,[OrigMsgType] = null
	,[OrigDataElements] = null
FROM dbo.tbl_rec_TransactionMonerisImport (NOLOCK)
WHERE LEFT(LineData, 4) = '5270'

END
GO
GRANT EXECUTE ON  [dbo].[usp_rec_TransactionMoneris_Load] TO [WebV4Role]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_ReconciliationImport]
@paramXML xml
AS
  DECLARE @ixml int
  
  EXEC sp_xml_preparedocument @ixml OUTPUT, @paramXML
  
  DECLARE @SettDateString varchar(20)
  SELECT @SettDateString = fsd from OPENXML(@ixml, '/file')
     WITH (fid varchar(20), fsd varchar(20))
  
  DECLARE @SettDate datetime
  SET @SettDate = convert(datetime, substring(@SettDateString, 1, 4)
    + '-' + substring(@SettDateString, 5, 2)
    + '-' + substring(@SettDateString, 7, 2))

  INSERT INTO [dbo].[tbl_trn_TransactionReconciliation]
  (
            [SystemDate]
           ,[FileId]
           ,[TransactionId]
           ,[NetworkTransactionId]
           ,[TransactionType]
           ,[IssuerNetworkId]
           ,[MerchantId]
           ,[TerminalName]
           ,[DeviceId]
           ,[DeviceDate]
           ,[DeviceSequence]
           ,[AmountRequest]
           ,[AmountSettlement]
           ,[AmountSurcharge]
           ,[AmountInterchange]
           ,[ResponseCodeInternal]
           ,[ResponseCodeExternal]
           ,[BINRange]
           ,[PAN]
           ,[RetrevalNumber]
           ,[ReverseType]
           ,[ProcessingFee]
           ,[RequestType]
           ,[SettlementStatus]
           ,[ReconciliationStatus]
           ,[UnreconciledStatus]
           ,[ReconciliationComment]
  )
  SELECT @SettDate AS SystemDate, 
    NULL AS FileID,
    NULL AS TransactionID,
    NULL AS NetworkTransactionID,
    tt AS TransactionType,
    nid AS IssuerNetworkID,
    null AS MerchantID,
    dn AS TerminalName,
    NULL AS DeviceID,
    convert(datetime, dd) AS DeviceDate,
    ds AS DeviceSequence,
    convert(bigint, ar * 100) AS AmountRequest,
    convert(bigint, at * 100) AS AmountSettlement,
    convert(bigint, [as] * 100) AS AmountSurcharge,
    convert(bigint, ai * 100) AS AmountInterchange,
    convert(bigint, rce) AS ResponseCodeInternal,
    rci AS ResponseCodeExternal,
    cm1 AS BINRange,
    cm2 AS PAN,
    rn AS RetrevalNumber,
    NULL AS ReverseType,
    convert(bigint, af * 100) AS ProcessingFee,
    NULL AS RequestType,
    NULL AS SettlementStatus,
    1 AS ReconciliationStatus,
    NULL AS UnreconciledStatus,
    NULL AS ReconciliationComment
  FROM OPENXML(@ixml, '/file/trn')
  WITH (tt varchar(20), dn varchar(20), dd varchar(30), ds varchar(20), ar money, [as] money,
    at money, ai money, af money, rci varchar(20), rce varchar(20), nid varchar(20),
    cm1 varchar(10), cm2 varchar(10), cmh varchar(10), rn varchar(20))
GO

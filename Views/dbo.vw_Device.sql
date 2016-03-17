SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Device]
AS
  SELECT de.Id,
         de.TerminalName,
         io.RegisteredName,
         de.CreatedDate,
         u1.UserName CreatedUser,
         de.ActivatedDate,
         de.UpdatedDate,
         u2.UserName UpdatedUser,
         de.ModelId,
         dm.Make,
         dm.Model,
         dm.FeatureFlags,
         dm.DeviceEmulation,
         v1.Name DeviceEmulationName,
         de.SerialNumber,
         de.FunctionFlags,
         de.RoutingFlags,
         de.QuestionablePolicy,
         de.FeeType,
         v2.Name LocationTypeName,
         v2.Description LocationTypeDesc,
         de.Location,
         de.RefusedTransactionTypeList,
         de.MaximumDispensedAmount,
         ct.CountryShortName,
         ad.RegionId,
         re.RegionShortName,
         re.RegionFullName,
         ad.City,
         ad.AddressLine1 Address,
         ad.PostalCode,
         de.TimeZoneId,
         tz.TimeZoneOffset,
         tz.TimeZoneName,
         tz.DayLightSavingTime,
         de.WorkingPinKeyCryptogram,
         de.WorkingPinKeyUpdatedDate,
         de.WorkingMacKeyCryptogram,
         de.WorkingMACKeyUpdatedDate,
         v3.Name DeviceStatusName,
         v3.Description DeviceStatusDesc,
         o1.DepositExec DepositExecSettlement, 
         o1.CutoverOffset CutoverOffsetSettlement,
         o2.DepositExec DepositExecSurcharge,  
         o2.CutoverOffset CutoverOffsetSurcharge,
         o3.DepositExec DepositExecInterchange,
         o3.CutoverOffset CutoverOffsetInterchange,
         sa.BankAccountId SettlementBankAccountId,
         ba.RTA SettlementBankAccountRTA,
         ss.SurchargeSplitCount,
         ic.InterchangeSchemeId,
         s1.StatusText AS MachineStatus, 
         s1.StatusIcon AS MachineStatusIcon,  
         s2.StatusText AS ErrorStatus, 
         s2.StatusIcon AS ErrorStatusIcon,           
         s3.StatusText AS CassetteStatus, 
         s3.StatusIcon AS CassetteStatusIcon, 
         s4.StatusText AS ActivityStatus,
         s4.StatusIcon AS ActivityStatusIcon,
         s5.StatusText AS DepositExecStatus,
         s5.StatusIcon AS DepositExecStatusIcon,
         CASE WHEN de.WorkingPinKeyCryptogram IS NOT NULL THEN 'Yes'
              ELSE                                             'No'
         END WorkingPinKeyStatus,
         CASE WHEN de.WorkingMacKeyCryptogram IS NOT NULL THEN 'Yes'
              ELSE                                             'No'
         END WorkingMacKeyStatus,
         CASE WHEN de.ModelId                    IS NOT NULL
               AND de.Location                   IS NOT NULL 
               AND de.LocationType               IS NOT NULL 
               AND ad.City                       IS NOT NULL 
               AND ad.RegionId                   IS NOT NULL 
               AND ad.PostalCode                 IS NOT NULL 
               AND de.TimeZoneID                 IS NOT NULL 
               AND de.FunctionFlags              IS NOT NULL 
               AND de.RefusedTransactionTypeList IS NOT NULL  
               AND de.MaximumDispensedAmount     IS NOT NULL 
               AND cn.ProtocolType               IS NOT NULL
               AND de.WorkingPinKeyCryptogram    IS NOT NULL  
               AND sa.BankAccountId              IS NOT NULL 
               AND ss.SurchargeSplitCount        IS NOT NULL 
              THEN 1
              ELSE 0
         END IsValid,         
         CASE WHEN de.DeviceStatus=1 
               AND lt.LastTransDate IS NULL                                THEN 'Blue'
              WHEN de.DeviceStatus=2                                       THEN 'Gray' 
              WHEN de.DeviceStatus=3                                       THEN 'Gray'
              WHEN de.ModelId                    IS NOT NULL
               AND de.Location                   IS NOT NULL 
               AND de.LocationType               IS NOT NULL 
               AND ad.City                       IS NOT NULL 
               AND ad.RegionId                   IS NOT NULL 
               AND ad.PostalCode                 IS NOT NULL 
               AND de.TimeZoneID                 IS NOT NULL 
               AND de.FunctionFlags              IS NOT NULL 
               AND de.RefusedTransactionTypeList IS NOT NULL  
               AND de.MaximumDispensedAmount     IS NOT NULL 
               AND cn.ProtocolType               IS NOT NULL
               AND de.WorkingPinKeyCryptogram    IS NOT NULL  
               AND sa.BankAccountId              IS NOT NULL 
               AND ss.SurchargeSplitCount        IS NOT NULL               THEN 'Red'
              WHEN er.DeviceId IS NOT NULL                                 THEN 'Red' 
              WHEN cs.CassetteStatus=4                                     THEN 'Red' 
              WHEN cs.CassetteStatus=3                                     THEN 'Orange' 
              WHEN ap.NotificationReason & 2 <>0 AND ap.InactiveTime > 0 AND lm.LastMgmtDate<DATEADD(n,ap.InactiveTime,GETUTCDATE()) THEN 'Yellow'
              ELSE                                                              'Green'
         END CssClass,
         de.FirstTransDate,
         lt.LastTransDate,
         lt.LastTransData,
         lm.LastMgmtDate,
         lm.LastMgmtData,
         CASE WHEN lt.LastTransDate IS NULL                      THEN 'N/A'
              WHEN DATEDIFF(hh,lt.LastTransDate,GETUTCDATE())<1  THEN '<1'
              ELSE CONVERT(varchar(20), DATEDIFF(hh,lt.LastTransDate,GETUTCDATE()))
         END TransactionInactiveTime,
         CASE WHEN lm.LastMgmtDate IS NULL                      THEN 'N/A'
              WHEN DATEDIFF(hh,lm.LastMgmtDate,GETUTCDATE())<1  THEN '<1'
              ELSE CONVERT(varchar(20), DATEDIFF(hh,lm.LastMgmtDate,GETUTCDATE()))
         END ManagementInactiveTime,
         ot.OpenTraceCount,
         c1.Currency                                Cassette1Currency,
         c1.MediaCode                               Cassette1MediaCode,
         c1.MediaValue                              Cassette1MediaValue,
         c1.MediaCurrentCount                       Cassette1MediaCurrentCount,
         c1.MediaCurrentUse                         Cassette1MediaCurrentUse,
         c1.MediaCurrentAdjust                      Cassette1MediaCurrentAdjust,
         c1.MediaCurrentCount+c1.MediaCurrentAdjust Cassette1MediaAdjustedCount,
         c1.ReplenishmentDate                       Cassette1ReplenishmentDate,
         c2.Currency                                Cassette2Currency,
         c2.MediaCode                               Cassette2MediaCode,
         c2.MediaValue                              Cassette2MediaValue,
         c2.MediaCurrentCount                       Cassette2MediaCurrentCount,
         c2.MediaCurrentUse                         Cassette2MediaCurrentUse,
         c2.MediaCurrentAdjust                      Cassette2MediaCurrentAdjust,
         c2.MediaCurrentCount+c2.MediaCurrentAdjust Cassette2MediaAdjustedCount,
         c2.ReplenishmentDate                       Cassette2ReplenishmentDate,
         c3.Currency                                Cassette3Currency,
         c3.MediaCode                               Cassette3MediaCode,
         c3.MediaValue                              Cassette3MediaValue,
         c3.MediaCurrentCount                       Cassette3MediaCurrentCount,
         c3.MediaCurrentUse                         Cassette3MediaCurrentUse,
         c3.MediaCurrentAdjust                      Cassette3MediaCurrentAdjust,
         c3.MediaCurrentCount+c3.MediaCurrentAdjust Cassette3MediaAdjustedCount,
         c3.ReplenishmentDate                       Cassette3ReplenishmentDate,         
         c4.Currency                                Cassette4Currency,
         c4.MediaCode                               Cassette4MediaCode,
         c4.MediaValue                              Cassette4MediaValue,
         c4.MediaCurrentCount                       Cassette4MediaCurrentCount,
         c4.MediaCurrentUse                         Cassette4MediaCurrentUse,
         c4.MediaCurrentAdjust                      Cassette4MediaCurrentAdjust,
         c4.MediaCurrentCount+c4.MediaCurrentAdjust Cassette4MediaAdjustedCount,
         c4.ReplenishmentDate                       Cassette4ReplenishmentDate,
         cs.CassetteTotalCount,
         cs.CassetteTotalValue,
         cf.ScreenFileName,
         cf.StateFileName,
         sf.DefAuthState         StateFileDefAuthState,
         sf.DefDenyState         StateFileDefDenyState,
         sf.NextStates           StateFileNextStates,
         sf.LanguageStateOffsets StateFileLanguageStateOffsets,
         cf.ConfigValueFileName,
         vf.OverrideFileName,
         vf.OverrideFileDesc,
         co.ConfigID,
         cn.ProtocolType,
         v5.name ProtocolTypeName,
         cn.Caller,
         cn.LocalAddress,
         cn.CommsAPIType,
         v6.name CommsAPITypeName,
         cn.LocalIPAddress,
         cn.LocalPort,
         cn.RemoteIPAddress,
         cn.RemotePort,
         cn.IPAddressFlags,
         dc.WithdrawalCount              SettlementWithdrawalCount,
         dc.TransferCount                SettlementTransferCount,
         dc.DebitPurchaseCount           SettlementDebitPurchaseCount,
         dc.CreditPurchaseCount          SettlementCreditPurchaseCount,
         dc.DebitMerchandiseReturnCount  SettlementDebitMerchandiseReturnCount,
         dc.CreditMerchandiseReturnCount SettlementCreditMerchandiseReturnCount,
         dc.DepositCount                 SettlementDepositCount,
         dc.StatementCount               SettlementStatementCount,
         dc.ReversalWithdrawalCount+dc.ReversalTransferCount+dc.ReversalDepositCount+dc.ReversalDebitPurchaseCount+dc.ReversalCreditPurchaseCount+dc.ReversalPreAuthorizationCount+dc.ReversalPreAuthorizationCompletionCount+dc.ReversalDebitMerchandiseReturnCount+dc.ReversalCreditMerchandiseReturnCount+dc.ReversalVoidSaleCount+dc.ReversalVoidMerchandiseReturnCount SettlementReversalCount,
         dc.WithdrawalSum                SettlementWithdrawalSum,
         dc.SurchargeSum                 SettlementSurchargeSum,
         dc.DebitPurchaseSum             SettlementDebitPurchaseSum,
         dc.CreditPurchaseSum            SettlementCreditPurchaseSum,
         dc.DebitMerchandiseReturnSum    SettlementDebitMerchandiseReturnSum,
         dc.CreditMerchandiseReturnSum   SettlementCreditMerchandiseReturnSum,
         dc.DepositSum                   SettlementDepositSum,
         dc.ClosedDate                   SettlementClosedDate
  FROM dbo.tbl_Device de
  LEFT JOIN dbo.tbl_DeviceModel                  dm ON de.ModelId=dm.Id
  LEFT JOIN dbo.tbl_Iso                          io ON de.IsoId=io.Id 
  LEFT JOIN dbo.tbl_TimeZone                     tz ON de.TimeZoneId=tz.Id
  LEFT JOIN dbo.tbl_Address                      ad ON de.AddressId=ad.Id LEFT JOIN dbo.tbl_Region re ON ad.RegionId=re.Id LEFT JOIN dbo.tbl_Country ct ON re.CountryId=ct.Id
  LEFT JOIN dbo.tbl_DeviceCutoverOffset          o1 ON de.Id=o1.DeviceId AND o1.FundsType=1
  LEFT JOIN dbo.tbl_DeviceCutoverOffset          o2 ON de.Id=o2.DeviceId AND o2.FundsType=2
  LEFT JOIN dbo.tbl_DeviceCutoverOffset          o3 ON de.Id=o3.DeviceId AND o3.FundsType=3
  LEFT JOIN dbo.tbl_DeviceToSettlementAccount    sa ON de.Id=sa.DeviceId AND sa.StartDate<=GETUTCDATE() AND sa.EndDate>GETUTCDATE() LEFT JOIN dbo.tbl_BankAccount ba ON sa.BankAccountId=ba.Id
  LEFT JOIN dbo.tbl_DeviceToInterchangeScheme    ic ON de.Id=ic.DeviceId
  LEFT JOIN dbo.tbl_DeviceAlertPlus              ap ON de.Id=ap.DeviceId
  LEFT JOIN dbo.tbl_DeviceCassette               c1 ON de.Id=c1.DeviceId AND c1.CassetteId=1
  LEFT JOIN dbo.tbl_DeviceCassette               c2 ON de.Id=c2.DeviceId AND c2.CassetteId=2
  LEFT JOIN dbo.tbl_DeviceCassette               c3 ON de.Id=c3.DeviceId AND c3.CassetteId=3
  LEFT JOIN dbo.tbl_DeviceCassette               c4 ON de.Id=c4.DeviceId AND c4.CassetteId=4
  LEFT JOIN dbo.tbl_DeviceConfig                 co ON de.Id=co.DeviceId LEFT JOIN dbo.tbl_DeviceConfigFile cf ON co.DeviceConfigFileId=cf.Id LEFT JOIN dbo.tbl_DeviceOverrideFile vf ON co.DeviceOverrideFileId=vf.Id LEFT JOIN dbo.tbl_DeviceStateFile sf ON cf.StateFileName=sf.StateFileName
  LEFT JOIN dbo.tbl_DeviceConnection             cn ON de.Id=cn.DeviceId 
  
  LEFT JOIN dbo.vw_DeviceCassette                cs ON de.Id=cs.DeviceId
  LEFT JOIN dbo.vw_DeviceLastTransaction         lt ON de.Id=lt.DeviceId
  LEFT JOIN dbo.vw_DeviceLastManagementActivity  lm ON de.Id=lm.DeviceId
  LEFT JOIN dbo.vw_DeviceError                   er ON de.Id=er.DeviceId
  LEFT JOIN dbo.vw_DeviceOpenTraceCount          ot ON de.Id=ot.DeviceId
  LEFT JOIN dbo.vw_DeviceSurchargeSplitCount     ss ON de.Id=ss.DeviceId
  LEFT JOIN dbo.vw_DeviceDayClose                dd ON de.Id=dd.DeviceId LEFT JOIN dbo.tbl_DeviceDayClose dc ON dd.DeviceId=dc.DeviceId AND dd.ClosedDate=dc.ClosedDate 

  LEFT JOIN dbo.tbl_upm_User                     u1 ON de.CreatedUserId=u1.Id
  LEFT JOIN dbo.tbl_upm_User                     u2 ON de.UpdatedUserId=u2.Id
  
  LEFT JOIN dbo.tbl_TypeValue                    v1 ON v1.TypeId=131 AND v1.Value=dm.DeviceEmulation  
  LEFT JOIN dbo.tbl_TypeValue                    v2 ON v2.TypeId=173 AND v2.Value=de.LocationType
  LEFT JOIN dbo.tbl_TypeValue                    v3 ON v3.TypeId=23  AND v3.Value=de.DeviceStatus
  LEFT JOIN dbo.tbl_TypeValue                    v4 ON v4.TypeId=177 AND v4.Value=cs.CassetteStatus
  LEFT JOIN dbo.tbl_TypeValue                    v5 ON v5.TypeId=151 AND v5.Value=cn.ProtocolType  
  LEFT JOIN dbo.tbl_TypeValue                    v6 ON v6.TypeId=153 AND v6.Value=cn.CommsAPIType  
  
  LEFT JOIN dbo.tbl_DeviceStatusIcons            s1 ON (
    CASE WHEN de.DeviceStatus = 1 AND er.DeviceID IS NOT NULL      THEN 'DOWN' 
         WHEN de.DeviceStatus = 1 AND lt.LastTransDate IS NOT NULL THEN 'UP' 
         WHEN de.DeviceStatus = 1 AND lt.LastTransDate IS NULL     THEN 'ACTIVATED - NOT LIVE' 
         WHEN de.DeviceStatus = 3                                  THEN 'PENDING ACTIVATION' 
         ELSE                                                           'DISABLED' 
    END)=s1.StatusText AND s1.StatusType='MACH'       
  LEFT JOIN dbo.tbl_DeviceStatusIcons            s2 ON (
    CASE  WHEN er.DeviceID IS NULL THEN 'GOOD' 
          ELSE                          'ERRORS' 
    END)=s2.StatusText AND s2.StatusType='ERRS'
  LEFT JOIN dbo.tbl_DeviceStatusIcons            s3 ON 
    v4.Name=s3.StatusText AND s3.StatusType='CASH'
  LEFT JOIN dbo.tbl_DeviceStatusIcons            s4 ON (  
    CASE WHEN lt.LastTransDate>=DATEADD(n,ap.InactiveTime,GETUTCDATE()) THEN 'ACTIVE'
         WHEN lm.LastMgmtDate >=DATEADD(n,ap.InactiveTime,GETUTCDATE()) THEN 'HEARTBEAT ONLY'
         ELSE                                                                'INACTIVE'
    END)=s4.StatusText AND s4.StatusType='ACTV'
  LEFT JOIN dbo.tbl_DeviceStatusIcons            s5 ON (  
    CASE WHEN o1.DepositExec IS NULL AND o2.DepositExec IS NULL AND o3.DepositExec IS NULL THEN 'DISABLED'
         ELSE                                                                                   'ENABLED'
    END)=s5.StatusText AND s5.StatusType='EXEC'

GO

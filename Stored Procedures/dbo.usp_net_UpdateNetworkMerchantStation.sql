SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_UpdateNetworkMerchantStation]
@NetworkMerchantStationId  bigint,
@NetworkMerchantId         bigint,
@StationNumber             nvarchar(10),
@CheckType                 bigint,
@ServiceType               bigint, 
@AccountChain              char(6),
@CheckLimit                bigint,
@SDelayDays                numeric(3,0),
@VarianceLimit             numeric(3,0),
@OverridePermitted         char(1),
@AdjustToCAP               char(1),
@CheckNumberRequired       char(1),
@StandInModeAPermitted     char(1),
@StandInModeCPermitted     char(1),
@StandInLimit              numeric(12,2),
@ACHEntryClass             bigint,
@ExpiryDays                numeric(3,0),
@DVariancePermitted        char(1),
@DefaultStation            char(1),
@StationName               nvarchar(30),
@PayToName                 nvarchar(20),
@CreditEligible            nvarchar(1),
@SSNNumberReqFlag          nvarchar(1),
@IDType                    bigint,
@SettlementType            bigint,
@StatusId                  numeric(4,0),
@CreditLimit               bigint,
@ManualFMEntryAllowed      nvarchar(1),
@SettlementOption          nvarchar(1),
@SettleSmartOption         nvarchar(1),
@FrankingOption            nvarchar(1),
@OTB_Enabled               nvarchar(1),
@OTB_Casino_Day_FLG        nvarchar(1),
@Cust_Trans_Hist_Option    nvarchar(1),
@Cust_Trans_Hist_Days      numeric(3,0),
@TXNORGID                  bigint,
@Service_Fee_Option        nvarchar(1),
@ACH_Manual_Entry_Override nvarchar(1),
@Tribal_ID_Option          nvarchar(1),
@Mexican_ID_Option         nvarchar(1),
@Kiosk_Enabled             nvarchar(1),
@UpdatedUserId             bigint
--@SmartAcquireId         bigint =0
AS
BEGIN
  SET NOCOUNT ON
  --Declare @NetworkId bigint
  UPDATE dbo.tbl_NetworkMerchantStation SET 
    NetworkMerchantId=@NetworkMerchantId,StationNumber=@StationNumber,CheckType=@CheckType,ServiceType=@ServiceType,AccountChain=@AccountChain,
    CheckLimit=@CheckLimit,SDelayDays=@SDelayDays,VarianceLimit=@VarianceLimit,OverridePermitted=@OverridePermitted,AdjustToCAP=@AdjustToCAP,
    CheckNumberRequired=@CheckNumberRequired,StandInModeAPermitted=@StandInModeAPermitted,StandInModeCPermitted=@StandInModeCPermitted,
    StandInLimit=@StandInLimit,ACHEntryClass=@ACHEntryClass,ExpiryDays=@ExpiryDays,DVariancePermitted=@DVariancePermitted,
    DefaultStation=@DefaultStation,StationName=@StationName,PayToName=@PayToName,CreditEligible=@CreditEligible,SSNNumberReqFlag=@SSNNumberReqFlag,
    IDType=@IDType,SettlementType=@SettlementType,StatusId=@StatusId,CreditLimit=@CreditLimit,ManualFMEntryAllowed=@ManualFMEntryAllowed,
    SettlementOption=@SettlementOption,SettleSmartOption=@SettleSmartOption,FrankingOption=@FrankingOption,OTB_Enabled=@OTB_Enabled,
    OTB_Casino_Day_FLG=@OTB_Casino_Day_FLG,Cust_Trans_Hist_Option=@Cust_Trans_Hist_Option,Cust_Trans_Hist_Days=@Cust_Trans_Hist_Days,
    TXNORGID=@TXNORGID,Service_Fee_Option=@Service_Fee_Option,ACH_Manual_Entry_Override=@ACH_Manual_Entry_Override,
    Tribal_ID_Option=@Tribal_ID_Option,Mexican_ID_Option=@Mexican_ID_Option,Kiosk_Enabled=@Kiosk_Enabled,UpdatedUserId=@UpdatedUserId
  WHERE Id=@NetworkMerchantStationId
 -- SELECT @NetworkId=NetworkId from dbo.tbl_NetworkMerchant where  Id=@NetworkMerchantId
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_UpdateNetworkMerchantStation] TO [WebV4Role]
GO

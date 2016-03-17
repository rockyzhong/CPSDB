SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_InsertNetworkMerchantStation]
@NetworkMerchantStationId  bigint OUTPUT,
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
--@SmartAcquireId  bigint =0
AS
BEGIN
  SET NOCOUNT ON
--  Declare @NetworkId bigint
  INSERT INTO dbo.tbl_NetworkMerchantStation
        (NetworkMerchantId,StationNumber,CheckType,ServiceType,AccountChain,CheckLimit,SDelayDays,VarianceLimit,OverridePermitted,AdjustToCAP,
         CheckNumberRequired,StandInModeAPermitted,StandInModeCPermitted,StandInLimit,ACHEntryClass,ExpiryDays,DVariancePermitted,
         DefaultStation,StationName,PayToName,CreditEligible,SSNNumberReqFlag,IDType,SettlementType,StatusId,CreditLimit,
         ManualFMEntryAllowed,SettlementOption,SettleSmartOption,FrankingOption,OTB_Enabled,OTB_Casino_Day_FLG,Cust_Trans_Hist_Option,
         Cust_Trans_Hist_Days,TXNORGID,Service_Fee_Option,ACH_Manual_Entry_Override,Tribal_ID_Option,Mexican_ID_Option,Kiosk_Enabled,
         UpdatedUserId) 
  VALUES(@NetworkMerchantId,@StationNumber,@CheckType,@ServiceType,@AccountChain,@CheckLimit,@SDelayDays,@VarianceLimit,@OverridePermitted,@AdjustToCAP,
         @CheckNumberRequired,@StandInModeAPermitted,@StandInModeCPermitted,@StandInLimit,@ACHEntryClass,@ExpiryDays,@DVariancePermitted,
         @DefaultStation,@StationName,@PayToName,@CreditEligible,@SSNNumberReqFlag,@IDType,@SettlementType,@StatusId,@CreditLimit,
         @ManualFMEntryAllowed,@SettlementOption,@SettleSmartOption,@FrankingOption,@OTB_Enabled,@OTB_Casino_Day_FLG,@Cust_Trans_Hist_Option,
         @Cust_Trans_Hist_Days,@TXNORGID,@Service_Fee_Option,@ACH_Manual_Entry_Override,@Tribal_ID_Option,@Mexican_ID_Option,@Kiosk_Enabled,
         @UpdatedUserId)

  SELECT @NetworkMerchantStationId=IDENT_CURRENT('tbl_NetworkMerchantStation')
 -- SELECT @NetworkId from dbo.tbl_NetworkMerchant where  MerchantId=@NetworkMerchantId 
 -- exec usp_acq_InsertNetworkUpdateCommands @SmartAcquireId,@NetworkId
  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_InsertNetworkMerchantStation] TO [WebV4Role]
GO

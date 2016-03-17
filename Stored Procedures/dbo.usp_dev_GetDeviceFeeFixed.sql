SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceFeeFixed] 
@DeviceId                bigint,
@AmountRequest           bigint,
@TransactionType         bigint,
@TransactionFlags        bigint,
@BinRange                nvarchar(6),
@BinGroup                bigint,
@SourceAccountType       bigint,
@FeeFixed                bigint OUTPUT,
@FeePercentage           bigint OUTPUT
AS
BEGIN 
  SET NOCOUNT ON

  SET @FeeFixed=NULL
  SET @FeePercentage=NULL

  -- Prepare parameters
  DECLARE @SystemDate date
  SET @SystemDate = GETUTCDATE();
 
 DECLARE @FeeType bigint
 SELECT @FeeType=FeeType FROM dbo.tbl_DeviceFeeType WHERE TransactionType=@TransactionType AND FeeType NOT IN (91,92)
 
  -- Get override device fee 
  DECLARE @Match bigint = 0,@Id bigint,@FeeOverrideType bigint,@FeeOverrideData nvarchar(200)
  DECLARE TempCursor CURSOR LOCAL FOR SELECT Id FROM dbo.tbl_DeviceFeeOverride WHERE DeviceId=@DeviceId ORDER BY FeeOverridePriority DESC
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @Id
  WHILE @@Fetch_Status=0 AND @Match=0
  BEGIN
    SET @Match=1
    DECLARE TmpCursor CURSOR LOCAL FOR SELECT FeeOverrideType,FeeOverrideData FROM dbo.tbl_DeviceFeeOverrideRule WHERE FeeOverrideId=@Id
    OPEN TmpCursor
    FETCH NEXT FROM TmpCursor INTO @FeeOverrideType,@FeeOverrideData
    WHILE @@Fetch_Status=0 AND @Match=1
    BEGIN
      IF @FeeOverrideType=0 AND NOT (@BinRange=@FeeOverrideData)                                                       -- BIN
        SET @Match=0         
      IF @FeeOverrideType=1 AND NOT (@AmountRequest<CONVERT(bigint,CONVERT(money,@FeeOverrideData)*100))               -- Under Amount
        SET @Match=0  
      IF @FeeOverrideType=2 AND NOT (@FeeType=CONVERT(bigint,@FeeOverrideData)
                                 OR (@TransactionType IN (7,8,9,10,11,12)
                                AND ((@TransactionFlags & 0x00080000 > 0 AND CONVERT(bigint,@FeeOverrideData)=91) 
                                 OR  (@TransactionFlags & 0x00080000 = 0 AND CONVERT(bigint,@FeeOverrideData)=92))))    -- FeeType
        SET @Match=0            
      IF @FeeOverrideType=3 AND NOT(@AmountRequest>CONVERT(bigint,CONVERT(money,@FeeOverrideData)*100))                 -- Over Amount
        SET @Match=0  
      IF @FeeOverrideType=4 AND NOT(@BinGroup=CONVERT(bigint,@FeeOverrideData))                                         -- BIN Group 
        SET @Match=0 
      IF @FeeOverrideType=6 AND NOT(@SourceAccountType=CONVERT(bigint,@FeeOverrideData))                                -- Account Type
        SET @Match=0
      IF @FeeOverrideType=7 AND NOT(@SystemDate>CONVERT(date,@FeeOverrideData))                                         -- After Date
        SET @Match=0 
      IF @FeeOverrideType=8 AND NOT(@SystemDate<CONVERT(date,@FeeOverrideData))                                         -- Before Date
        SET @Match=0
     
      FETCH NEXT FROM TmpCursor INTO @FeeOverrideType,@FeeOverrideData
    END
    CLOSE TmpCursor
    DEALLOCATE TmpCursor
    
    IF @Match=0 
      FETCH NEXT FROM TempCursor INTO @Id
  END  
  
  -- Get device fee 
  IF @Match=1
    SELECT @FeeFixed=FeeFixed,@FeePercentage=FeePercentage FROM dbo.tbl_DeviceFeeOverride WHERE Id=@Id
  ELSE  
  BEGIN    
    SELECT TOP 1 @FeeFixed=FeeFixed,@FeePercentage=FeePercentage+FeeAddedPercentage
    FROM dbo.tbl_DeviceFee
    WHERE  DeviceId=@DeviceId
      AND  StartDate<=@SystemDate AND EndDate>=@SystemDate
      AND  AmountFrom<=@AmountRequest AND AmountTo>=@AmountRequest
      AND  (FeeType=@FeeType OR (@TransactionType IN (7,8,9,10,11,12) AND ((@TransactionFlags & 0x00080000 > 0 AND FeeType=91) /*POS Credit*/ OR (@TransactionFlags & 0x00080000 = 0 AND FeeType=92) /*POS Debit*/ )))
    ORDER BY FeeType  
  
    IF @FeeFixed IS NULL
    BEGIN
      DECLARE @IsoId bigint
      SELECT @IsoId=IsoId FROM dbo.tbl_Device WHERE Id=@DeviceId
      SELECT TOP 1 @FeeFixed=FeeFixed,@FeePercentage=FeePercentage+FeeAddedPercentage
      FROM dbo.tbl_DeviceFee
      WHERE  IsoId=@IsoId
        AND  StartDate<=@SystemDate AND EndDate>=@SystemDate
        AND  AmountFrom<=@AmountRequest AND AmountTo>=@AmountRequest
        AND  (FeeType=@FeeType OR (@TransactionType IN (7,8,9,10,11,12) AND ((@TransactionFlags & 0x00080000 > 0 AND FeeType=91) /*POS Credit*/ OR (@TransactionFlags & 0x00080000 = 0 AND FeeType=92) /*POS Debit*/ )))
      ORDER BY FeeType  
    END
    
    IF @FeeFixed IS NULL
      SET @FeeFixed=0
    IF @FeePercentage IS NULL
      SET @FeePercentage=0
  END  
    
  RETURN 0
END


GO
GRANT EXECUTE ON  [dbo].[usp_dev_GetDeviceFeeFixed] TO [WebV4Role]
GO

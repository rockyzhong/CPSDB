SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bin_LoadBINRangeFile]
@FilePath nvarchar(1000)
AS 
BEGIN
  SET NOCOUNT ON
  
  --Network priority list for transaction type matching when they have same BINVal and PANLen ( USA only )
  DECLARE @NetworkIDs TABLE(Id bigint IDENTITY(1,1),NetworkId nvarchar(5) PRIMARY KEY)
  INSERT INTO @NetworkIDs(NetworkId) VALUES('PAS') -- highest prority
  INSERT INTO @NetworkIDs(NetworkId) VALUES('PUL')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('QST')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('STA')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('STP')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('AFN')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('NYC')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('STV')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('ILK')   
  INSERT INTO @NetworkIDs(NetworkId) VALUES('CUP')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('CRS')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('DIS')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('PLS')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('MAP')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('AMX')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('PLV')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('BPY')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('MIS')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('MPS')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('OK1')
  INSERT INTO @NetworkIDs(NetworkId) VALUES('PSP') -- lowest priority
  
  DECLARE @FileName nvarchar(200),@RowTerminator nvarchar(10),@FirstRow bigint,@CountryNumberCode bigint,@BINVal nvarchar(20),@BINValStart bigint,@BINValStart1 bigint,@BINValStart2 bigint,@BINValStart3 bigint,
  @BINValLength bigint,@BINLen bigint,@BINLenStart bigint,@BINLenStart1 bigint,@BINLenStart2 bigint,@BINLenStart3 bigint,@BINLenLength bigint,@PANLen bigint,@PANLenStart bigint,@PANLenStart1 bigint,
  @PANLenStart2 bigint,@PANLenStart3 bigint,@PANLenLength bigint,@NetworkIDStart bigint,@NetworkIDLength bigint,@NetworkID nvarchar(10),
  @CountryCodeStart bigint,@CountryCodeStart1 bigint,@CountryCodeStart2 bigint,@CountryCodeStart3 bigint,@CountryCodeLength bigint,@CountryCode nvarchar(5),@CountryCode0 nvarchar(5),
  @CreditDebitFlag bigint,@CreditFlag nvarchar(2),@CreditFlagStart bigint,@CreditFlagLength bigint,@DebitFlag nvarchar(2),@DebitFlagStart bigint,@DebitFlagLength bigint,
  @TransactionTypeList nvarchar(200),@ATMFlag nvarchar(1),@ATMFlagStart bigint,@ATMFlagLength bigint,@POSFlag nvarchar(1),@POSFlagStart bigint,@POSFlagLength bigint,
  @BinGroup bigint,@SQL nvarchar(1000),@Line nvarchar(500),@i bigint,@j bigint,@K bigint,@N bigint,@Action nvarchar(10),@BINGroup0 bigint,@Id0 bigint,@NetworkID0 nvarchar(10),@TransactionTypeList0 nvarchar(200)
   
  SET @FileName=REVERSE(LEFT(REVERSE(@FilePath),CHARINDEX('\',REVERSE(@FilePath))-1))
  SELECT @RowTerminator=RowTerminator,@FirstRow=FirstRow,@CountryNumberCode=CountryNumberCode,@BINValStart1=BINValStart1,@BINValStart2=BINValStart2,@BINValStart3=BINValStart3,
         @BINValLength=BINValLength,@BINLenStart1=BINLenStart1,@BINLenStart2=BINLenStart2,@BINLenStart3=BINLenStart3,@BINLenLength=BINLenLength,
         @PANLenStart1=PANLenStart1,@PANLenStart2=PANLenStart2,@PANLenStart3=PANLenStart3,@PANLenLength=PANLenLength,@CountryCodeStart1=CountryCodeStart1,
         @CountryCodeStart2=CountryCodeStart2,@CountryCodeStart3=CountryCodeStart3,@CountryCodeLength=CountryCodeLength,@CountryCode0=CountryCode,
         @NetworkIDStart=NetworkIDStart,@NetworkIDLength=NetworkIDLength,@NetworkID=NetworkID,@CreditDebitFlag=CreditDebitFlag,
         @CreditFlagStart=CreditFlagStart,@CreditFlagLength=CreditFlagLength,@DebitFlagStart=DebitFlagStart,@DebitFlagLength=DebitFlagLength,
         @TransactionTypeList=TransactionTypeList,@ATMFlagStart=ATMFlagStart,@ATMFlagLength=ATMFlagLength,@POSFlagStart=POSFlagStart,
         @POSFlagLength=POSFlagLength
  FROM dbo.tbl_BINRangeFile WHERE @FileName LIKE FileName       

  TRUNCATE TABLE dbo.tbl_BINRangeFileLine

  IF @FileName LIKE 'Interac_SCD_%.xls'
    SET @SQL='INSERT dbo.tbl_BINRangeFileLine SELECT F6+REPLICATE('' '',20-LEN(F6))+REPLICATE(''0'',2-LEN(F15))+F15 FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0;IMEX=1;Database='+@FilePath+''',[''SCD IIN List$''])'
  ELSE IF @RowTerminator='CHAR(10)'
    SET @SQL='BULK INSERT dbo.tbl_BINRangeFileLine FROM '''+@FilePath+''' WITH (FIELDTERMINATOR=''`'',ROWTERMINATOR ='''+CHAR(10)+''',FIRSTROW='+CONVERT(nvarchar,@FirstRow)+')'
  ELSE
    SET @SQL='BULK INSERT dbo.tbl_BINRangeFileLine FROM '''+@FilePath+''' WITH (FIELDTERMINATOR=''`'',ROWTERMINATOR ='''+@RowTerminator+''',FIRSTROW='+CONVERT(nvarchar,@FirstRow)+')'
  EXEC(@SQL)

  SET @i=1
  BEGIN TRANSACTION
  DECLARE TempCursor CURSOR LOCAL FOR SELECT Line FROM dbo.tbl_BINRangeFileLine WHERE Line IS NOT NULL AND Line NOT LIKE '999999%' AND LINE NOT LIKE 'TAPETRAILER%'
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @Line
  WHILE @@FETCH_STATUS=0
  BEGIN
    SET @j=1
    WHILE @j<4
    BEGIN
      IF @j=1 BEGIN SET @BINValStart=@BINValStart1  SET @BINLenStart=@BINLenStart1  SET @PANLenStart=@PANLenStart1  SET @CountryCodeStart=@CountryCodeStart1  END
      IF @j=2 BEGIN SET @BINValStart=@BINValStart2  SET @BINLenStart=@BINLenStart2  SET @PANLenStart=@PANLenStart2  SET @CountryCodeStart=@CountryCodeStart2  END          
      IF @j=3 BEGIN SET @BINValStart=@BINValStart3  SET @BINLenStart=@BINLenStart3  SET @PANLenStart=@PANLenStart3  SET @CountryCodeStart=@CountryCodeStart3  END

      IF @BINValStart IS NOT NULL AND @BINValLength IS NOT NULL 
      BEGIN
        SET @BINVal=SUBSTRING(@Line,@BINValStart,@BINValLength)
        SET @BINVal=RTRIM(@BINVal)

        IF @BINLenStart IS NOT NULL AND @BINLenLength IS NOT NULL 
        BEGIN
          SET @BINLen=CONVERT(bigint,SUBSTRING(@Line,@BINLenStart,@BINLenLength))
          SET @BINVal=SUBSTRING(@BINVal,1,@BINLen)
        END  
        ELSE
          SET @BINLen=LEN(@BINVal)

        IF @PANLenStart IS NOT NULL AND @PANLenLength IS NOT NULL  
          SET @PANLen=CONVERT(bigint,SUBSTRING(@Line,@PANLenStart,@PANLenLength))

        IF @CountryCodeStart IS NOT NULL AND @CountryCodeLength IS NOT NULL 
        BEGIN
          SET @CountryCode=SUBSTRING(@Line,@CountryCodeStart,@CountryCodeLength)
          IF RTRIM(@CountryCode) IN ('','***')  SET @CountryCode=@CountryCode0
        END
        ELSE
          SET @CountryCode=@CountryCode0

        IF @NetworkIDStart IS NOT NULL AND @NetworkIDLength IS NOT NULL 
        BEGIN
          SET @NetworkID=SUBSTRING(@Line,@NetworkIDStart,@NetworkIDLength)
          IF @NetworkID='STAR'  SET @NetworkID='STR'
          IF @NetworkID='PLUS'  SET @NetworkID='PLS'
        END  

        IF @CreditFlagStart IS NOT NULL AND @CreditFlagLength IS NOT NULL AND @DebitFlagStart IS NOT NULL AND @DebitFlagLength IS NOT NULL
        BEGIN
          SET @CreditFlag=SUBSTRING(@Line,@CreditFlagStart,@CreditFlagLength)
          SET @DebitFlag =SUBSTRING(@Line,@DebitFlagStart,@DebitFlagLength)

          IF @CreditFlag='99' AND @DebitFlag='99'  SET @CreditDebitFlag=3
          ELSE IF @DebitFlag='99'                  SET @CreditDebitFlag=2
          ELSE IF @CreditFlag='99'                 SET @CreditDebitFlag=1
        END  

        IF @ATMFlagStart IS NOT NULL AND @ATMFlagLength IS NOT NULL AND @POSFlagStart IS NOT NULL AND @POSFlagLength IS NOT NULL
        BEGIN
          SET @ATMFlag=SUBSTRING(@Line,@ATMFlagStart,@ATMFlagLength)
          SET @POSFlag=SUBSTRING(@Line,@POSFlagStart,@POSFlagLength)              

          IF @NetworkID IN ('ILK')                             SET @TransactionTypeList='7,8,9,11'
          ELSE IF @NetworkID IN ('CUP','PUL','STV')
          BEGIN
          IF @ATMFlag='1' AND @POSFlag='1'                     SET @TransactionTypeList='1,2,3,4,5,7,8,9,10,11,12'
            ELSE IF @ATMFlag='1'                               SET @TransactionTypeList='1,2,3,4,5,10,12'
            ELSE IF @POSFlag='1'                               SET @TransactionTypeList='7,8,9,10,11,12'
          END
          ELSE IF @NetworkID IN ('STA','STP')
          BEGIN
            IF @ATMFlag='1' AND @POSFlag='1'                   SET @TransactionTypeList='1,2,3,4,5,7,8,9,11'
            ELSE IF @ATMFlag='1'                               SET @TransactionTypeList='1,2,3,4,5'
            ELSE IF @POSFlag='1'                               SET @TransactionTypeList='7,8,9,11'
          END
          ELSE                                                 SET @TransactionTypeList='1,2,3,4,5,7,8,9,10,11,12'
        END    

        IF @NetworkID NOT IN ('CUR','BCC')
        BEGIN
          SET @Action=NULL
          IF @CountryNumberCode=124
          BEGIN 
            SET @NetworkId0=NULL
            SELECT @NetworkId0=NetworkId,@BINGroup0=BINGroup FROM dbo.tbl_BINRange WHERE CountryNumberCode=124 AND BINVal=@BINVal AND PANLEN=@PANLEN
            IF @NetworkId0 IS NULL  SET @Action='Insert'

            IF @NetworkID='INT'       BEGIN SET @BINGroup=100  IF @NetworkId0 NOT IN ('INT')       SET @Action='Update' END
            ELSE IF @NetworkID='PUL'  BEGIN SET @BINGroup=101  IF @NetworkId0 NOT IN ('INT','PUL') SET @Action='Update' END
            ELSE IF @NetworkID='CUP'  BEGIN SET @BINGroup=102  IF @NetworkId0 NOT IN ('INT','CUP') SET @Action='Update' END
            ELSE IF @NetworkID='STR'  
            BEGIN 
              SET @BINGroup=11  IF @NetworkId0 NOT IN ('INT','PUL','CUP','STR') SET @Action='Update'
                
              IF @NetworkId0='PLS'      AND @BINGroup0=19  SET @BINGroup=23
              ELSE IF @NetworkId0='PLS' AND @BINGroup0=9   SET @BINGroup=13
              ELSE IF @NetworkId0='VIS' AND @BINGroup0=37  SET @BINGroup=24
              ELSE IF @NetworkId0='VIS' AND @BINGroup0=7   SET @BINGroup=14
              ELSE IF @NetworkId0='CRS' AND @BINGroup0=18  SET @BINGroup=21
            END
            ELSE IF @NetworkID='CRS' 
            BEGIN
              IF @FileName LIKE 'cirschg%'      BEGIN SET @BINGroup=18  IF @NetworkID0 NOT IN ('INT','PUL','CUP','STA','CRS') OR (@NetworkID0='CRS' AND @BINGroup0=28)  SET @Action='Update'  END
              ELSE IF @FileName LIKE 'cibinf%'  BEGIN SET @BINGroup=28  IF @NetworkID0 NOT IN ('INT','PUL','CUP','STA')                                                 SET @Action='Update'  END
            END    
            ELSE IF @NetworkID='PLS' 
            BEGIN 
              IF @FileName LIKE 'pluschg%'      BEGIN SET @BINGroup=19  IF @NetworkID0 NOT IN ('INT','PUL','CUP','STA','CRS','PLS') OR (@NetworkID0='PLS' AND @BINGroup0=9)  SET @Action='Update'  END
              ELSE IF @FileName LIKE 'plbinfl%' BEGIN SET @BINGroup=9   IF @NetworkID0 NOT IN ('INT','PUL','CUP','STA','CRS')                                                SET @Action='Update'  END
            END            
            ELSE IF @NetworkID='VIS' 
            BEGIN
              IF @CountryCode NOT IN ('248','020','040','056','100','830','196','203','208','233','234','246','250','276','292','300','304','831','336','348','352','372','833','376','380','832','428','438','440','442','470','492','528','578','616','620','642','703','705','724','752','756','792','826','249','254','474','238','312','638','674') 
                SET @BINGroup=37  
              ELSE
                SET @BINGroup=7
            END
            ELSE
              SET @BINGroup=18
          END
          ELSE IF @CountryNumberCode=840 AND NOT EXISTS(SELECT Id FROM dbo.tbl_BINRange WHERE CountryNumberCode=@CountryNumberCode AND BINVal=@BINVal AND PANLEN=@PANLEN AND NetworkID=@NetworkID)
          BEGIN
            SET @Action='Insert'

            SELECT @K=Id FROM @NetworkIDs WHERE NetworkID=@NetworkID
            DECLARE TempCursor1 CURSOR LOCAL FOR SELECT Id,NetworkId,TransactionTypeList FROM dbo.tbl_BINRange WHERE CountryNumberCode=@CountryNumberCode AND BINVal=@BINVal AND PANLEN=@PANLEN
            OPEN TempCursor1
            FETCH NEXT FROM TempCursor1 INTO @Id0,@NetworkId0,@TransactionTypeList0
            WHILE @@FETCH_STATUS=0
            BEGIN
              SELECT @N=Id FROM @NetworkIDs WHERE NetworkID=@NetworkID0
              IF @K<@N
              BEGIN
                EXEC dbo.usp_sys_RemoveString @TransactionTypeList0 OUTPUT,@TransactionTypeList
                UPDATE dbo.tbl_BINRange SET TransactionTypeList=@TransactionTypeList0 WHERE Id=@Id0
              END
              ELSE  
                EXEC dbo.usp_sys_RemoveString @TransactionTypeList OUTPUT,@TransactionTypeList0

              FETCH NEXT FROM TempCursor1 INTO @Id0,@NetworkId0,@TransactionTypeList0
            END
            CLOSE TempCursor1
            DEALLOCATE TempCursor1

            IF @NetworkID IN ('CRS','PLS') AND @CountryCode IN ('008','112','068','070','104','384','192','180','231','288','360','364','368','404','422','430','434','807','499','566','408','586','678','688','144','706','729','728','760','834','764','792','716')
              SET @BINGroup=666
            ELSE IF EXISTS(SELECT Id FROM dbo.tbl_BINRangeQuest WHERE BINVal=@BINVal AND PANLen=@PANLen)
              SET @BINGroup=32
            ELSE IF @NetworkID IN ('ILK')
              SET @BINGroup=15
            ELSE IF @NetworkID IN ('STA','STP')
              SET @BINGroup=11
            ELSE IF @NetworkID='CRS'
            BEGIN
              IF @CountryCode IN ('124')
                SET @BINGroup=218
              ELSE IF @CountryCode NOT IN ('840')  
                SET @BINGroup=18
            END    
            ELSE IF @NetworkID='PLS' 
            BEGIN
              IF @CountryCode IN ('248','020','040','056','100','830','196','203','208','233','234','246','250','276','292','300','304','831','336','348','352','372','833','376','380','832','428','438','440','442','470','492','528','578','616','620','642','703','705','724','752','756','792','826','249','254','474','238','312','638','674') 
                SET @BINGroup=19
              ELSE IF @CountryCode NOT IN ('840')  
                SET @BINGroup=219
            END    
            ELSE
              SET @BINGroup=10  
          END

          IF @Action='Insert'
            INSERT INTO dbo.tbl_BINRange(CountryNumberCode,BINVal,BINLen,PANLen,NetworkID,CountryCode,BaseCurrencyCode,BINGroup,CreditDebitFlag,TransactionTypeList)
            VALUES(@CountryNumberCode,@BINVal,@BINLen,@PANLen,@NetworkID,@CountryCode,@CountryCode,@BINGroup,@CreditDebitFlag,@TransactionTypeList)
          ELSE IF  @Action='Update' 
            UPDATE dbo.tbl_BINRange SET NetWorkID=@NetWorkID,BINGroup=@BINGroup WHERE CountryNumberCode=@CountryNumberCode AND BINVal=@BINVal AND PANLen=@PANLen
        END
      END  
      SET @j=@j+1  
    END  

    FETCH NEXT FROM TempCursor INTO @Line
    
    SET @i=@i+1
    IF @i>1000
    BEGIN
      COMMIT TRANSACTION
      BEGIN  TRANSACTION
      SET @i=1
    END
  END
  CLOSE TempCursor
  DEALLOCATE TempCursor
  COMMIT TRANSACTION
END
GO

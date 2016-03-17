SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_upm_Importv3Consumers] @MId NVARCHAR(50),@IsoId BIGINT
AS
    BEGIN
        SET NOCOUNT ON
        --OPEN SYMMETRIC KEY sk_EncryptionKey DECRYPTION BY CERTIFICATE ec_EncryptionCert
		-- change every year ---------
		OPEN SYMMETRIC KEY SymKey_SPS_20150825 DECRYPTION BY ASYMMETRIC KEY AsymKey_SPS_20150825 
        DECLARE @IdTable SourceTable
        INSERT  INTO @IdTable
                SELECT DISTINCT
                        ( CID )
                FROM    ecage..CONSUMER_MEMBERSHIP
                WHERE   MID = @MId
 
        DECLARE @CId BIGINT ,
            @RegionShortName NVARCHAR(10) ,
            @RegionId BIGINT ,
            @AddressId BIGINT ,
            @City NVARCHAR(20) ,
            @Address NVARCHAR(50) ,
            @PostalCode NVARCHAR(10) ,
            @Phone NVARCHAR(20) ,
            @CustomerId BIGINT,
			@DRIVERLICENSE varchar(30),
			@DRIVERLICENSESTATE CHAR(2)
 
        DECLARE TempCursor CURSOR LOCAL
        FOR
            SELECT  Id
            FROM    @IdTable
            ORDER BY Id
        OPEN TempCursor
        FETCH NEXT FROM TempCursor INTO @CId
        WHILE @@Fetch_Status = 0
            BEGIN 
			    
				SELECT @DRIVERLICENSE=DRIVERLICENSE,@DRIVERLICENSESTATE=DRIVERLICENSESTATE FROM ecage..CONSUMER WHERE CID=@CId

			    IF NOT EXISTS (SELECT Id FROM cps..tbl_Customer WHERE IdNumber=@DRIVERLICENSE AND IdState=@DRIVERLICENSESTATE)
				BEGIN
					SELECT  @RegionShortName = STATE ,
							@City = LEFT(CITY,20) ,
							@Address = STREETADDRESS ,
							@PostalCode = ZIP ,
							@Phone = TELEPHONE1
					FROM    ecage..CONSUMER
					WHERE   CID = @CId
					SELECT  @RegionId = Id
					FROM    dbo.tbl_Region
					WHERE   RegionShortName = @RegionShortName
					INSERT  INTO dbo.tbl_Address
							( RegionId ,
							  City ,
							  AddressLine1 ,
							  PostalCode ,
							  Telephone1 ,
							  UpdatedUserId
							)
					VALUES  ( @RegionId ,
							  @City ,
							  @Address ,
							  @PostalCode ,
							  @Phone ,
							  1
							)
					SELECT  @AddressId = IDENT_CURRENT('tbl_Address')

					INSERT  INTO cps..tbl_Customer
							( FirstName ,
							  LastName ,
							  MiddleInitial ,
							  Suffix ,
							  Birthday ,
							  Gender ,
							  SSN ,
							  CompanyName ,
							  IdNumber ,
							  IdType ,
							  IdState ,
							  IdExpiryDate ,
							  IdEntryMode ,
							  IdEntryCode ,
							  CreationDate ,
							  AddressId ,
							  UpdatedUserId
							)
							SELECT  FIRSTNAME ,
									LASTNAME ,
									MIDDLEINITIAL ,
									SUFFIX ,
									DOB ,
									GENDER ,
									ENCRYPTBYKEY(KEY_GUID('SymKey_SPS_20150825'), SSN) ,
									COMPANYNAME ,
									DRIVERLICENSE ,
									CASE WHEN DRIVERLICENSESTATE='PP' THEN 'PP' WHEN DRIVERLICENSESTATE='CZ' THEN 'MI' ELSE 'DL' END,
									DRIVERLICENSESTATE ,
									IDEXPDATE ,
									ID_ENTRY_MODE ,
									ID_ENTRY_CODE ,
									CREATIONDATE ,
									@AddressId ,
									1
							FROM    ecage.dbo.CONSUMER
							WHERE   CID = @CId
  
					SELECT  @CustomerId = IDENT_CURRENT('tbl_Customer')
 
					INSERT  INTO cps.dbo.tbl_CustomerMembership
							( IsoId ,
							  CustomerId ,
							  MembershipNumber ,
							  UpdatedUserId
							)
							SELECT  @IsoId ,
									@CustomerId ,
									MEMBERSHIP_NUM ,
									1
							FROM    ecage..CONSUMER_MEMBERSHIP
							WHERE   CID = @CId AND MID=@MId

				    INSERT INTO cps..tbl_CustomerOTB
				            ( CustomerId ,
				              MerchantId ,
				              TransactionClass ,
				              FullMICR ,
				              ActiveStatus ,
				              EnrollmentType ,
				              EnrollmentDate ,
				              UpdatedUserId
				            )
				            SELECT @CustomerId,@IsoId,'OTB','',CASE ACTIVE_FLAG WHEN 'Y'THEN 'A' ELSE '' END,'',CREATE_DATE,1 FROM ecage..CONSUMER_ACH 
							WHERE MID=@MId AND CID=@CId
				  END
				ELSE PRINT 'Customer IdNumber: '+@DRIVERLICENSE+' Customer Idstate: '+@DRIVERLICENSESTATE+' exists in V4 Customer table!'
                FETCH NEXT FROM TempCursor INTO @CId
            END
        CLOSE TempCursor
        DEALLOCATE TempCursor 

        --CLOSE SYMMETRIC KEY sk_EncryptionKey
		CLOSE SYMMETRIC KEY SymKey_SPS_20150825
    END


	---------------------
GO

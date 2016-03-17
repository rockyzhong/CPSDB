SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertCokeDevice]
	@MerchantId NVARCHAR(15),
	@TerminalName NVARCHAR(16),
	@SiteId NVARCHAR(8),
	@TermType SMALLINT,
	@TermSerno NVARCHAR(30),
	@Altcategory NVARCHAR(4),
	@Indicators INT
	AS
    BEGIN
	INSERT INTO dbo.tbl_DeviceCoke
	        ( MERCID,
	          TERMID ,
	          SITEID ,
	          TERMTYPE ,
	          TERMSERNO,
			  ALTCATEGORY,
			  INDICATORS
	        )
	VALUES  ( @MerchantId , -- Id - varchar(32)
	          @TerminalName , -- CurrKey - varchar(76)
	          @SiteId , -- PrevKey - varchar(76)
	          @TermType, -- CountUsed - smallint
	          @TermSerno,
			  @Altcategory,
			  3  -- UpatedDate - bigint
	        )
    END
GO

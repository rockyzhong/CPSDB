SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_InsertCokeDeviceIDP]
	@TerminalName NVARCHAR(16),
	@Tc NVARCHAR(8),
	@TTI NVARCHAR(10),
	@RetailerId NVARCHAR(20),
	@Retailgroup NVARCHAR(10),
	@Retailregion NVARCHAR(10)
	AS
    BEGIN
	INSERT INTO dbo.tbl_DeviceCokeIDP
	        ( TERMID ,
	          TC ,
	          TTI ,
	          RTLID ,
	          RTLGROUP ,
	          RTLRGN
	        )
	VALUES  ( @TerminalName , -- TERMID - char(16)
	          @Tc , -- TC - nvarchar(8)
	          @TTI , -- TTI - nvarchar(10)
	          @RetailerId , -- RTLID - nvarchar(20)
	          @Retailgroup , -- RTLGROUP - nvarchar(10)
	          @Retailregion  -- RTLRGN - nvarchar(10)
	        )
 
    END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_acq_GetDevicesKey]
	-- Add the parameters for the stored procedure here
	@paramTermID varchar(10) = NULL 
	AS
	
	IF @paramTermID is NULL
		select Id,TerminalName,ISNULL(MasterPinKeyCryptogram,''),ISNULL(MasterMacKeyCryptogram,''),ISNULL(WorkingPinKeyCryptogram,''),ISNULL(WorkingMacKeyCryptogram,'') 
		from tbl_device 
	ELSE
		select Id,TerminalName,ISNULL(MasterPinKeyCryptogram,''),ISNULL(MasterMacKeyCryptogram,''),ISNULL(WorkingPinKeyCryptogram,''),ISNULL(WorkingMacKeyCryptogram,'') 
		from tbl_device where TerminalName = @paramTermID 
GO

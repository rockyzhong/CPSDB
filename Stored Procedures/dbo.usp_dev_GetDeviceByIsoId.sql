SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_dev_GetDeviceByIsoId]
     @IsoId bigint   
WITH EXECUTE AS 'dbo'
AS
BEGIN
    SET NOCOUNT ON
    SELECT d.id Id,d.modelid ModelId,dm.Model DeviceModel,d.terminalname TerminalName from dbo.tbl_Device d left join dbo.tbl_DeviceModel dm on d.ModelId = dm.Id
    WHERE d.IsoId = @IsoId
END
GO

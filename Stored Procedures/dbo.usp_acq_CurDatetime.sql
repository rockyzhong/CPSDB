SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[usp_acq_CurDatetime]
AS
BEGIN
SELECT CONVERT(nvarchar,GETUTCDATE(),121) Date
END
GO

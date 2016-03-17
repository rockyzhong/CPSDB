SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_log_InsertEJHistory]
@DeviceId bigint,
@FileDate datetime,
@FileType bigint,
@FileData nvarchar(max),
@SmartAcquireId   bigint
AS
BEGIN
  SET NOCOUNT ON
  
  IF NOT EXISTS(SELECT * FROM dbo.tbl_EJHistory WHERE DeviceId=@DeviceId AND FileDate=@FileDate AND FileType=@FileType)
    INSERT INTO dbo.tbl_EJHistory(DeviceId,FileDate,FileType,FileData) VALUES(@DeviceId,@FileDate,@FileType,@FileData)
  ELSE
    UPDATE dbo.tbl_EJHistory SET FileData=FileData+@FileData WHERE DeviceId=@DeviceId AND FileDate=@FileDate AND FileType=@FileType

  
  RETURN 0
END

GO
GRANT EXECUTE ON  [dbo].[usp_log_InsertEJHistory] TO [WebV4Role]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/**/
/**/
/**/
CREATE PROCEDURE [dbo].[usp_dev_InsertDeviceMasterKey]
@pId bigint,
@pCryptogram nvarchar(200),
@pCheckDigits nvarchar(200)
AS
BEGIN
-- Revision 1.0.0 2012.02.06 by Adam Glover
--   Initial Revision
INSERT INTO tbl_DeviceKeyMaster
(
  Id, DeviceID, KeyClass, KeySequence,
  Cryptogram, CheckDigits, AssignedDate, DeactivatedDate,
  UpdatedUserID
)
VALUES
(
  @pId, NULL, NULL, NULL,
  @pCryptogram, @pCheckDigits, NULL, NULL,
  NULL 
)
END
GO
GRANT EXECUTE ON  [dbo].[usp_dev_InsertDeviceMasterKey] TO [WebV4Role]
GO

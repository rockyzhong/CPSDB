SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_SetNetworkExtendedValues]
@NetworkId             bigint,
@ExtendedColumnType1   bigint,
@ExtendedColumnValue1  nvarchar(200),
@ExtendedColumnType2   bigint,
@ExtendedColumnValue2  nvarchar(200),
@ExtendedColumnType3   bigint,
@ExtendedColumnValue3  nvarchar(200),
@ExtendedColumnType4   bigint,
@ExtendedColumnValue4  nvarchar(200),
@ExtendedColumnType5   bigint,
@ExtendedColumnValue5  nvarchar(200),
@UpdatedUserId         bigint
AS
BEGIN
  SET NOCOUNT ON

  IF @ExtendedColumnType1 IS NOT NULL
    EXEC dbo.usp_net_SetNetworkExtendedValue @NetworkId,@ExtendedColumnType1,@ExtendedColumnValue1,@UpdatedUserId
  IF @ExtendedColumnType2 IS NOT NULL
    EXEC dbo.usp_net_SetNetworkExtendedValue @NetworkId,@ExtendedColumnType2,@ExtendedColumnValue2,@UpdatedUserId
  IF @ExtendedColumnType3 IS NOT NULL
    EXEC dbo.usp_net_SetNetworkExtendedValue @NetworkId,@ExtendedColumnType3,@ExtendedColumnValue3,@UpdatedUserId
  IF @ExtendedColumnType4 IS NOT NULL
    EXEC dbo.usp_net_SetNetworkExtendedValue @NetworkId,@ExtendedColumnType4,@ExtendedColumnValue4,@UpdatedUserId
  IF @ExtendedColumnType5 IS NOT NULL
    EXEC dbo.usp_net_SetNetworkExtendedValue @NetworkId,@ExtendedColumnType5,@ExtendedColumnValue5,@UpdatedUserId

  RETURN 0
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_SetNetworkExtendedValues] TO [WebV4Role]
GO

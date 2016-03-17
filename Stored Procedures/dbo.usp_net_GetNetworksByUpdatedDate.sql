SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_net_GetNetworksByUpdatedDate]
@NetworkName    nvarchar(50) = NULL,
@Date         datetime = NULL
WITH EXECUTE AS 'dbo'
AS
BEGIN
  DECLARE @SQL nvarchar(4000)
  SET @SQL='
  SELECT n.Id NetworkId,n.NetworkName,n.Currency,n.Description
  FROM dbo.tbl_Network n 
  WHERE 1>0'
  IF @Date      IS NOT NULL  SET @SQL=@SQL+' AND n.UpdatedDate>@Date'
  IF @NetworkName IS NOT NULL  SET @SQL=@SQL+' AND n.NetworkName=@NetworkName'
  
  SET @SQL=@SQL+'
  SELECT e.NetworkId,n.NetworkName,e.ExtendedColumnType,e.ExtendedColumnValue
  FROM dbo.tbl_NetworkExtendedValue e
  JOIN dbo.tbl_Network n ON e.NetworkId=n.Id
  WHERE 1>0'
  IF @Date      IS NOT NULL  SET @SQL=@SQL+' AND n.UpdatedDate>@Date'
  IF @NetworkName IS NOT NULL  SET @SQL=@SQL+' AND n.NetworkName=@NetworkName'

  SET @SQL=@SQL+'
  SELECT c.NetworkId,n.NetworkName ,c.FromCurrency,c.ToCurrency,c.ExchangeRate 
  FROM dbo.tbl_NetworkCurrencyExchangeRate c
  JOIN dbo.tbl_Network n ON c.NetworkId=n.Id AND c.ToCurrency=n.Currency 
  WHERE 1>0'
  IF @Date      IS NOT NULL  SET @SQL=@SQL+' AND n.UpdatedDate>@Date'
  IF @NetworkName IS NOT NULL  SET @SQL=@SQL+' AND n.NetworkName=@NetworkName'
  
  SET @SQL=@SQL+'
  SELECT CONVERT(nvarchar,GETUTCDATE(),121) Date'
  
  EXEC sp_executesql @SQL,N'@NetworkName nvarchar(50),@Date datetime',@NetworkName,@Date
  
    -- Add update command for Smart Acquirer ID 
   --INSERT INTO tbl_DeviceUpdateCommands
   --SELECT @SmartAcquierId, GETUTCDATE(), 'Sptermapp\GetNetworksByUpdatedDate!'
 
END
GO
GRANT EXECUTE ON  [dbo].[usp_net_GetNetworksByUpdatedDate] TO [WebV4Role]
GO

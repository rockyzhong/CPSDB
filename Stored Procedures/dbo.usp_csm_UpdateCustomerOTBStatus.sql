SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE PROCEDURE [dbo].[usp_csm_UpdateCustomerOTBStatus]
@CustomerId       bigint,
@MerchantId       nvarchar(50),
@TransactionClass nvarchar(50),
@FullMICR         nvarchar(25),
@ActiveStatus     nvarchar(1),
@UpdatedUserId    bigint
AS
BEGIN
  SET NOCOUNT ON
 
  UPDATE dbo.tbl_CustomerOTB 
  SET ActiveStatus=@ActiveStatus,UpdatedUserId=@UpdatedUserId 
  WHERE CustomerId=@CustomerId
  AND TransactionClass=@TransactionClass 
  AND CASE WHEN (SELECT CHARINDEX('|',FullMICR))=0 THEN FullMICR ELSE LEFT(FullMICR,CHARINDEX('|',FullMICR)-1) END=@FullMICR
END
GO

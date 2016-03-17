SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_bin_UpdateBINRanges]
AS 
BEGIN
  SET NOCOUNT ON
  DECLARE @Id bigint,@TransactionTypeMask bigint,@TransactionTypeList nvarchar(200)
  DECLARE TempCursor CURSOR LOCAL FOR SELECT Id,TransactionTypeMask FROM dbo.tbl_BinRange
  OPEN TempCursor
  FETCH NEXT FROM TempCursor INTO @Id,@TransactionTypeMask
  WHILE @@Fetch_Status=0
  BEGIN
    SET @TransactionTypeList=''
  
    IF @TransactionTypeMask & 0x00000020 <> 0   SET @TransactionTypeList=@TransactionTypeList+',1'  -- ATM withdrawal
    IF @TransactionTypeMask & 0x00000040 <> 0   SET @TransactionTypeList=@TransactionTypeList+',2'  -- Balance inquiry
    IF @TransactionTypeMask & 0x00000100 <> 0   SET @TransactionTypeList=@TransactionTypeList+',3'  -- Funds transfer
    IF @TransactionTypeMask & 0x00000080 <> 0   SET @TransactionTypeList=@TransactionTypeList+',4'  -- Funds deposit
    IF @TransactionTypeMask & 0x00000400 <> 0   SET @TransactionTypeList=@TransactionTypeList+',5'  -- ATM statement print request
    IF @TransactionTypeMask & 0x00000200 <> 0   SET @TransactionTypeList=@TransactionTypeList+',6'  -- Account information request
    IF @TransactionTypeMask & 0x00001000 <> 0   SET @TransactionTypeList=@TransactionTypeList+',7'  -- ATM/POS purchase
    IF @TransactionTypeMask & 0x00010000 <> 0   SET @TransactionTypeList=@TransactionTypeList+',8'  -- Pre-Authorization request
    IF @TransactionTypeMask & 0x00020000 <> 0   SET @TransactionTypeList=@TransactionTypeList+',9'  -- Pre-Authorization completion
    IF @TransactionTypeMask & 0x00002000 <> 0   SET @TransactionTypeList=@TransactionTypeList+',10' -- POS merchandise return
    IF @TransactionTypeMask & 0x00004000 <> 0   SET @TransactionTypeList=@TransactionTypeList+',11' -- POS cancel sale
    IF @TransactionTypeMask & 0x00008000 <> 0   SET @TransactionTypeList=@TransactionTypeList+',12' -- POS cancel return
    
    IF @TransactionTypeList=''
      SET @TransactionTypeList=NULL
    ELSE
      SET @TransactionTypeList=SUBSTRING(@TransactionTypeList,2,LEN(@TransactionTypeList)-1)
    
    UPDATE dbo.tbl_BINRange SET TransactionTypeList=@TransactionTypeList WHERE Id=@Id
          
    FETCH NEXT FROM TempCursor INTO @Id,@TransactionTypeMask
  END
  CLOSE TempCursor
  DEALLOCATE TempCursor
END
GO

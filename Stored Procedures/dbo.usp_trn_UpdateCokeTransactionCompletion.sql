SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
   CREATE PROCEDURE [dbo].[usp_trn_UpdateCokeTransactionCompletion]
	@MERCID NVARCHAR(15),
	@TERMID NVARCHAR(16),
	@TRANSEQ NVARCHAR(12),
	@MODIFYDATE INT,
	@MODIFYID NVARCHAR(10)
	AS
    BEGIN
	UPDATE dbo.tbl_trn_TransactionCoke SET MODIFYDATE=@MODIFYDATE,MODIFYID=@MODIFYID,TRANVOID='C'
	WHERE MERCID=@MERCID AND TERMID=@TERMID AND TRANSEQ=@TRANSEQ
    END
GO

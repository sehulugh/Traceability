USE [EMS.Common]
GO
/****** Object:  StoredProcedure [dbo].[SaveLogsToAppLoggingDetails]    Script Date: 2021-01-04 11:35:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Sesugh Hulugh>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SaveLogsToAppLoggingDetails]
 
AS
BEGIN
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ID AS nvarchar(MAX)
	DECLARE @action AS int

	DECLARE Log_Cursor CURSOR FOR 
    -- Insert statements for procedure here
	SELECT [ID], [Action] 
	FROM [dbo].[AppTransactionLogs]
	WHERE Active = 1 -- Only Updates yet to be saved in AppLoggingDetails
	--AND Action = 3; -- Only Updates


	OPEN Log_Cursor
	FETCH NEXT FROM Log_Cursor INTO @ID, @action; 
	WHILE @@FETCH_STATUS = 0  
    BEGIN TRY

	IF (@action = 3) -- if action = update
			--INSERT INTO AppLoggingDetails
			INSERT INTO [dbo].[AppLoggingDetails] ([TransactionDate], [UserName], [Action], [ModelObject], [KeyName], [KeyValue], [KeyName1], [KeyValue1], [ValueName1]
					, [PropertyName], [OldValue], [NewValue], [AppTransactionLogId], [CreateDate]) 
	    	 	  
			SELECT * FROM dbo.[LogChangeDetails] (@ID) 
	ELSE
			--INSERT INTO AppLoggingDetails
			INSERT INTO [dbo].[AppLoggingDetails] ([TransactionDate], [UserName], [Action], [ModelObject], [KeyName], [KeyValue], [KeyName1], [KeyValue1], [ValueName1]
					, [PropertyName], [OldValue], [NewValue], [AppTransactionLogId], [CreateDate]) 
	    	 	  
			SELECT * FROM dbo.[LogChangeDetails_Insert] (@ID) 
		

	-- UPDATE SAVED RECORD SO THE SP IGNORES IT NEXT TIME IT RUNS
	UPDATE [dbo].[AppTransactionLogs] SET Active = 0 WHERE ID = @ID;


      FETCH NEXT FROM Log_Cursor INTO @ID, @action;  
	END TRY
	BEGIN CATCH

		PRINT 'Error in Procedure [dbo].[SaveLogsToAppLoggingDetails]';
		THROW;

	END CATCH;
	 
	CLOSE Log_Cursor;  
	DEALLOCATE Log_Cursor;
	

END

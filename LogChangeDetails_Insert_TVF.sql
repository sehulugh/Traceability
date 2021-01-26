USE [EMS.Common]
GO
/****** Object:  UserDefinedFunction [dbo].[LogChangeDetails_Insert]    Script Date: 2021-01-05 1:30:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

ALTER FUNCTION [dbo].[LogChangeDetails_Insert] (@ID NVARCHAR(MAX) )

RETURNS TABLE 
AS

RETURN


---DECLARE @ID nvarchar(MAX) = '09EEAD20-CD6C-4085-B28F-AFF710F08FBF';--'4FE52918-188D-4DFC-971E-194A8F26D9C6';'AF8505D8-151E-4AFA-8643-B0F6F1A452B5'; 


WITH TableOfChanges AS
(
--------------------------------------------- Used the Case to check and Return Key and Values for COmposite Keys if they exists ---------------------------------------------

	SELECT TransactionDate, UserName, Action, ModelName 

	  , SUBSTRING(ModelKeysAndValues, 3, CHARINDEX(':', ModelKeysAndValues) - 3) AS  KeyName -- works for composite and non composite key

	  , CASE lEN(ModelKeysAndValues) - LEN(REPLACE(ModelKeysAndValues,':','')) -- If there is 1 Colon in the string
		  WHEN 1 THEN
		  SUBSTRING(ModelKeysAndValues, CHARINDEX(':', ModelKeysAndValues) + 1, LEN(ModelKeysAndValues) - CHARINDEX(':', ModelKeysAndValues) -2) 
		  ELSE 
		 /* -- KeyValue -- only for composite case
		  1. StartPosition =  From the first ':' + 1 to exclude the colon
		  2. Length = (Position of comma -1 to exclude the comma) - Position of the First colon
		  */
		  SUBSTRING(ModelKeysAndValues, CHARINDEX(':', ModelKeysAndValues) + 1, (CHARINDEX(',', ModelKeysAndValues) - 1) - CHARINDEX(':', ModelKeysAndValues) ) -- only for composite case
		  END
		  AS KeyValue

	  , CASE lEN(ModelKeysAndValues) - LEN(REPLACE(ModelKeysAndValues,':','')) -- If there is 1 Colon in the string
			WHEN 1 THEN NULL ELSE
		
		 /* -- KeyName1 -- only for composite case
		  1. StartPosition =  From the ',' + 1 to exclude the comma
		  2. Length = Position of the Second colon - Position of the comma
		  */	
		 SUBSTRING(ModelKeysAndValues, CHARINDEX(',', ModelKeysAndValues) + 1, CHARINDEX(':',ModelKeysAndValues, CHARINDEX(':',ModelKeysAndValues) + 1) - (CHARINDEX(',', ModelKeysAndValues) + 1)) 
		 END
		 AS KeyName1

	  , CASE lEN(ModelKeysAndValues) - LEN(REPLACE(ModelKeysAndValues,':','')) -- If there is 1 Colon in the string
			WHEN 1 THEN NULL ELSE
		 /* -- KeyValue1 -- only for composite case
		  1. StartPosition =  From the second '1' + 1 to exclude the colon
		  2. Length = Lenght of all charcters - (Position of the second colon + 2 to exclude ' }')
		  */	
		 SUBSTRING(ModelKeysAndValues, CHARINDEX(':',ModelKeysAndValues, CHARINDEX(':',ModelKeysAndValues) + 1) + 1, LEN(ModelKeysAndValues) - (CHARINDEX(':',ModelKeysAndValues, CHARINDEX(':',ModelKeysAndValues) + 1) +2)) 
		 END
		 AS KeyValue1

	,  NULL AS PropertyID, NULL AS OldValue, NULL AS NewValueName, ID AS AppTransactionLogId, GETDATE() AS CreateDate

	FROM [dbo].[AppTransactionLogs]
	WHERE ID = @ID
)


---------------------------------------- Finallyjoining Joining [vRelatedKeys] View to get Prent from Children eg VendorId for ContactId changes -----------------------
 SELECT TransactionDate, UserName, Action, ModelName, COALESCE(rk.ParentKeyName, REPLACE(KeyName, 'IngredientProfileId', 'MaterialId')) AS KeyName, COALESCE(rk.ParentKeyValue,KeyValue) AS KeyValue
 , COALESCE(rk.ChildKeyName,KeyName1) AS KeyName1, COALESCE(rk.ChildKeyValue,KeyValue1) AS KeyValue1, COALESCE(rk.ChildValueName,ValueName1) AS ValueName1
 , PropertyID, OldValue, NewValueName, AppTransactionLogId, CreateDate
  
 FROM(

		----------------------------------------------- joining [vMetaDataTables] View just to get ValueName1 ------------------------------------------------------------------
		SELECT TransactionDate, UserName, Action, ModelName, REPLACE(tc.KeyName, 'IngredientProfileId', 'MaterialId') AS KeyName -- IngredientProfileId in VendorIngredients Table
		, tc.KeyValue, KeyName1,KeyValue1,m.ValueName AS ValueName1, PropertyID, OldValue, NewValueName, AppTransactionLogId, CreateDate
		FROM TableOfChanges tc
		LEFT JOIN [EMS.Common].[dbo].[vMetaDataTables] m
		ON tc.KeyName1 = m.KeyName AND tc.KeyValue1 = m.KeyValue
		) AS toc

 LEFT JOIN [dbo].[vRelatedKeys] rk
 ON toc.KeyName = rk.ChildKeyName AND toc.KeyValue = rk.ChildKeyValue
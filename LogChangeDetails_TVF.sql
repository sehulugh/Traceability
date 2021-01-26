USE [EMS.Common]
GO
/****** Object:  UserDefinedFunction [dbo].[LogChangeDetails]    Script Date: 2021-01-05 11:37:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/

ALTER FUNCTION [dbo].[LogChangeDetails] (@ID NVARCHAR(MAX) )

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

	,  ColumnName AS PropertyID, OldValueName AS OldValue, NewValueName, t.ID AS AppTransactionLogId, GETDATE() AS CreateDate

	FROM(


	/*
	EXPLANATION FOR THE SELECT LINE
	1.	Used ISNULL to fill in the column Names Where they dont have to join to a MataData Table
	2.	Used the CAST for ColumnName because the view returns string length for the Longest object Name 
		thereby truncating longer columns from non metadata columns

	*/
------------------------------------------------------------ JOIN [MetaDataTables] to get the keyname of Composite key tables -------------------------------------------------------
		SELECT @ID AS ID, ISNULL(CAST(mn.ObjectName AS nvarchar(100)), kv.OldKey) AS ColumnName,  ISNULL(mn.ValueName, NewValue) AS 'NewValueName',  ISNULL(mo.ValueName, OldValue) AS 'OldValueName'
			FROM
			(
			------------------------------------- Get Properties that have changed -------------------------------------------------------------
				--NEW DATA From ChangeFields Column
				SELECT [key] AS NewKey, [value] AS NewValue, OldKey, OldValue 
				FROM OPENJSON((
								SELECT REPLACE(ChangedFields,'*','') 
								FROM [dbo].[AppTransactionLogs] WHERE ID = @ID
								)) AS n
				JOIN (
				--OLD DATA from RecordBeforeChanges Column
				SELECT [key] AS OldKey, [value] AS OldValue 
				FROM OPENJSON((
								SELECT RecordBeforeChanges
								FROM [dbo].[AppTransactionLogs] WHERE ID = @ID
								))
								) AS o
				ON n.[key] = o.OldKey
				-- Return only records with different values adn Use the UDF to remove trailing zeros
				WHERE dbo.removeTrailingZeros([value]) <> dbo.removeTrailingZeros(OldValue)   
				-- All columns we want to exclude form the comparison
				AND [OldKey] NOT IN ('ModifiedDate','ModifiedBy', 'ComputerName', 'ComputerIp','ShipTo')
			) AS kv
		
		
		--Join MetaDataTable to get New Valu Names
		LEFT JOIN [DEV_EMS.Common].[dbo].[vMetaDataTables] mn

		ON  kv.NewKey COLLATE DATABASE_DEFAULT = mn.KeyName COLLATE DATABASE_DEFAULT AND kv.NewValue = CAST(mn.KeyValue AS nvarchar(250)) 
		-- Join MetaDataTable to get Old Value Names
		LEFT JOIN [EMS.Common].[dbo].[vMetaDataTables] mo

		ON  kv.OldKey COLLATE DATABASE_DEFAULT = mo.KeyName COLLATE DATABASE_DEFAULT AND kv.OldValue = CAST(mo.KeyValue AS nvarchar(250)) 
	

	) AS t 

	JOIN [dbo].[AppTransactionLogs] l
	ON t.ID = l.ID
)


---------------------------------------- Finallyjoining Joining [vRelatedKeys] View to get Prent from Children eg VendorId for ContactId changes -----------------------
 SELECT TransactionDate, UserName, Action, ModelName, COALESCE(rk.ParentKeyName, KeyName) AS KeyName, COALESCE(rk.ParentKeyValue,KeyValue) AS KeyValue
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
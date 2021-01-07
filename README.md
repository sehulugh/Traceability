# **EMS Traceability Docs**

The EMS Traceability functionality captures  **create**  and  **update** actions in the EMS System and displays this information in a user friendly manner.

![]()

Before every insert/update by EntityframeworkCore, data is captured and saved in a database table (AppTransactionLogs) in json format. The table below shows a summary of the database objects used to transform and save the data (in AppLoggingDetails).

**Database:** [EMS.Common]

| **Object Name** | **Object Type** |
| --- | --- |
| AppTransactionLogs | Table |
| AppLoggingDetails | Table |
| vMetaDataTables | View |
| vRelatedKeys | View |
| removeTrailingZeros | Scalar-valued Function |
| LogChangeDetails | Table-valued Function |
| LogChangeDetails\_Insert | Table-valued Function |
| SaveLogsToAppLoggingDetails | Stored Procedure |
| ProcessLogs | SQL Server Agent Job |
| AppLoggingDetails.cs| C sharp Object

## **AppTransactionLogs**

Table holds raw data of every insert/update which is eventually transformed and saved in AppLoggingDetails table.

| **Column Name** | **Description** |
| --- | --- |
| TransactionId | Identity Column and PrimaryKey Column |
| UserName | User who performed action |
| TransactionDate | Action datetime |
| Action | Action type: 4= Insert, 3 = update |
| ModelName | Object Name |
| RecordBeforeChanges | Json string containing record before change / inserted record |
| Active | Boolean value, updated to false when record is processed |
| ComputerName | 
| ComputerIP | 
| ModelKeysAndValues | Json string containing the Models; key property name(s) and value(s). two for composite key tables |
| ChangedFields | Json string containing only fields that have changed, null for inserts |
| ID | Unique GUID for every record |

## **AppLoggingDetails**

Table that holds the processed records showing old and new values of changed fields in separate columns

| **Column Name** | **Description** |
| --- | --- |
| LogId | Identity Column and PrimaryKey Column |
| TransactionDate | Action datetime |
| UserName | User who performed action |
| Action | Action type: 4= Insert, 3 = update |
| ModelObject | Object Name |
| KeyName | Primarykey property Name |
| KeyValue | Primary Key value |
| KeyName1 | Primarykey property Name for composite keys/ join tables eg _ **FactoryId** _ |
| KeyValue1 | PrimaryKey value for composite keys/ join tables eg _ **1** _ |
| ValueName1 | Display name for KeyValue1 eg _ **Fiera Foods** _ |
| PropertyName | Name of filed that has changed |
| OldValue | Old value, null for inserts |
| NewValue | New value, null for inserts |
| AppTransactionLogId | References ID column in AppTransactionLogs Table |
| CreateDate | Datetime record was inserted |

## **vMetadataTables**

A View that holds the key and values for all metadata tables used in the application, typically found in dropdowns

_N/B: script should be updated when new Metadata table is added to the DB_

 **Script**
```sql
SELECT        'Allergen' AS ObjectName, 'AllergenId' AS KeyName, AllergenId AS KeyValue, Name COLLATE SQL_Latin1_General_CP1_CI_AS AS ValueName
FROM            dbo.Allergens
UNION
SELECT        'ASRSVelocity', 'AsrsVelocityId' AS Expr1, AsrsVelocityId, Title
FROM            dbo.ASRSVelocity
UNION
SELECT        'CHEPPickupLocation', 'CHEPPickupLocId' AS Expr1, CHEPPickupLocId, Name
FROM            dbo.CHEPPickupLocation
UNION
SELECT        'ContactType', 'ContactTypeId' AS Expr1, ContactTypeId, ContactTypeName
FROM            dbo.ContactType
UNION
SELECT        'Currency', 'CurrencyId' AS Expr1, CurrencyId, Name
FROM            dbo.Currency
UNION
SELECT        'DocumentType', 'DocumentTypeId' AS Expr1, DocumentTypeId, DocumentName
FROM            dbo.DocumentType
UNION
SELECT        'Factories', 'FactoryId' AS Expr1, FactoryId, Name
FROM            dbo.Factories
UNION
SELECT        'GMOStatus', 'GmoStatusId' AS Expr1, GmoStatusId, Name
FROM            dbo.GMOStatus
UNION
SELECT        'IngredientClass', 'IngredientClassId' AS Expr1, IngredientClassId, Name
FROM            dbo.IngredientClasses
UNION
SELECT        'IngredientSubClass', 'IngredientSubClassId' AS Expr1, IngredientSubClassId, Name
FROM            dbo.IngredientSubClasses
UNION
SELECT        'IngredientSubType', 'IngredientSubTypeId' AS Expr1, IngredientSubTypeId, Name
FROM            dbo.IngredientSubTypes
UNION
SELECT        'IngredientType', 'IngredientTypeId' AS Expr1, IngredientTypeId, Name
FROM            dbo.IngredientTypes
UNION
SELECT        'ItemCategory', 'ItemCategoryId' AS Expr1, ItemCategoryId, Description
FROM            dbo.ItemCategory
UNION
SELECT        'ItemClaim', 'ItemClaimsId' AS Expr1, ItemClaimsId, Name
FROM            dbo.ItemClaims
UNION
SELECT        'ItemFormat', 'ItemFormatId' AS Expr1, ItemFormatId, Title
FROM            dbo.ItemFormats
UNION
SELECT        'ItemState', 'ItemStateId' AS Expr1, ItemStateId, Name
FROM            dbo.ItemState
UNION
SELECT        'ItemSubType', 'ItemSubTypeId' AS Expr1, ItemSubTypeId, Name
FROM            dbo.ItemSubTypes
UNION
SELECT        'ItemType', 'ItemTypeId' AS Expr1, ItemTypeId, Name
FROM            dbo.ItemTypes
UNION
SELECT        'MaterialType', 'MaterialTypeId' AS Expr1, MaterialTypeId, Title
FROM            dbo.MaterialTypes
UNION
SELECT        'Case', 'PackagingTypeId' AS Expr1, PackagingTypeId, Name
FROM            dbo.PackagingTypes
UNION
SELECT        'ReceiveStatus', 'ReceiveStatusId' AS Expr1, ReceiveStatusId, Description
FROM            dbo.ReceiveStatus
UNION
SELECT        'RecipeIngredientType', 'RecipeIngredientTypeId' AS Expr1, RecipeIngredientTypeId, Name
FROM            dbo.RecipeIngredientTypes
UNION
SELECT        'RecipeType', 'RecipeTypeId' AS Expr1, RecipeTypeId, Name
FROM            dbo.RecipeTypes
UNION
SELECT        'SliceType', 'SliceTypeId' AS Expr1, SliceTypeId, Title
FROM            dbo.SliceTypes
UNION
SELECT        'StorageType', 'StorageTypeId' AS Expr1, StorageTypeId, Description
FROM            dbo.StorageTypes
UNION
SELECT        'UnitOfMeasure', 'UomId' AS Expr1, UomId, Name
FROM            dbo.UOM
UNION
SELECT        'PieceWeightUOM', 'PieceWeightUOM' AS Expr1, UomId, Name
FROM            dbo.UOM
UNION
SELECT        'EntityOfMeasure', 'EntityUomId' AS Expr1, UomId, Name
FROM            dbo.UOM
UNION
SELECT        'IngredientOfMeasure', 'IngredeintUomId' AS Expr1, UomId, Name
FROM            dbo.UOM
UNION
SELECT        'VendorClassification', 'VendorClassificationId' AS Expr1, VendorClassificationId, Color
FROM            dbo.VendorClassification
UNION
SELECT        'WarehouseType', 'WarehouseTypeId' AS Expr1, WarehouseTypeId, Description
FROM            dbo.WarehouseTypes
UNION
SELECT        'Warehouse', 'WarehouseId' AS Expr1, WarehouseId, Name
FROM            dbo.Warehouses
UNION
SELECT        'PurchaseOrderTerms', 'PurchaseOrderTermsId' AS Expr1, PurchaseOrderTermsId, Description
FROM            dbo.PurchaseOrderTerms
UNION
SELECT        'PurchaseOrderCancel', 'PurchaseOrderCancelId' AS Expr1, PurchaseOrderCancelId, Description
FROM            dbo.PurchaseOrderCancel
UNION
SELECT        'PurchaseOrderStatus', 'PurchaseOrderStatusId' AS Expr1, PurchaseOrderStatusId, Name
FROM            dbo.PurchaseOrderStatus
```

| **Column Name** | **Description** |
| --- | --- |
| ObjectName | Eg _ **Factory** _ |
| KeyName | Eg _ **FactoryId** _ |
| KeyValue | Eg _ **1** _ |
| ValueName | Eg _ **Fiera Foods** _ |

## **vRelatedKeys**

A View that holds related objects/tables and their related keys in a one-to-many relationship

_N/B: script should be updated when new related tables are added to the DB_

**Script**
```sql
SELECT        'ContactId' AS ChildKeyName, ContactId AS ChildKeyValue, ContactName AS ChildValueName, 'VendorId' AS ParentKeyName, VendorId AS ParentKeyValue
FROM            dbo.Contacts
UNION
SELECT        'VendorNoteId' AS ChildKeyName, VendorNoteId AS ChildKeyValue, Note AS ChildValueName, 'VendorId' AS ParentKeyName, VendorId AS ParentKeyValue
FROM            [dbo].[VendorNotes]
```

| **Column Name** | **Description** |
| --- | --- |
| ChildKeyName | Eg _ **ContactId** _ |
| ChileKeyValue | Eg _ **4** _ |
| ChildValueName | Eg _ **Sesugh Hulugh** _ |
| ParentKeyName | Eg _ **VendorId** _ |
| ParentKeyValue | Eg _ **1** _ |

## **removeTrailingZeros**

This scalar valued function s a recursive function that takes in a string and removes trailing zeros, this will help us compare decimal values eg 12.00 == 12, 12.340 == 12.34

The below pseudocode explains the steps taken:

(1) If input contains &#39;.&#39; GOTO (2) ELSE GOTO (4)

(2) If last character is &#39;0&#39; THEN remove &#39;0&#39; AND GOTO (1) ELSE GOTO (3)

(3) If lastCharacter is &#39;.&#39; THEN remove &#39;.&#39; AND GOTO (4)

(4) RETURN input

**Script**
```sql
USE [EMS.Common]
GO
/****** Object:  UserDefinedFunction [dbo].[removeTrailingZeros]    Script Date: 2021-01-04 11:32:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, Sesugh Hulugh>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[removeTrailingZeros](@input NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)
AS
BEGIN
	--(1)
IF (CHARINDEX('.', @input) > 0)
		--(2)
        IF (SUBSTRING(@input, LEN(@input), LEN(@input)) = '0')
			SET @input = dbo.removeTrailingZeros(SUBSTRING(@input, 1,LEN(@input) -1)) --recursion
		--(3)
		ELSE IF (SUBSTRING(@input, LEN(@input), LEN(@input)) = '.')
			SET @input = SUBSTRING(@input, 1,LEN(@input) -1)
		
ELSE
		SET @input = @input
--(4)
RETURN @input

--PSEUDOCODE
--(1) If input contains '.' GOTO (2) ELSE GOTO (4)
--(2) If last character is '0' THEN remove '0' AND GOTO (1) ELSE GOTO (3)
--(3) If lastCharacter is '.' THEN remove '.' AND GOTO (4)
--(4) RETURN input
	
END
```

## **LogChangeDetails**

This TVF accepts ID from AppTransactionLogs Table, takes in the data and returns a table with the same structure as AppLoggingDetails.

It is called to transform updated records (where Action = 3)

The function does the following:

1. SELECT and transpose the json Data from _**ChangeFields (n)**_ and _**RecordBeforeChanges (o)**_ columns in _ **AppransactionLogs** _ table using the OPENJSON function
2. The OPENJSON function returns two columns (Key and Value)
3. JOIN o and n on o.key = n.key WHERE **dbo****. ****removeTrailingZeros**** (****[o.value]****) ****and**  **dbo****. ****removeTrailingZeros**** ( ****n.value**** )**. The resulting table will hold only values that have changed.
4. JOIN the resulting table from 3. With **vMetaDataTables** view to get both old and new value Names, also add input _ **ID** _ as a column in resulting table
5. JOIN the result in 4. with **AppTransactionLogs** to get the _ **transactionDate, UseraName, Action, ModelName** _ _and__model_ _**Key(s) and KeyValue(s)**_ (from substringing ModelKeyValues)
6. Again, JOIN resulting table from 5. with **vMetaDataTables** to get the _ **ValueNames** _ of _ **KeyValues** _ in 5 where exists
7. Finally JOIN resulting table in 6. above with **vRelatedKeys** in order to get _ **ParentKey** _ and _ **ParentValue** _ for keys that are children. Eg if key is _ **ContactId** _, it is a child to _ **VendorId** _ so we need to relate it to it&#39;s _ **VendorId** _
8. Return resulting table

**Script**
```sql
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
```

## **LogChangeDetails\_Insert**

This TVF accepts ID from AppTransactionLogs Table, takes in the data and returns a table with the same structure as AppLoggingDetails.

It is called to transform inserted records (where Action = 4)

The query is similar to **LogChangeDetails** that of only in this case we do not need to compare old and new values, so it starts from 5.

**Script**
```sql
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
```

## **SaveLogsToAppLoggingDetails**

This stored Procedure implements a cursor that checks the **AppTransactionLogs** table for any yet to be processed record (Active =1), processes the record, saves it into **AppLoggingDetails** table and updates the status to Active = 0.

The Stored Procedure does the following:

1. Declare variables @ID and @action
2. Declare a cursor and select ID and Action where Active = 1 from **AppTransactionLogs**
3. If @action = 3, pass @ID to the TVF **LogChangeDetails** and insert resulting table into **AppLoggingDetails**
4. If @action = 4, pass @ID to the TVF **LogChangeDetails\_Insert** and insert resulting table into **AppLoggingDetails**
5. Update Active to 0 in where ID = @ID in **AppTransactionLogs**

**Script**
```sql
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

```

## **ProcessLogs** 

This SQL Server agent Job executes the **SaveLogsToAppLoggingDetails** Stored procedure every 15mins

**Script**
```sql
 EXEC dbo.SaveLogsToAppLoggingDetails
```

## **AppLoggingDetails Object**
The Description Column in the below object handles the display logic
**Script**
```cs
public class AppLoggingDetails
    {
        public long LogId { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string UserName { get; set; }
        public int? Action { get; set; }
        public string ModelObject { get; set; }
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string KeyName1 { get; set; }
        public string KeyValue1 { get; set; }
        public string ValueName1 { get; set; }
        public string PropertyName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public Guid AppTransactionLogId { get; set; }
        public DateTime? CreateDate { get; set; }
        public string Description
        {
            get => (Action) switch
            {
                3 => $"{ValueName1} {(PropertyName == "Active" ? "" : PropertyName)}  was updated  " +
                            $"from {OldValue.Replace("True", "Enabled").Replace("False", "Disabled")} " +
                            $"to {NewValue.Replace("True", "Enabled").Replace("False", "Disabled")} in {ModelObject}",
                4 => $"{ValueName1 ?? "New Record"} {PropertyName}  was added  in {ModelObject}",
                _ => "An Error Occured"
            };

        }

    }
}
```

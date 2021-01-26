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
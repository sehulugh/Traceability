SELECT        'ContactId' AS ChildKeyName, ContactId AS ChildKeyValue, ContactName AS ChildValueName, 'VendorId' AS ParentKeyName, VendorId AS ParentKeyValue
FROM            dbo.Contacts
UNION
SELECT        'VendorNoteId' AS ChildKeyName, VendorNoteId AS ChildKeyValue, Note AS ChildValueName, 'VendorId' AS ParentKeyName, VendorId AS ParentKeyValue
FROM            [dbo].[VendorNotes]
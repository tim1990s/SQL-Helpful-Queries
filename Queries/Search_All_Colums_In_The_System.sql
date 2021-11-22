--Find all TABLE by your column name.
SELECT c.name AS 'Column_Name',
       t.name AS 'Table_Name'
FROM sys.columns c
    JOIN sys.tables t
        ON c.object_id = t.object_id
WHERE c.name LIKE '%Your_Key_Word%'
ORDER BY TableName,
         ColumnName;


--Find all TABLES and VIEWS by your column name.
SELECT      COLUMN_NAME AS 'ColumnName'
            ,TABLE_NAME AS  'TableName'
FROM        INFORMATION_SCHEMA.COLUMNS
WHERE       COLUMN_NAME LIKE '%Your_Key_Word%'
ORDER BY    TableName
            ,ColumnName;

--Find all TABLES by your column name WITH THE DETAIL INFORMATION.
SELECT s.[name] 'Schema',
       t.[name] 'Table',
       c.[name] 'Column',
       d.[name] 'Data Type',
       c.[max_length] 'Length',
       d.[max_length] 'Max Length',
       d.[precision] 'Precision',
       c.[is_identity] 'Is Id',
       c.[is_nullable] 'Is Nullable',
       c.[is_computed] 'Is Computed',
       d.[is_user_defined] 'Is UserDefined',
       t.[modify_date] 'Date Modified',
       t.[create_date] 'Date created'
FROM sys.schemas s
    INNER JOIN sys.tables t
        ON s.schema_id = t.schema_id
    INNER JOIN sys.columns c
        ON t.object_id = c.object_id
    INNER JOIN sys.types d
        ON c.user_type_id = d.user_type_id
WHERE c.name LIKE '%Your_Key_Word%';
-- Author: Tim Nguyen
-- Created Date: 09/08/2020

-- Step 1: If you are in the first time to use the script , run the script first and only one time.
CREATE PROCEDURE FindMyData_String
    @DataToFind NVARCHAR(4000),
    @ExactMatch BIT = 0
AS
SET NOCOUNT ON;

DECLARE @Temp TABLE
(
    RowId INT IDENTITY(1, 1),
    SchemaName sysname,
    TableName sysname,
    ColumnName sysname,
    DataType VARCHAR(100),
    DataFound BIT
);

INSERT INTO @Temp
(
    TableName,
    SchemaName,
    ColumnName,
    DataType
)
SELECT C.TABLE_NAME,
       C.TABLE_SCHEMA,
       C.COLUMN_NAME,
       C.DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS AS C
    INNER JOIN INFORMATION_SCHEMA.TABLES AS T
        ON C.TABLE_NAME = T.TABLE_NAME
           AND C.TABLE_SCHEMA = T.TABLE_SCHEMA
WHERE TABLE_TYPE = 'Base Table'
      AND DATA_TYPE IN ( 'ntext', 'text', 'nvarchar', 'nchar', 'varchar', 'char' );


DECLARE @i INT;
DECLARE @MAX INT;
DECLARE @TableName sysname;
DECLARE @ColumnName sysname;
DECLARE @SchemaName sysname;
DECLARE @SQL NVARCHAR(4000);
DECLARE @PARAMETERS NVARCHAR(4000);
DECLARE @DataExists BIT;
DECLARE @SQLTemplate NVARCHAR(4000);

SELECT @SQLTemplate
    = CASE
          WHEN @ExactMatch = 1 THEN
              'If Exists(Select *
                                          From   ReplaceTableName
                                          Where  Convert(nVarChar(4000), [ReplaceColumnName])
                                                       = ''' + @DataToFind
              + '''
                                          )
                                     Set @DataExists = 1
                                 Else
                                     Set @DataExists = 0'
          ELSE
              'If Exists(Select *
                                          From   ReplaceTableName
                                          Where  Convert(nVarChar(4000), [ReplaceColumnName])
                                                       Like ''%' + @DataToFind
              + '%''
                                          )
                                     Set @DataExists = 1
                                 Else
                                     Set @DataExists = 0'
      END,
       @PARAMETERS = N'@DataExists Bit OUTPUT',
       @i  = 1;

SELECT @i = 1,
       @MAX = MAX(RowId)
FROM @Temp;

WHILE @i <= @MAX
BEGIN
    SELECT @SQL
        = REPLACE(
                     REPLACE(@SQLTemplate, 'ReplaceTableName', QUOTENAME(SchemaName) + '.' + QUOTENAME(TableName)),
                     'ReplaceColumnName',
                     ColumnName
                 )
    FROM @Temp
    WHERE RowId = @i;


    PRINT @SQL;
    EXEC sp_executesql @SQL, @PARAMETERS, @DataExists = @DataExists OUTPUT;

    IF @DataExists = 1
        UPDATE @Temp
        SET DataFound = 1
        WHERE RowId = @i;

    SET @i = @i + 1;
END;

SELECT SchemaName,
       TableName,
       ColumnName
FROM @Temp
WHERE DataFound = 1;
GO

-- Step 2: Execute the command above by your keyword

EXEC FindMyData_String 'testing-keyword', 0;


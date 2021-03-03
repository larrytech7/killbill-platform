-- listen to create table events, get the unique fields and drop them and add them as serial column types instead.
CREATE OR ALTER TRIGGER trigger_update_serial_column
    ON DATABASE
    FOR CREATE_TABLE
    AS
        SET NOCOUNT ON;
        DECLARE @table NVARCHAR(255);
        DECLARE @column NVARCHAR(255);
        SELECT @table = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID);
        -- SELECT @column = c.name FROM sys.columns c JOIN sys.types t ON c.user_type_id=t.user_type_id WHERE c.object_id=OBJECT_ID(@table) AND t.name="serial"
        SELECT TOP 1 @column = c.column_name FROM information_Schema.TABLE_CONSTRAINTS tc join information_Schema.columns c ON c.TABLE_NAME=tc.TABLE_NAME and c.data_type='int' WHERE tc.table_name=@table;
        EXEC update_serial_column @Table = @table , @Column = @column


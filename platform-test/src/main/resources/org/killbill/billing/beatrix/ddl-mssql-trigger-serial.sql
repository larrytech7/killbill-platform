CREATE OR ALTER PROCEDURE update_serial_column
    @Table nvarchar(255), @Column varchar(255)
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @tsql varchar(500)
        SET @tsql = 'ALTER TABLE [' + @Table + '] DROP COLUMN [' + @Column + ']'
        SELECT @tsql
        SET @tsql = 'ALTER TABLE [' + @Table + '] ADD [' + @Column +'] serial identity(1,1)'
        SELECT @tsql;
        SET NOCOUNT OFF;
    END;

-- listen to create table events, get hte unique fields and drop them and add them as serial column types instead.
CREATE TRIGGER trigger_update_serial_column
    ON DATABASE
    FOR CREATE_TABLE
    AS
        SET NOCOUNT ON;
        DECLARE @table nvarchar(255);
        DECLARE @column nvarchar(255);
        SELECT @table = OBJECT_NAME(parent_object_id) FROM sys.objects WHERE sys.objects.name = OBJECT_NAME(@@PROCID);
        SELECT @column = c.name from sys.columns c join sys.types t on c.user_type_id=t.user_type_id where c.object_id=OBJECT_ID(@table) AND TYPE_NAME(c.USER_TYPE_ID)="serial"
        EXEC update_serial_column @Table = @table , @Column = @column
-- GO

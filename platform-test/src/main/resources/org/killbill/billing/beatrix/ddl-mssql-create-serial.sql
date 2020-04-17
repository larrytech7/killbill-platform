-- override the last_insert_id method to return the @@IDENTITY value as intended for SQL server
-- DROP FUNCTION IF EXISTS last_insert_id;
/*
CREATE OR ALTER FUNCTION last_insert_id()
    RETURNS INT
    AS
    BEGIN
        DECLARE @id INT;
        SELECT @id = @@IDENTITY;
        RETURN @id;
    END;

-- SQL server doesn't have any object called serial, so first we want to create a new type alias for serial based on the int type
*/
/*
CREATE PROCEDURE create_serial_type
    AS
    SET NOCOUNT ON;
    BEGIN
        DECLARE @drop varchar(100)
        DECLARE @create varchar(100)
        set @drop='DROP TYPE IF EXISTS serial'
        set @create='CREATE TYPE serial FROM int NOT NULL;'
        select @drop
        select @create
    END;

EXEC create_serial_type;

 */
/*
-- GO

-- We need a function/procedure that will alter the serial field of a given table to add an identity property to it since the serial fields require to be incremental in nature
IF OBJECT_ID ('update_serial_column', 'P') IS NOT NULL
    DROP PROCEDURE update_serial_column;
-- GO

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
-- GO
*/
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

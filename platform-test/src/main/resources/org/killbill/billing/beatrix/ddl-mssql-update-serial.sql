-- Required to update serial table fields to complete serial fields
CREATE OR ALTER PROCEDURE update_serial_column
    @Table nvarchar(255), @Column varchar(255) = ''
    AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @tsql varchar(500);
        IF (LEN(@Column) > 0)
            BEGIN
                SET @tsql = 'ALTER TABLE [' + @Table + '] DROP COLUMN [' + @Column + ']'
                SELECT @tsql
                SET @tsql = 'ALTER TABLE [' + @Table + '] ADD [' + @Column +'] serial identity(1,1)'
                SELECT @tsql;
            END;
        SET NOCOUNT OFF;
    END

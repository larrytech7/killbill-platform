-- override the last_insert_id method to return the @@IDENTITY value as intended for SQL server
CREATE OR ALTER FUNCTION last_insert_id()
    RETURNS INT
    AS
    BEGIN
        DECLARE @id INT;
        SELECT @id = @@IDENTITY;
        RETURN @id;
    END;
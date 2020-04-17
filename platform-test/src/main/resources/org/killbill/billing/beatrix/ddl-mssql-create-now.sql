-- override the now() method to return the getdate value as required for SQL server
CREATE OR ALTER FUNCTION now()
    RETURNS INT
        AS
        BEGIN
            DECLARE @time VARCHAR(100);
            SELECT @time = getdate();
            RETURN @time;
        END
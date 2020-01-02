CREATE OR ALTER PROCEDURE Kategorirapport
AS

BEGIN
SELECT * FROM Sold_This_Month
EXEC Sold_Last_Month
SELECT * FROM Sold_Last_365_Days
SELECT * FROM Returned_This_Month
EXEC returned_Last_Month
SELECT * FROM Returned_Last_365_Days
END
GO

exec Kategorirapport

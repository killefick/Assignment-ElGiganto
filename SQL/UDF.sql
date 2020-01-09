CREATE OR ALTER FUNCTION dbo.Sold_Last_Month()
RETURNS @Result TABLE
(CategoryName varchar(20),
    Sold_Last_Month int)
AS
BEGIN
    /* https://stackoverflow.com/questions/1424999/get-the-records-OF-last-month-IN-sql-server */
    DECLARE @startOfCurrentMonth datetime
    SET @startOfCurrentMonth = DATEADD(month, DATEDIFF(month, 0, CURRENT_TIMESTAMP), 0);

    WITH
        Sold_Last_Month_cte(CategoryName, Sold_Last_Month)
        AS

        (
            SELECT
                c.Name AS CategoryName,
                SUM(st.StockChange * -1) AS Sold_Last_Month
            FROM
                Stocktransactions st
                INNER JOIN Products p ON p.Id = st.ProductId
                INNER JOIN Categories c ON c.Id = p.CategoryId
            WHERE DateTimeOfTransaction >= DATEADD(month, -1, @startOfCurrentMonth)
                AND DateTimeOfTransaction < @startOfCurrentMonth
                AND st.transactionid = 1
            GROUP BY c.Name
        )

    INSERT @Result
    SELECT CategoryName, Sold_Last_Month
    FROM Sold_Last_Month_cte

    RETURN
END
    GO

/* Returned_Last_Month */
CREATE OR ALTER FUNCTION dbo.Returned_Last_Month()
RETURNS @Result TABLE
(CategoryName varchar(20),
    Returned_Last_Month int)
AS
BEGIN
    /* https://stackoverflow.com/questions/1424999/get-the-records-OF-last-month-IN-sql-server */
    DECLARE @startOfCurrentMonth datetime
    SET @startOfCurrentMonth = DATEADD(month, DATEDIFF(month, 0, CURRENT_TIMESTAMP), 0);

    WITH
        Returned_Last_Month_cte(CategoryName, Returned_Last_Month)
        AS

        (
            SELECT
                c.Name AS CategoryName,
                SUM(st.AmountReturned) AS Returned_Last_Month
            FROM
                Stocktransactions st
                INNER JOIN Products p ON p.Id = st.ProductId
                INNER JOIN Categories c ON c.Id = p.CategoryId
            /* https://stackoverflow.com/questions/1424999/get-the-records-OF-last-month-IN-sql-server */
            WHERE DateTimeOfTransaction >= DATEADD(month, -1, @startOfCurrentMonth)
                AND DateTimeOfTransaction < @startOfCurrentMonth
                AND st.transactionid = 3
            GROUP BY c.Name
        )

    INSERT @Result
    SELECT CategoryName, Returned_Last_Month
    FROM Returned_Last_Month_cte

    RETURN
END
    GO
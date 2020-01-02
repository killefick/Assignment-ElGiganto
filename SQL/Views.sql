/* GetAllProducts */
CREATE OR ALTER VIEW GetAllProducts
AS
    SELECT
        p.Id,
        c.Name CategoryName,
        p.Name ProductName,
        Price,
        IsInStock,
        Popularity,
        w.InStock,
        w.Reserved,
        w.Available
    FROM
        Products p
        INNER JOIN Categories c
        ON p.CategoryId = c.Id
        INNER JOIN Warehouse w
        ON w.ProductId = p.Id
GO

/* TopReturnedProducts */
CREATE OR ALTER VIEW TopReturnedProducts
AS
    WITH
        TopReturned
        (
            Name,
            AmountReturned
        )
        AS
        (
            SELECT
                Products.Name,
                sum(StockTransactions.AmountReturned) AS AmountReturned
            FROM
                Products
                INNER JOIN StockTransactions ON Stocktransactions.ProductId = Products.Id
            GROUP BY Products.Name
        )
    SELECT
        TopReturned.*,
        ROW_Number() OVER (ORDER BY AmountReturned DESC) AS Ranking
    FROM
        TopReturned
    GROUP BY Name, AmountReturned
GO

/* TopPopularProducts */
CREATE OR ALTER VIEW MostPopular
AS
    WITH
        TopPopularProducts
        (
            CategoryName,
            ProductName,
            Popularity
        )
        AS
        (
            SELECT
                Categories.Name,
                Products.Name,
                Products.Popularity
            FROM
                Products
                INNER JOIN Categories ON Categories.Id = Products.CategoryId
            WHERE Products.CategoryId = Categories.Id
        )
    SELECT
        TopPopularProducts.*,
        ROW_Number() OVER (PARTITION BY CategoryName ORDER BY Popularity DESC) AS Ranking
    FROM
        TopPopularProducts
    GROUP BY CategoryName, ProductName, Popularity
GO

/* Kategorirapport */
-- (en rad per kategori)
--  Sålt antal innevarande månad
--  Sålt antal föregående månad
--  Sålt antal senaste 365 dagarna
--  Returnerat antal innevarande månad
--  Returnerat antal föregående månad
--  Returnerat antal senaste 365 dagar


CREATE OR ALTER VIEW Sold_This_Month
AS
    (
    SELECT
        c.Name AS Category,
        SUM(st.StockChange * -1) AS Sold_This_Month
    FROM
        Stocktransactions st
        INNER JOIN Products p ON p.Id = st.ProductId
        INNER JOIN Categories c ON c.Id = p.CategoryId
    WHERE MONTH(st.DateTimeOfTransaction) = MONTH(GETDATE())
        AND st.transactionid = 1
    GROUP BY c.Name
    )
GO

CREATE OR ALTER VIEW Returned_This_Month
AS
    (
    SELECT
        c.Name AS Category,
        SUM(st.AmountReturned) AS Returned_This_Month
    FROM
        Stocktransactions st
        INNER JOIN Products p ON p.Id = st.ProductId
        INNER JOIN Categories c ON c.Id = p.CategoryId
    WHERE MONTH(st.DateTimeOfTransaction) = MONTH(GETDATE())
        AND st.transactionid = 3
    GROUP BY c.Name
    )
GO

CREATE OR ALTER VIEW Sold_Last_365_Days
AS
    (
    SELECT
        c.Name AS Category,
        SUM(st.StockChange * -1) AS Sold_Last_365
    FROM
        Stocktransactions st
        INNER JOIN Products p ON p.Id = st.ProductId
        INNER JOIN Categories c ON c.Id = p.CategoryId
    WHERE st.DateTimeOfTransaction > (GETDATE() - 365)
        AND st.transactionid = 1
    GROUP BY c.Name
)
GO

CREATE OR ALTER VIEW Returned_Last_365_Days
AS
    (
    SELECT
        c.Name AS Category,
        SUM(st.AmountReturned) AS Returned_Last_365_Days
    FROM
        Stocktransactions st
        INNER JOIN Products p ON p.Id = st.ProductId
        INNER JOIN Categories c ON c.Id = p.CategoryId
    WHERE st.DateTimeOfTransaction > (GETDATE() - 365)
        AND st.transactionid = 3
    GROUP BY c.Name
)
GO
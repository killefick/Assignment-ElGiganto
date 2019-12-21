-- CREATE OR ALTER PROCEDURE test
--     (@tal1 int,
--     @tal2 int,
--     @summainternal int output)
-- AS
-- SET @summainternal = @tal1 + @tal2
-- GO

-- DECLARE @sum int;
-- EXEC test 1,2, @summainternal = @sum output
-- SELECT @sum;
-- GO


/* GetAllProducts */
CREATE OR ALTER VIEW GetAllProducts
AS
    SELECT c.Name Category, p.Name Product, Price, IsInStock, Popularity
    FROM Products p
        INNER JOIN Categories c
        ON p.CategoryId = c.Id
GO


SELECT Category, Product, Price, IsInStock, Popularity
FROM GetAllProducts
GO


/* GetProductDetails & Popularity +1 */
CREATE OR ALTER PROCEDURE GetProductDetails
    (@ProcuctId int)
AS
SELECT c.Name Category, p.Name Product, Price, IsInStock, Popularity
FROM Products p
    INNER JOIN Categories c
    ON p.CategoryId = c.Id
WHERE p.Id = @ProcuctId
UPDATE Products 
	SET Products.Popularity +=1
	WHERE Products.Id = @ProcuctId
GO


/* ListProductsByCategory */
CREATE OR ALTER PROCEDURE ListProductsByCategory
    (@IsInStock int)
AS
SELECT c.Name AS Kategori, p.Name Produkt, p.Price Pris, p.Popularity Popularitet
FROM Products p
    INNER JOIN Categories c ON p.CategoryId = c.Id

WHERE p.IsInStock = @IsInStock
    OR p.IsInStock = 1

GROUP BY c.Name, p.Name, p.Price, p.Popularity
ORDER BY c.Name, p.Popularity DESC
GO

EXEC ListProductsByCategory 0
GO


/* CreateCart & Return CartId */
CREATE OR ALTER PROCEDURE CreateCart
    @CustomerId int
AS
BEGIN
    INSERT INTO Carts
        (CustomerId)
    VALUES
        (@CustomerId)
    RETURN SCOPE_IDENTITY()
END
    GO


DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 2
SELECT @CartIdOut AS CartId
GO


/* Delete carts older than 14 days */
CREATE OR ALTER PROCEDURE ClearOldCarts
AS
BEGIN
    DELETE FROM Carts
    WHERE (DATEDIFF(WEEK, DateTimeCreated, GETDATE())) >0
END
GO

EXEC ClearOldCarts
GO

SELECT *
FROM Carts;
GO


/* Insert into cart */
CREATE OR ALTER PROCEDURE InsertIntoCart
    (@CartId int,
    @ProductId int,
    @Amount int)
AS
BEGIN
    /* existing produkt */
    IF EXISTS
    (SELECT ProductId
    FROM Products_Cart pc
    WHERE pc.Id = @CartId AND pc.ProductId = @ProductId)
    
    UPDATE Products_Cart
    SET Products_Cart.Amount += @Amount
    WHERE Products_Cart.Id = @CartId AND Products_Cart.ProductId = @ProductId

    ELSE
    /* new product */
    INSERT INTO Products_Cart
        (CartId, ProductId, Amount)
    VALUES
        (@CartId, @ProductId, @Amount)
END
    GO

SELECT *
FROM Products_Cart GO

EXEC InsertIntoCart  1, 6, 15
GO

SELECT Name, Popularity
FROM Products

SELECT *
FROM Products_Cart
WHERE CartId = 1
GO


/* GetCart */
CREATE OR ALTER PROCEDURE GetCart
    (@CartId int)
AS
BEGIN
    SELECT p.Name, pc.Amount, p.Price, pc.Sum
    FROM Products_Cart pc
        INNER JOIN Products p ON pc.ProductId = p.Id
    WHERE pc.CartId = @CartId;
END
    GO

EXEC GetCart 1

SELECT *
FROM Products_Cart
GO

SELECT *
FROM Carts
GO


/* Checkout cart */
CREATE OR ALTER PROCEDURE CheckoutCart
    (@CustomerId int,
    @CartId int,
    @OrderNumberToCustomer int output)
AS
BEGIN
    -- create order and insert customer id
    DECLARE @OrderId int
    INSERT INTO Orders
        (CustomerId)
    VALUES
        (@CustomerId)

    SET @OrderId = SCOPE_IDENTITY()

    --generate random order number
    SET @OrderNumberToCustomer = FLOOR(RAND()*(99999999-10000000+1))+10000000;

    -- update customer details
    UPDATE Orders
    SET 
        Orders.CustomerName = c.CustomerName,
        Orders.CustomerStreet = c.CustomerStreet,
        Orders.CustomerZip = c.CustomerZip,
        Orders.CustomerCity = c.CustomerCity
    FROM Orders o
        INNER JOIN Customers c ON o.CustomerId = c.Id
    WHERE o.CustomerId = @CustomerId

    -- move products from cart
    INSERT INTO Products_Order
        (OrderId, ProductId, Amount)
    SELECT @OrderId, Products_Cart.ProductId, Products_Cart.Amount
    FROM Products_Cart
    WHERE Products_Cart.CartId = @CartId

    -- reserve products in warehouse
    UPDATE Warehouse
    SET Warehouse.Reserved = po.Amount
    FROM Products_Order po
    WHERE Warehouse.ProductId = po.ProductId
        AND po.Id = @OrderId

    -- empty cart
    DELETE FROM Products_Cart
    WHERE Products_Cart.CartId = @CartId
END
    GO


DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 4
SELECT @CartIdOut AS CartId

SELECT *
FROM carts
EXEC InsertIntoCart   2, 8, 150
EXEC InsertIntoCart  10, 9, 2000
EXEC InsertIntoCart  11, 14, 99
SELECT *
FROM carts
EXEC getcart 11
GO


SELECT *
FROM Products_Cart


-- DECLARE @sum int;
-- EXEC test 1,2, @summainternal = @sum output
-- SELECT @sum;


DECLARE @orderno int;
EXEC CheckoutCart 1, 7, @OrderNumberToCustomer = @orderno
SELECT @orderno

-- DECLARE @orderno int;
-- EXEC CheckoutCart 2, 10, @OrderNumberToCustomer = @orderno
-- SELECT @orderno

-- DECLARE @orderno int;
-- EXEC CheckoutCart 3, 11, @OrderNumberToCustomer = @orderno

GO
SELECT *
FROM StockTransactions
ORDER BY ID DESC




SELECT *
FROM Products_Cart

SELECT *
FROM Products_Order

SELECT *
FROM Warehouse

SELECT *
FROM Products
GO


/* Popularitetsrapport */
CREATE OR ALTER PROCEDURE CheckPopularity
    (@CategoryId int)
AS
SELECT TOP 5
    CategoryId, Name, Popularity
FROM Products
WHERE CategoryId = @CategoryId
ORDER BY Popularity DESC
GO

EXEC CheckPopularity 1
GO

/* ShipOrder */
CREATE OR ALTER PROCEDURE ShipOrder
    (@OrderId int)
AS
BEGIN
    -- log stock transaction
    INSERT INTO StockTransactions
        (OrderId, ProductId, StockChange, DateTimeOfTransaction, TransactionId)
    SELECT po.OrderId, po.ProductId, po.Amount * (-1), GETDATE(), 1
    FROM Products_Order po
    WHERE po.OrderId = @OrderId

    -- ta bort reservationen
    UPDATE Warehouse
    SET Warehouse.Reserved += StockTransactions.StockChange,
    Warehouse.InStock += StockTransactions.StockChange
    FROM Warehouse INNER JOIN StockTransactions
        ON Warehouse.ProductId = StockTransactions.ProductId
    WHERE Warehouse.ProductId = StockTransactions.ProductId
        AND StockTransactions.OrderId = @OrderId
END
GO


/* StockAdjustment */
CREATE OR ALTER PROCEDURE StockAdjustment
    (@ProductId int,
    @StockChange int,
    @TransactionId int = NULL
)
AS
BEGIN
    -- log stock transaction
    INSERT INTO StockTransactions
        (ProductId, StockChange, DateTimeOfTransaction, TransactionId)
    VALUES(@ProductId, @StockChange, GETDATE(), @TransactionId)

    -- justera lagersaldo
    UPDATE Warehouse
    SET Warehouse.InStock += @StockChange
    WHERE Warehouse.ProductId = @ProductId
END
GO
EXEC StockAdjustment 1, 13
GO
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions
GO

/* ReturnOrder */
CREATE OR ALTER PROCEDURE ReturnOrder
    (@OrderId int,
    @ProductId int,
    @AmountReturned int,
    @StockChange int = NULL
)
AS
BEGIN
    -- log stock transaction
    INSERT INTO StockTransactions
        (OrderId, ProductId, StockChange, DateTimeOfTransaction, TransactionId, AmountReturned)
    VALUES(@OrderId, @ProductId, @StockChange, GETDATE(), 3, @AmountReturned)

    IF @StockChange IS NOT NULL
        -- justera lagersaldo
        UPDATE Warehouse
        SET Warehouse.InStock += @StockChange
        WHERE Warehouse.ProductId = @ProductId
END
GO
EXEC ReturnOrder 19, 14, 222,223
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions
GO

/* ListAllOrdersTotalAmount */
CREATE OR ALTER PROCEDURE ListAllOrdersTotalAmount
AS
BEGIN
    SELECT Products_Order.OrderId,
        sum(Products_Order.Amount * Products.Price) AS OrderTotal
    FROM Products_Order
        INNER JOIN Products ON Products.Id = Products_Order.ProductId
    WHERE Products_Order.ProductId = Products.Id
    GROUP BY OrderId
    ORDER BY OrderTotal DESC
END
GO

EXEC ListAllOrdersTotalAmount
GO

/* CTE variant */
WITH
    TotalPerOrder (OrderId, OrderTotal)
    AS
    (
        SELECT Products_Order.OrderId,
            sum(Products_Order.Amount * Products.Price) AS OrderTotal
        FROM Products_Order
            INNER JOIN Products ON Products.Id = Products_Order.ProductId
        WHERE Products_Order.ProductId = Products.Id
        GROUP BY OrderId
    )
SELECT TotalPerOrder.*
FROM TotalPerOrder
ORDER BY OrderTotal DESC
GO


/* GetTotalAmountOfOrder */
CREATE OR ALTER PROCEDURE GetTotalAmountOfOrder
    (@OrderId int)
AS
BEGIN
    SELECT Products_Order.OrderId,
        sum(Products_Order.Amount * Products.Price) AS OrderTotal
    FROM Products_Order
        INNER JOIN Products ON Products.Id = Products_Order.ProductId
    WHERE Products_Order.ProductId = Products.Id
        AND Products_Order.OrderId = @OrderId
    GROUP BY OrderId
END
GO

EXEC GetTotalAmountOfOrder 15
GO


EXEC ReturnOrder 1, 1, 5
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions

SELECT *
FROM Transactions
GO
EXEC ShipOrder 9
SELECT *
FROM Warehouse

SELECT *
FROM Products_Order
SELECT *
FROM StockTransactions
SELECT *
FROM Warehouse
GO


/* TopPopularProducts */
CREATE OR ALTER VIEW MostPopular
AS
    WITH
        TopPopularProducts (Category, Name, Popularity)
        AS
        (
            SELECT Categories.Name, Products.Name, Products.Popularity
            FROM Products
                INNER JOIN Categories ON Categories.Id = Products.CategoryId
            WHERE Products.CategoryId = Categories.Id
        )
    SELECT TopPopularProducts.*,
        ROW_Number() OVER (PARTITION BY Category ORDER BY Popularity DESC) AS Ranking
    FROM TopPopularProducts
    GROUP BY Category, Name, Popularity
GO

SELECT *
FROM MostPopular
WHERE Ranking <= 5
GO


/* TopReturnedProducts */
CREATE OR ALTER VIEW TopReturnedProducts
AS
    WITH
        TopReturned(Name, AmountReturned)
        AS
        (
            SELECT Products.Name, sum(StockTransactions.AmountReturned) AS AmountReturned
            FROM Products
                INNER JOIN StockTransactions ON Stocktransactions.ProductId = Products.Id
            GROUP BY Products.Name
        )
    SELECT TopReturned.*,
        ROW_Number() OVER (ORDER BY AmountReturned DESC) AS Ranking
    FROM TopReturned
    GROUP BY Name, AmountReturned
GO

SELECT TOP 5
    *
FROM TopReturnedProducts
go
/* Kategorirapport */

-- (en rad per kategori)
--  Sålt antal innevarande månad
--  Sålt antal föregående månad
--  Sålt antal senaste 365 dagarna
--  Returnerat antal innevarande månad
--  Returnerat antal föregående månad
--  Returnerat antal senaste 365 dagar

-- CREATE OR ALTER VIEW SoldLast365Days
-- AS
--     (
    SELECT c.Name as Kategori, st.StockChange AS Saldoändring
    FROM Stocktransactions st
        INNER JOIN Products p ON p.Id = st.ProductId
        INNER JOIN Categories c ON p.CategoryId = c.Id
    WHERE st.DateTimeOfTransaction > (GETDATE() - 365)
        AND st.transactionid = 1
        GROUP by c.Name, st.StockChange
-- )
GO


SELECT *
FROM StockTransactions
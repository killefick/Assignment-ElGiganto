/* GetProductDetails & Popularity +1 */
CREATE OR ALTER PROCEDURE GetProductDetails
    (@ProcuctId int)
AS
BEGIN TRY
BEGIN TRANSACTION
SELECT
    c.Name Category,
    p.Name Product,
    Price,
    IsInStock,
    Popularity
FROM
    Products p
    INNER JOIN Categories c
    ON p.CategoryId = c.Id
WHERE p.Id = @ProcuctId
UPDATE Products 
	SET Products.Popularity +=1
	WHERE Products.Id = @ProcuctId
COMMIT
END TRY
BEGIN CATCH
ROLLBACK
END CATCH
GO

/* ListProductsByCategory */
CREATE OR ALTER PROCEDURE ListProductsByCategory
    (@IsInStock int)
AS
SELECT
    c.Name AS CategoryName,
    p.Name ProductName,
    p.Price,
    p.Popularity
FROM
    Products p
    INNER JOIN Categories c ON p.CategoryId = c.Id

WHERE p.IsInStock = @IsInStock
    OR p.IsInStock = 1

GROUP BY c.Name, p.Name, p.Price, p.Popularity
ORDER BY c.Name, p.Popularity DESC
GO

/* CreateCustomer */
CREATE OR ALTER PROCEDURE CreateCustomer
    @CustomerNumber int
AS
BEGIN
    INSERT INTO Customers
        (CustomerNumber)
    VALUES
        (@CustomerNumber)
END
    GO

/* CreateCart & Return CartId */
CREATE OR ALTER PROCEDURE CreateCart
    @customerNumber int
AS
BEGIN
    INSERT INTO Carts
        (CustomerId)
    SELECT
        Customers.Id
    FROM
        Customers
    WHERE @customerNumber = Customers.CustomerNumber
    RETURN SCOPE_IDENTITY()
END
    GO

/* Delete carts older than 14 days */
CREATE OR ALTER PROCEDURE ClearOldCarts
AS
BEGIN
    DELETE FROM Carts
    WHERE (DATEDIFF(WEEK, DateTimeCreated, GETDATE())) >0
END
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
    (SELECT
        ProductId
    FROM
        Products_Cart pc
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

/* GetCart */
CREATE OR ALTER PROCEDURE GetCart
    (@CartId int)
AS
BEGIN
    SELECT
        p.Name,
        pc.Amount,
        p.Price,
        pc.Sum
    FROM
        Products_Cart pc
        INNER JOIN Products p ON pc.ProductId = p.Id
    WHERE pc.CartId = @CartId;
END
    GO

/* CheckoutCart */
CREATE OR ALTER PROCEDURE CheckoutCart
    (@CustomerNumber int,
    @CartId int)
AS

BEGIN TRY
BEGIN TRANSACTION

    -- create order and insert customer id
    DECLARE @OrderId int

    INSERT INTO Orders
    (CustomerId)
SELECT
    Customers.Id
FROM
    Customers
WHERE @CustomerNumber = Customers.CustomerNumber
    SET @OrderId = SCOPE_IDENTITY()

    -- update customer details
    UPDATE Orders
    SET 
        Orders.CustomerName = c.CustomerName,
        Orders.CustomerStreet = c.CustomerStreet,
        Orders.CustomerZip = c.CustomerZip,
        Orders.CustomerCity = c.CustomerCity
    FROM
    Orders o
    INNER JOIN Customers c ON o.CustomerId = c.Id
    WHERE o.CustomerId = c.Id

    -- move products from cart
    INSERT INTO Products_Order
    (OrderId, ProductId, Amount)
SELECT
    @OrderId,
    Products_Cart.ProductId,
    Products_Cart.Amount
FROM
    Products_Cart
WHERE Products_Cart.CartId = @CartId

    -- reserve products in warehouse
    UPDATE Warehouse
    SET Warehouse.Reserved = po.Amount
    FROM
    Products_Order po
    WHERE Warehouse.ProductId = po.ProductId
    AND po.OrderId = @OrderId


    -- empty cart
    DELETE FROM Products_Cart
    WHERE Products_Cart.CartId = @CartId

    --generate random order number
    SELECT
    FLOOR(RAND()*(99999999-10000000+1))+10000000 AS OrderNumber
        
    COMMIT
    END TRY

        BEGIN CATCH
        ROLLBACK
        END CATCH
    GO

/* Popularitetsrapport */
CREATE OR ALTER PROCEDURE CheckPopularity
    (@CategoryId int)
AS
SELECT
    TOP 5
    CategoryId,
    Name,
    Popularity
FROM
    Products
WHERE CategoryId = @CategoryId
ORDER BY Popularity DESC
GO

/* ShipOrder */
CREATE OR ALTER PROCEDURE ShipOrder
    (@OrderId int)
AS
BEGIN TRY
BEGIN TRANSACTION
    -- log stock transaction
    INSERT INTO StockTransactions
    (OrderId, ProductId, StockChange, DateTimeOfTransaction, TransactionId)
SELECT
    po.OrderId,
    po.ProductId,
    po.Amount * (-1),
    GETDATE(),
    1
FROM
    Products_Order po
WHERE po.OrderId = @OrderId

    -- ta bort reservationen
    UPDATE Warehouse
    SET Warehouse.Reserved += StockTransactions.StockChange,
    Warehouse.InStock += StockTransactions.StockChange
    FROM
    Warehouse INNER JOIN StockTransactions
    ON Warehouse.ProductId = StockTransactions.ProductId
    WHERE Warehouse.ProductId = StockTransactions.ProductId
    AND StockTransactions.OrderId = @OrderId
COMMIT
END TRY

BEGIN CATCH
ROLLBACK
END CATCH
GO

/* StockAdjustment */
CREATE OR ALTER PROCEDURE StockAdjustment
    (@ProductId int,
    @StockChange int,
    @TransactionId int = NULL
)
AS
BEGIN TRY
BEGIN TRANSACTION
    -- log stock transaction
    INSERT INTO StockTransactions
    (ProductId, StockChange, DateTimeOfTransaction, TransactionId)
VALUES(@ProductId, @StockChange, GETDATE(), @TransactionId)

    -- justera lagersaldo
    UPDATE Warehouse
    SET Warehouse.InStock += @StockChange
    WHERE Warehouse.ProductId = @ProductId
    COMMIT
    END TRY

BEGIN CATCH
ROLLBACK
END CATCH
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

/* ListAllOrdersTotalAmount */
/* CTE variant */
WITH
    TotalPerOrder
    (
        OrderId,
        OrderTotal
    )
    AS
    (
        SELECT
            Products_Order.OrderId,
            sum(Products_Order.Amount * Products.Price) AS OrderTotal
        FROM
            Products_Order
            INNER JOIN Products ON Products.Id = Products_Order.ProductId
        WHERE Products_Order.ProductId = Products.Id
        GROUP BY OrderId
    )
SELECT
    TotalPerOrder.*
FROM
    TotalPerOrder
ORDER BY OrderTotal DESC
GO

/* GetTotalAmountOfOrder */
CREATE OR ALTER PROCEDURE GetTotalAmountOfOrder
    (@OrderId int)
AS
BEGIN
    SELECT
        Products_Order.OrderId,
        sum(Products_Order.Amount * Products.Price) AS OrderTotal
    FROM
        Products_Order
        INNER JOIN Products ON Products.Id = Products_Order.ProductId
    WHERE Products_Order.ProductId = Products.Id
        AND Products_Order.OrderId = @OrderId
    GROUP BY OrderId
END
GO
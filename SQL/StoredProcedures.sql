CREATE OR ALTER PROCEDURE test
    (@tal1 int,
    @tal2 int,
    @summainternal int output)
AS
SET @summainternal = @tal1 + @tal2
GO

DECLARE @sum int;
EXEC test 1,2, @summainternal = @sum output
SELECT @sum;
GO


/* GetAllProducts */
CREATE OR ALTER PROCEDURE GetAllProducts
AS
SELECT c.Name Category, p.Name Product, Price, InStock, Popularity
FROM Products p
    INNER JOIN Categories c
    ON p.CategoryId = c.Id
GO

EXEC GetAllProducts
GO


/* GetProductDetails & Popularity +1 */
CREATE OR ALTER PROCEDURE GetProductDetails
    (@ProcuctId int)
AS
SELECT c.Name Category, p.Name Product, Price, InStock, Popularity
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
    (@InStock int)
AS
SELECT c.Name AS Kategori, p.Name Produkt, p.Price Pris, p.Popularity Popularitet
FROM Products p
    INNER JOIN Categories c ON p.CategoryId = c.Id

WHERE p.InStock = @InStock
    OR p.InStock = 1

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
EXEC @CartIdOut = CreateCart 1
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

EXEC InsertIntoCart  1, 13, 2
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

    -- log stock transaction
    INSERT INTO StockTransactions
        (OrderId, ProductId, StockChange, DateTimeOfTransaction, TransactionId)
    SELECT po.OrderId, po.ProductId, po.Amount, GETDATE(), 1
    FROM Products_Order po
    WHERE po.OrderId = @OrderId
END
    GO


DECLARE @randomNumber int;
EXEC CheckoutCart 1,1, @OrderNumberToCustomer = @randomNumber output
-- SELECT @randomNumber;
GO
SELECT *
FROM StockTransactions

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



-- SELECT CategoryId, Name, Popularity,
--     RANK() OVER(PARTITION BY Popularity
--   ORDER BY Popularity DESC) AS RowNumberRank
-- FROM Products
-- GROUP BY Popularity, CategoryId, Name

-- SELECT TOP 5
--     CategoryId, Name, Popularity,


--     RANK () OVER (
-- ORDER BY Products.Popularity DESC
-- ) Ranking
-- FROM
--     Products

-- SELECT
--  v,
--  RANK () OVER ( 
--  ORDER BY v 
--  ) rank_no 
-- FROM
--  sales.rank_demo;
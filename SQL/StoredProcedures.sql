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
    INSERT INTO Cart (CustomerId)
    VALUES (@CustomerId)
    RETURN SCOPE_IDENTITY()
END
    GO


DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 6
SELECT @CartIdOut AS CartId
GO

SELECT *
FROM cart
GO


/* InsertIntoCart */
-- CREATE OR ALTER PROCEDURE InsertIntoCart
--     (@CartId int,
--     @ProductId int,
--     @Amount int,
--     @Price int)
-- AS
-- BEGIN
--     UPDATE Cart
--   SET Amount += @Amount, Price = @Price
--     WHERE Cart.Id = @CartId AND Cart.ProductId = @ProductId
-- END
--     GO

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
EXEC InsertIntoCart  1, 2, -5
GO
SELECT *
FROM Products_Cart  where CartId = 1
GO


/* UpdateCart */
-- CREATE OR ALTER PROCEDURE UpdateCart
--     (@CartId int,
--     @ProductId int,
--     @Amount int,
--     @Price int)
-- AS
-- BEGIN
--     UPDATE Cart
-- 	SET Cart.Amount = Cart.Amount + @Amount, Cart.Price = @Price
-- 	WHERE Cart.Id = @CartId
--         AND Cart.ProductId = @ProductId
-- END
--     GO

-- UpdateCart 10, 1, 4, 220
-- 	GO


/* GetCart */
CREATE OR ALTER PROCEDURE GetCart
    (@CartId int)
AS
BEGIN
    SELECT p.Name
    FROM Cart c
        INNER JOIN Products p ON c.ProductId = p.Id
    WHERE c.Id = @CartId;
END
    GO
EXEC GetCart 10

SELECT *
FROM Cart
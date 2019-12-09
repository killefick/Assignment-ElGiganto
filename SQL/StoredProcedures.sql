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
    @ProductId int,
    @Amount int,
    @Price int,
    @CartId int output
AS
BEGIN
    INSERT INTO Cart
        (ProductId, Amount, Price)
    VALUES
        (@ProductId, @Amount, @Price)

    SET @CartId = SCOPE_IDENTITY()
    RETURN @CartId
END
    GO

DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 1, 1, 1, 1
SELECT @CartIdOut AS CartId
GO

select * from cart go


/* InsertIntoCart */
CREATE OR ALTER PROCEDURE InsertIntoCart
    (@ProductId int,
    @Amount int,
    @Price int)
AS
BEGIN
    INSERT INTO Cart
        (ProductId, Amount, Price)
    VALUES
        (@ProductId, @Amount, @Price)
END
    GO
EXEC InsertIntoCart 3, 4, 220
GO


/* UpdateCart */
CREATE OR ALTER PROCEDURE UpdateCart
    (@CartId int,
    @ProductId int,
    @Amount int,
    @Price int)
AS
BEGIN
    UPDATE Cart
	SET Cart.Amount = Cart.Amount + @Amount, Cart.Price = @Price
	WHERE Cart.Id = @CartId
        AND Cart.ProductId = @ProductId
END
    GO

UpdateCart 10, 1, 4, 220
	GO


/* GetCart */
CREATE OR ALTER PROCEDURE GetCart
    (@CartId int)
AS
BEGIN
    SELECT p.Name, c.Amount, c.Price, c.Sum
    FROM Cart c
        INNER JOIN Products p ON c.ProductId = p.Id
    WHERE c.Id = @CartId;
END
    GO
EXEC GetCart 10

select * from Cart
/* Popularity +5 */
CREATE OR ALTER TRIGGER Popularity_5
ON Products_Cart
AFTER INSERT
AS
BEGIN
    UPDATE Products SET Popularity +=5
    FROM inserted
    WHERE Products.Id = inserted.ProductId
END
GO


/* Popularity +10 */
CREATE OR ALTER TRIGGER Popularity_10
ON Products_Order
AFTER INSERT
AS
BEGIN
    UPDATE Products SET Popularity +=10
    FROM inserted
    WHERE Products.Id = inserted.ProductId
END
GO


/* AdjustCartValues */
CREATE OR ALTER TRIGGER AdjustCartValues
ON Products_Cart
AFTER INSERT, UPDATE
AS
BEGIN
    --calculate sum
    UPDATE Products_Cart SET Products_Cart.Sum = Products_Cart.Amount * Products.Price
    FROM inserted
        INNER JOIN Products ON inserted.ProductId = Products.Id
    WHERE Products_Cart.Id = inserted.Id
    -- check for amount = 0
    DELETE Products_Cart 
    FROM inserted
    WHERE Products_Cart.Id = inserted.Id
        AND Products_Cart.Amount = 0
END
GO


/* CalculateSumOrder */
CREATE OR ALTER TRIGGER CalculateSumOrder
ON Products_Order
AFTER INSERT, UPDATE
AS
BEGIN
    --calculate sum
    UPDATE Products_Order SET Products_Order.Sum = Products_Order.Amount * Products.Price
    FROM inserted
        INNER JOIN Products ON inserted.ProductId = Products.Id
    WHERE Products_Order.Id = inserted.Id
END
GO

DELETE FROM products_order
GO


/* CalculateStockBalance */
CREATE OR ALTER TRIGGER CalculateStockBalance
ON Warehouse
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Warehouse
	SET Warehouse.Available = Warehouse.InStock - Warehouse.Reserved
	FROM inserted
	WHERE Warehouse.Id = inserted.Id
END
GO


/* StandardStockAdjustment */
CREATE OR ALTER TRIGGER StandardStockAdjustment
ON StockTransactions
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE StockTransactions
	SET TransactionId = 2
	WHERE TransactionId IS NULL
END
GO

SELECT *
FROM StockTransactions
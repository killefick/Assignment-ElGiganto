/* Popularity +5 */
CREATE OR ALTER TRIGGER Popularity_5
ON Products_Cart
AFTER INSERT
AS
BEGIN
    UPDATE Products SET Popularity +=5
    FROM inserted
    WHERE Products.Id = inserted.Id
END
GO




/* Popularity +10 */
CREATE OR ALTER TRIGGER Popularity_10
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE Products SET Popularity +=10
    FROM inserted
    WHERE Products.Id = inserted.Id
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




/* UpdateSumOrder */
CREATE OR ALTER TRIGGER UpdateSumOrder
ON Products_Order
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Products_Order SET Sum = inserted.Amount * Products.Price
    FROM inserted
    INNER JOIN Products p
    ON Products_Order.ProductId = p.Id
    WHERE Products_Order.ProductId = inserted.Id
END
GO

select * from orders
select * from Products_Order

/* StockAdjustments */
--DROP TRIGGER Adjust 
--GO

--CREATE TRIGGER Adjust
--ON StockBalance
--AFTER INSERT, UPDATE, DELETE    
--AS
--BEGIN
--    UPDATE Transactions SET Transactions.DateTime = GETDATE()
--                            Transactions.StockChange = inserted.Amount
--    FROM inserted
--END
--GO




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



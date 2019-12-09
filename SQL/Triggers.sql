/* Popularity +5 */
DROP TRIGGER Popularity_5 
GO

CREATE TRIGGER Popularity_5
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
DROP TRIGGER Popularity_10 
GO

CREATE TRIGGER Popularity_10
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE Products SET Popularity +=10
    FROM inserted
    WHERE Products.Id = inserted.Id
END
GO

/* UpdateSumCart */
CREATE OR ALTER TRIGGER UpdateSumCart
ON Cart
AFTER INSERT
AS
BEGIN
    UPDATE Cart SET Sum = Cart.Amount * Cart.Price
    FROM inserted
    WHERE Cart.Id = inserted.Id
END
GO

/* UpdateSumOrder */
CREATE OR ALTER TRIGGER UpdateSumOrder
ON Orders
AFTER INSERT
AS
BEGIN
    UPDATE Orders SET Sum = inserted.Amount * inserted.Price
    FROM inserted
    WHERE Orders.Id = inserted.Id
END
GO

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
ON StockBalance
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	UPDATE StockBalance
	SET StockBalance.Available = StockBalance.InStock - StockBalance.Reserved
	FROM inserted
	WHERE StockBalance.Id = inserted.Id
	
   --     CASE
   --       WHEN StockBalance.Available <= 0 
			--THEN UPDATE Products
			--SET Products.InStock = 0
   --     END
END
GO



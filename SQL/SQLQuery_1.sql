/* UpdateSumCart */
DROP TRIGGER UpdateSumCart 
GO

CREATE TRIGGER UpdateSumCart
ON Cart
AFTER INSERT
AS
BEGIN
    UPDATE Cart SET Sum = inserted.Amount * inserted.Price
    FROM inserted
    WHERE Cart.Id = inserted.Id
END
GO

/* UpdateSumOrder */
Drop TRIGGER UpdateSumOrder
GO

CREATE TRIGGER UpdateSumOrder
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
DROP TRIGGER Adjust 
GO

CREATE TRIGGER Adjust
ON StockBalance
AFTER INSERT, UPDATE, DELETE    
AS
BEGIN
    UPDATE Transactions SET Transactions.DateTime = GETDATE()
                            Transactions.StockChange = inserted.Amount
    FROM inserted
END
GO

/* Lagerstatus */
/* DROP TRIGGER Lagerstatus 
GO

CREATE TRIGGER Lagerstatus
ON StockBalance
AFTER INSERT
AS
BEGIN
    UPDATE Produkter SET Lagerstatus = 0
    FROM inserted
    WHERE inserted.ProduktId = Produkter.Id
END
GO
 */


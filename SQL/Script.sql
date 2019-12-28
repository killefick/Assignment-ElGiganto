/* GetAllProducts */
SELECT *
FROM GetAllProducts

/* ListProductsByCategory */
EXEC ListProductsByCategory 0
--all products
EXEC ListProductsByCategory 1
--products in stock

/* CreateCart & Return CartId */
DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 123456
SELECT @CartIdOut AS CartId

/* Insert into cart */
/* (CartId, ProductId, Amount) */
EXEC InsertIntoCart  22, 15, 1
SELECT *
FROM Warehouse
SELECT Name, Popularity
FROM Products

/* GetCart */
EXEC GetCart 22
SELECT *
FROM Products_Cart
SELECT *
FROM Products_Order

/* CheckoutCart */
/* (@CustomerNumber, CartId */
DECLARE @orderno int;
EXEC CheckoutCart 123456, 22, @OrderNumberToCustomer = @orderno
SELECT @orderno
SELECT *
FROM Warehouse

/* ShipOrder */
EXEC ShipOrder 17
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions

update Warehouse set Reserved = 0 WHERE id = 15

/* Delete carts older than 14 days */
EXEC ClearOldCarts

SELECT *
FROM customers
SELECT *
FROM orders
SELECT *
FROM Carts
SELECT *
FROM Products_Cart
SELECT *
FROM Products_Order
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions
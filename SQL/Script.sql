/* GetAllProducts */
SELECT *
FROM GetAllProducts

/* ListProductsByCategory */
--all products
EXEC ListProductsByCategory 0
--products in stock
EXEC ListProductsByCategory 1

/* Popularitetsrapport */
/* CategoryId */
EXEC CheckPopularity 1

/* CreateCart & Return CartId */
DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 123456
SELECT @CartIdOut AS CartId

/* Insert into cart */
/* (CartId, ProductId, Amount) */
EXEC InsertIntoCart  23, 11, 1
SELECT Name, Popularity
FROM Products

/* GetCart */
EXEC GetCart 23
SELECT *
FROM Products_Cart

/* CheckoutCart */
/* (@CustomerNumber, CartId */
SELECT *
FROM Warehouse
DECLARE @orderno int;
EXEC CheckoutCart 123456, 23
SELECT @orderno
SELECT *
FROM Warehouse

/* ShipOrder */
SELECT *
FROM Orders
SELECT *
FROM Warehouse
EXEC ShipOrder 22
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions


/* StockAdjustment */
/* ProductId, StockChange (Amount), TransactionId  
    (NULL = adjustment, 1 = sold, 2 = returned) */
SELECT *
FROM Warehouse
EXEC StockAdjustment 15, 25
SELECT *
FROM Warehouse

/* ReturnOrder */
/* 
    OrderId
    ProductId
    AmountReturned
    StockChange = NULL if not returned into stock
 */
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions
EXEC ReturnOrder 14, 12, 1
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions

/* TopPopularProducts */
SELECT CategoryName, ProductName, Popularity, Ranking
FROM MostPopular
WHERE Ranking <= 5

/* TopReturnedProducts */
SELECT TOP 5
    *
FROM TopReturnedProducts

/* Delete carts older than 14 days */
EXEC ClearOldCarts

/* ListAllOrdersTotalAmount */
EXEC ListAllOrdersTotalAmount

/* GetTotalAmountOfOrder */
EXEC GetTotalAmountOfOrder 15


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
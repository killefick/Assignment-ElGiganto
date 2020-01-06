/* PRODUKTDATA */

/* Produktlista per kategori och sorterat på popularitet */
SELECT ProductName, Price
FROM GetAllProducts
WHERE IsInStock = 1

SELECT ProductName, Price
FROM GetAllProducts
WHERE IsInStock = 0

/* Produktdetaljer */
SELECT Name, Popularity
FROM Products WHERE Id = 5
EXEC GetProductDetails 5
-- ProductId
SELECT Name, Popularity
FROM Products WHERE Id = 5




/* VARUKORG */

/* Skapa varukorg */
DECLARE @CartIdOut int;
EXEC @CartIdOut = CreateCart 123456
SELECT @CartIdOut AS CartId

/* Lägga i varukorg */
/* Öka popularitet med 5 varje gång någon lägger i varukorgen */
SELECT Name, Popularity
FROM Products
WHERE Id = 2
EXEC InsertIntoCart  36, 2, 1
-- CartId, ProductId, Amount
SELECT Name, Popularity
FROM Products
WHERE Id = 2

/* Hämta varukorg */
SELECT *
FROM Products_Cart
EXEC GetCart 36

/* Ändra varukorg */
-- addera antal
SELECT *
FROM Products_Cart
SELECT Name, Popularity
FROM Products
WHERE Id = 2
EXEC UpdateCart 36, 2, 1
-- CartId, ProductId, Amount
SELECT *
FROM Products_Cart
SELECT Name, Popularity
FROM Products
WHERE Id = 2
SELECT *
FROM Warehouse

-- subtrahera antal
SELECT *
FROM Products_Cart
SELECT Name, Popularity
FROM Products
WHERE Id = 2
EXEC UpdateCart 36, 2, -1
-- CartId, ProductId, Amount
SELECT *
FROM Products_Cart
SELECT Name, Popularity
FROM Products
WHERE Id = 2

/* Checka ut varukorg */
SELECT *
FROM Warehouse
SELECT Name, Popularity
FROM Products
WHERE Id = 2
EXEC CheckoutCart 123456, 36
-- CustomerNumber, CartId 
SELECT *
FROM Products_Order
SELECT *
FROM Warehouse
SELECT Name, Popularity
FROM Products
WHERE Id = 2

/* Rensa gamla varukorgar */
SELECT *
FROM Carts
UPDATE Carts SET DateTimeCreated = '2019-12-14' WHERE Id = 25
EXEC ClearOldCarts
SELECT *
FROM Carts




/* ORDER / LAGER */

/* Leverera order */
SELECT *
FROM Products_Order
SELECT *
FROM Warehouse
EXEC ShipOrder 39
SELECT *
FROM StockTransactions
SELECT *
FROM Products_Order
SELECT *
FROM Warehouse

/* Justera lagret */
/* ProductId, StockChange (Amount), TransactionId  
    (NULL = adjustment, 1 = sold, 2 = returned) */
SELECT *
FROM Warehouse
EXEC StockAdjustment 1, 25
EXEC StockAdjustment 2, -10
EXEC StockAdjustment 3, 5, 2
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions

/* Returnera Order */
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
EXEC ReturnOrder 14, 1, 12, 12
SELECT *
FROM Warehouse
SELECT *
FROM StockTransactions





/* STATISTIK /RAPPORTER */

/* Popularitetsrapport */
SELECT CategoryName, ProductName, Popularity, Ranking
FROM MostPopular
WHERE Ranking <= 5

/* Returrapport */
SELECT TOP 5 Name ProductName, AmountReturned, Ranking FROM TopReturnedProducts

/* Kategorirapport */
EXEC Kategorirapport
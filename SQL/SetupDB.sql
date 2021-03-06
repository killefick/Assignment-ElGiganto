/* Categories */
DROP TABLE Categories
GO

CREATE TABLE Categories
(
    Id int PRIMARY KEY IDENTITY(1,1),
    Name varchar(50) NOT NULL UNIQUE
)

INSERT INTO Categories
    (Name)
VALUES
    ('Jackor')
INSERT INTO Categories
    (Name)
VALUES
    ('Byxor')
INSERT INTO Categories
    (Name)
VALUES
    ('Kjolar')
INSERT INTO Categories
    (Name)
VALUES
    ('Kalsonger')
INSERT INTO Categories
    (Name)
VALUES
    ('Trosor')
GO


/* Products */
DROP TABLE Products
GO

CREATE TABLE Products
(
    Id int PRIMARY KEY IDENTITY(1,1),
    Name varchar(50) NOT NULL,
    ProductDetails varchar(250),
    Price int NOT NULL,
    IsInStock bit NOT NULL DEFAULT 1,
    Popularity int NOT NULL DEFAULT 0,
    CategoryId int REFERENCES Categories(Id)
)
CREATE NONCLUSTERED INDEX IX_Products_CategoryId
      ON Products (CategoryId ASC)

INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('M65', 'US Army replika, varm och stryktålig', 999 , 1)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Kappa', 'svart', 799 , 1)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Bomberjacka', 'olika färger', 499 , 1)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Jeansjacka', 'blå', 199 , 1)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Sammetskappa', 'silver', 1499 , 1)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Jacka', 'svart', 999 , 1)

INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Jeans', 'blå, tight', 899 , 2)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Shorts', 'luftiga och sköna, beige eller gröna', 299 , 2)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Jeans', 'loose fit, olika färger', 399 , 2)

INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Kilkenny', 'inspirerad av de kilten från Skottland', 249 , 3)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Ull', 'lång och mjuk skjol som håller dig varm även vintertid', 299 , 3)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Skinn', 'svart', 399 , 3)

INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Elefanten', 'Namnet som talar för sig självt', 119 , 4)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Shorts', '3-pack, svarta och vita', 159 , 4)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Borat', 'gröna', 299 , 4)

INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Silky Slip', 'Helt osynliga', 129 , 5)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Cotton Candy', 'Mormors favorit', 49 , 5)
INSERT INTO Products
    (Name, ProductDetails, Price, CategoryId)
VALUES('Black velvet', 'Våga vara på mörka sidan', 149 , 5)


/* Warehouse */

DROP TABLE Warehouse
GO

CREATE TABLE Warehouse
(
    Id int PRIMARY KEY IDENTITY(1,1),
    ProductId int NOT NULL REFERENCES Products(Id),
    InStock int NOT NULL DEFAULT 0,
    Reserved int NOT NULL DEFAULT 0,
    Available int

)
CREATE NONCLUSTERED INDEX IX_Warehouse_ProductId
      ON Warehouse (ProductId ASC)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved, Available)
VALUES(1, 100, 0, 100)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(2, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(3, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(4, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(5, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(6, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(7, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(8, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(9, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(10, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(11, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(12, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(13, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(14, 100, 0)

INSERT INTO Warehouse
    (ProductId, InStock, Reserved)
VALUES(15, 100, 0)

GO

/* Products_Cart */
DROP TABLE Products_Cart
GO

CREATE TABLE Products_Cart
(
    Id int PRIMARY KEY IDENTITY(1,1),
    CartId int NOT NULL REFERENCES Carts(Id),
    ProductId int NOT NULL REFERENCES Products(Id),
    Amount int NOT NULL,
    Sum int
)
CREATE NONCLUSTERED INDEX IX_Products_Cart_CartId
      ON Products_Cart (CartId ASC)
CREATE NONCLUSTERED INDEX IX_Products_Cart_ProductId
      ON Products_Cart (ProductId ASC)


/* Carts */
DROP TABLE Carts
GO

CREATE TABLE Carts
(
    Id int PRIMARY KEY IDENTITY(1,1),
    CustomerId int REFERENCES Customers(Id),
    DateTimeCreated datetime DEFAULT GETDATE()
)
CREATE NONCLUSTERED INDEX IX_Carts_CustomerId
      ON Carts (CustomerId ASC)

/* Orders */
DROP TABLE Orders
GO

CREATE TABLE Orders
(
    Id int PRIMARY KEY IDENTITY(1,1),
    CustomerId int REFERENCES Customers(Id),
    CustomerName varchar(100),
    CustomerStreet varchar(100),
    CustomerZip varchar(10),
    CustomerCity varchar(50),
    DateTimeCreated datetime DEFAULT GETDATE()
)
CREATE NONCLUSTERED INDEX IX_Orders_CustomerId
      ON Orders (CustomerId ASC)

/* Products_Order */
DROP TABLE Products_Order
GO

CREATE TABLE Products_Order
(
    Id int PRIMARY KEY IDENTITY(1,1),
    OrderId int REFERENCES Orders(Id),
    ProductId int REFERENCES Products(Id),
    Amount int,
    Sum int,
    AmountReturned int NOT NULL DEFAULT 0,
)
CREATE NONCLUSTERED INDEX IX_Products_Order_OrderId
      ON Products_Order (OrderId ASC)
CREATE NONCLUSTERED INDEX IX_Products_Order_ProductId
      ON Products_Order (ProductId ASC)

/* Customers */
DROP TABLE Customers
GO

CREATE TABLE Customers
(
    Id int PRIMARY KEY IDENTITY(1,1),
    CustomerName varchar(100),
    CustomerNumber int UNIQUE,
    CustomerStreet varchar(100),
    CustomerZip varchar(10),
    CustomerCity varchar(50),
    CustomerPhone varchar(20),
    CustomerEmail varchar(50)
)
GO

INSERT INTO Customers
    (CustomerName, CustomerStreet, CustomerZip, CustomerCity, CustomerPhone, CustomerEmail)
VALUES
    ('Kalle Stropp', 'Sjövägen 34', 12345, 'Sjöbo', '031-123 333 22', 'kalle@stropp.se')
GO

SELECT *
FROM Customers

/* StockTransactions */
DROP TABLE StockTransactions
GO

CREATE TABLE StockTransactions
(
    Id int PRIMARY KEY IDENTITY(1,1),
    /* kan vara null om enbart lagersaldo behöver justeras*/
    OrderId int,
    ProductId int NOT NULL REFERENCES Products(Id),
    StockChange int,
    AmountReturned int,
    DateTimeOfTransaction datetime,
    TransactionId int DEFAULT 2 REFERENCES Transactions(Id)
)
CREATE NONCLUSTERED INDEX IX_StockTransactions_OrderId
      ON StockTransactions (OrderId ASC)
CREATE NONCLUSTERED INDEX IX_StockTransactions_ProductId
      ON StockTransactions (ProductId ASC)

/* Transactions */
DROP TABLE Transactions
GO

CREATE TABLE Transactions
(
    Id int PRIMARY KEY IDENTITY(1,1),
    Name varchar(30)
)
GO

INSERT INTO Transactions
    (Name)
VALUES
    ('Såld')
INSERT INTO Transactions
    (Name)
VALUES
    ('Justering')
INSERT INTO Transactions
    (Name)
VALUES
    ('Retur')

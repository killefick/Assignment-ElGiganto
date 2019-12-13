/* Categories */
DROP TABLE Categories
GO

CREATE TABLE Categories
(
    Id int IDENTITY(1,1),
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
    Id int IDENTITY(1,1),
    Name varchar(50) NOT NULL,
    ProductDetails varchar(250),
    Price int NOT NULL,
    InStock bit NOT NULL DEFAULT 1,
    Popularity int NOT NULL DEFAULT 0,
    /* ska bli foreign key! */
    CategoryId int
)
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
VALUES('Elefanten', 'Nameet som talar för sig självt', 119 , 4)
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


/* StockBalance */

DROP TABLE StockBalance
GO

CREATE TABLE StockBalance
(
    Id int IDENTITY(1,1),
    ProductId int NOT NULL,
    InStock int NOT NULL DEFAULT 0,
    Reserved int NOT NULL DEFAULT 0,
    Available int
)

INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(1, 300, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(2, 300, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(3, 0, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(4, 345, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(4, 33, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(5, 0, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(6, 233, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(7, 0, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(8, 133, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(9, 43, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(10, 3, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(11, 567, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(12, 567, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(13, 24, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(14, 34, 3, 297)
INSERT INTO StockBalance
    (ProductId, InStock, Reserved, Available)
VALUES(15, 24, 3, 297)
GO

/* Products_Cart */
DROP TABLE Products_Cart
GO

CREATE TABLE Products_Cart
(
    Id int IDENTITY(1,1),
    CartId int NOT NULL,
    ProductId int NOT NULL,
    Amount int NOT NULL,
    Sum int
)
-- creates index
CREATE UNIQUE INDEX IX_CartId_ProductId 
      ON Products_Cart (CartId, ProductId ASC)



/* Carts */
DROP TABLE Carts
GO

CREATE TABLE Carts
(
    Id int IDENTITY(1,1),
    CustomerId int UNIQUE,
    DateTimeCreated datetime DEFAULT GETDATE()
)

/* Orders */
DROP TABLE Orders
GO

CREATE TABLE Orders
(
    Id int IDENTITY(1,1),
    CustomerId int,
    CustomerName varchar(100),
    CustomerStreet varchar(100),
    CustomerZip varchar(10),
    CustomerCity varchar(50),
    DateTimeCreated datetime DEFAULT GETDATE()
)

/* Products_Order */
DROP TABLE Products_Order
GO

CREATE TABLE Products_Order
(
    Id int IDENTITY(1,1),
    OrderId int,
    ProductId int,
    Amount int,
    Sum int, 
    AmountReturned int NOT NULL DEFAULT 0,
)

/* Customers */
DROP TABLE Customers
GO

CREATE TABLE Customers
(
    Id int IDENTITY(1,1),
    CustomerName varchar(100),
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

select * from Customers

/* Transactions */
DROP TABLE Transactions
GO

CREATE TABLE Transactions
(
    Id int IDENTITY(1,1),
    /* kan vara null om enbart lagersaldo behöver justeras*/
    OrderId int,
    ProductId int NOT NULL,
    StockChange int NOT NULL,
    DateTime datetime NOT NULL,
    Sum int NOT NULL,
    /* foreign key */
    ReasonId int NOT NULL
)

/* Reasons */
DROP TABLE StockAdjustments
GO

CREATE TABLE StockAdjustments
(
    Id int IDENTITY(1,1),
    Name varchar(30)
)

GO

INSERT INTO Reasons
    (Name)
VALUES
    ('Såld')
INSERT INTO Reasons
    (Name)
VALUES
    ('Justering')
INSERT INTO Reasons
    (Name)
VALUES
    ('Retur')
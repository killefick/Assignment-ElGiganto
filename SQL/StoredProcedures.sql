/* GetAllProducts */
CREATE PROCEDURE GetAllProducts
AS
SELECT k.Namn Kategori, p.Namn Produkt, Pris, Lagerstatus
FROM Produkter p
    INNER JOIN Kategorier k
    ON p.kategoriId = k.Id
GO

EXEC GetAllProducts
GO


/* CreateCart */
DROP PROCEDURE CreateCart
GO

CREATE PROCEDURE CreateCart
    @VarukorgId int OUTPUT
AS
BEGIN
    INSERT INTO Varukorg
        (ProduktId, Antal, Pris)
    VALUES
        (1, 2, 250)

    SET @VarukorgId = CAST(SCOPE_IDENTITY() AS int)
    PRINT @VarukorgId
END
    GO
EXEC CreateCart
GO


/* GetCart */
DROP PROCEDURE GetCart
GO

CREATE PROCEDURE GetCart
AS
BEGIN
    SELECT p.Namn, v.Antal, v.Pris, v.Summa
    FROM Varukorg v
        INNER JOIN Produkter p ON v.ProduktId = p.Id
END
    GO
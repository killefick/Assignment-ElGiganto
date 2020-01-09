CREATE OR ALTER FUNCTION Kategorirapport2()
    RETURNS @Rapport TABLE (
    CategoryName varchar(50),
    Sold_This_Month int,
    Sold_Last_Month int,
    Sold_Last_365 int,
    Returned_This_Month int,
    Returned_Last_Month int,
    Returned_Last_365 int
    )
AS
BEGIN
    INSERT INTO @Rapport
        (CategoryName, Sold_This_Month, Sold_Last_Month)
    SELECT
        stm.Category CategoryName,
        stm.Sold_This_Month,
        slm.Sold_Last_Month
    FROM Sold_This_Month stm
        FULL OUTER JOIN Sold_Last_Month() slm
        ON stm.Category = slm.CategoryName
        FULL OUTER JOIN Sold_Last_365_Days sl365
        ON slm.CategoryName = sl365.Category

    RETURN;
END;
GO
SELECT *
FROM Kategorirapport2()
go
    SELECT
    Category CategoryName, Sold_This_Month
    from Sold_This_Month
    go
    SELECT CategoryName, Sold_Last_Month
    FROM Sold_Last_Month()


-- CREATE FUNCTION Kategorirapport()
--     RETURNS @Rapport TABLE (
--     CategoryName varchar(50),
--     Sold_This_Month int,
--     Sold_Last_Month int,
--     Sold_Last_365 int,
--     Returned_This_Month int,
--     Returned_Last_Month int,
--     Returned_Last_365 int
--     )
-- AS
-- BEGIN
--     insert into @Rapport
--     SELECT
--         Category CategoryName, Sold_This_Month
--     FROM Sold_This_Month
--     insert into @Rapport
--     SELECT CategoryName, Sold_Last_Month
--     FROM Sold_Last_Month()
--     insert into @Rapport
--     SELECT
--         Category CategoryName, Sold_Last_365
--     FROM
--         Sold_Last_365_Days
--     insert into @Rapport
--     SELECT
--         Category CategoryName, Returned_This_Month
--     FROM
--         Returned_This_Month
--     insert into @Rapport
--     SELECT CategoryName, Returned_Last_Month
--     FROM Returned_Last_Month()
--     insert into @Rapport
--     SELECT
--         Category CategoryName, Returned_Last_365
--     FROM
--         Returned_Last_365_Days
--     RETURN;
-- END;

select * from stocktransactions
CREATE OR ALTER VIEW Kategorirapport
AS
(
    SELECT returned_This_Month.Category Cat1, Returned_This_Month, rlm.Category Cat2, Returned_Last_Month
    FROM returned_This_Month
    FULL JOIN returned_Last_month rlm ON rlm.category = returned_this_month.category

)
GO
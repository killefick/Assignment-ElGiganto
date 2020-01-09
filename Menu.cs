using System;
using System.Collections.Generic;

namespace ElGiganto
{
    public enum Choice
    {
        Quit, GetAllProducts, GetProductDetails, MostPopular, ListProductsByCategory,
        InsertIntoCart, ShowCart, EmptyCart, PlaceOrder, ShipOrder,
        PopularityReport, ReturnsReport, CategoryReport
    };

    class Menu
    {
        List<Product> myProductList = new List<Product>();
        List<Product> myCart = new List<Product>();

        public void StartMenu(Product myProduct, DB myDB)
        {
            Random myRandomNumber = new Random();
            int customerNumber = myRandomNumber.Next(100000, 1000000);

            //create customer 
            string query = $"EXEC CreateCustomer {customerNumber}";
            myDB.QueryDB(myDB, query);

            //create cart
            query = $"DECLARE @CartIdOut int; EXEC @CartIdOut = CreateCart {customerNumber}; SELECT @CartIdOut AS CartId";
            int cartId = myDB.QueryDB_ReturnInt(myDB, query);
            int orderId = 0;

            while (true)
            {

                Console.Clear();
                myProductList.Clear();

                Console.WriteLine("Välkommen till ElGiganto13!");
                Console.WriteLine();
                Console.WriteLine($"Kundnummer: {customerNumber}");
                Console.WriteLine($"CartId: {cartId}");
                Console.WriteLine();

                Console.WriteLine(Convert.ToInt32(Choice.GetAllProducts) + ": Visa alla produkter i lagret\n"
                + Convert.ToInt32(Choice.GetProductDetails) + ": Visa produktdetaljer\n"
                + Convert.ToInt32(Choice.MostPopular) + ": Top 5 produkter per kategori\n"
                + Convert.ToInt32(Choice.ListProductsByCategory) + ": Produktlista per kategori och sorterat på popularitet\n"
                + Convert.ToInt32(Choice.InsertIntoCart) + ": Lägg varor i varukorgen\n"
                + Convert.ToInt32(Choice.ShowCart) + ": Visa varukorgen\n"
                + Convert.ToInt32(Choice.EmptyCart) + ": Töm varukorgen\n"
                + Convert.ToInt32(Choice.PlaceOrder) + ": Lägg order\n"
                + Convert.ToInt32(Choice.ShipOrder) + ": Skicka order\n"
                + Convert.ToInt32(Choice.PopularityReport) + ": Popularitetsrapport\n"
                + Convert.ToInt32(Choice.ReturnsReport) + ": Returrapport\n"
                + Convert.ToInt32(Choice.CategoryReport) + ": Kategorirapport\n"

                + Convert.ToInt32(Choice.Quit) + ": Avsluta\n");

                Console.Write("Gör ett val: ");

                int userChoice = 0;
                try
                {
                    userChoice = TryToConvertToInt(Console.ReadLine());
                }
                catch
                {
                    PressAnyKey();
                    continue;
                }

                Choice enumIndex = SetEnum(userChoice);

                switch (enumIndex)
                {
                    case Choice.GetAllProducts:
                        Console.Clear();
                        query = "SELECT * FROM GetAllProducts";
                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);
                        Console.WriteLine("Visa alla produkter i lagret\n");
                        Console.WriteLine("{0,-20}{1,-20}{2,-20}{3,-20}",
                        "Kategori",
                        "Produkt",
                        "Pris",
                        "Popularitet");
                        Console.WriteLine();
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-20}{1,-20}{2,-20}{3,-20}",
                            product.CategoryName,
                            product.ProductName,
                            product.Price,
                            product.Popularity);
                        }
                        PressAnyKey();
                        break;

                    case Choice.GetProductDetails:
                        Console.Clear();
                        Console.WriteLine("Visa produktdetaljer");
                        Console.WriteLine();
                        Console.Write("Ange index på produkten: ");
                        int input = 0;
                        string userinput = Console.ReadLine();
                        try
                        {
                            input = Int32.Parse(userinput);
                        }
                        catch (System.Exception)
                        {
                            break;
                        }

                        query = "EXEC GetProductDetails " + input;
                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);
                        Console.WriteLine();

                        foreach (var product in myProductList)
                        {
                            Console.WriteLine($"Kategori: {product.CategoryName}\nProdukt: {product.ProductName}\nPris: {product.Price}\nI lager: {product.IsInStock}\nPopularitet: {product.Popularity}");
                        }

                        PressAnyKey();
                        break;

                    case Choice.MostPopular:
                        Console.Clear();
                        query = "SELECT CategoryName, ProductName, Popularity, Ranking FROM MostPopular WHERE Ranking <= 5";
                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);
                        Console.WriteLine("Top 5 produkter per kategori\n");


                        Console.WriteLine("{0,-20}{1,-20}{2,-20}{3,-20}",
                        "Kategori",
                        "Produkt",
                        "Popularitet",
                        "Rangordning\n");

                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-20}{1,-20}{2,-20}{3,-20}",
                            product.CategoryName,
                            product.ProductName,
                            product.Popularity,
                            product.Ranking);
                        }
                        PressAnyKey();
                        break;

                    case Choice.ListProductsByCategory:
                        Console.Clear();

                        Console.WriteLine("Produktlista per kategori och sorterat på popularitet\n");
                        Console.Write("Vill du se [a]lla produkter eller de som finns i [l]ager? ");
                        userinput = Console.ReadLine();
                        switch (userinput)
                        {
                            case "a":
                                input = 0;
                                break;

                            case "l":
                                input = 1;
                                break;
                            default:
                                input = 0;
                                break;
                        }
                        query = $"EXEC ListProductsByCategory {input}";

                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query, input);
                        Console.WriteLine();
                        Console.WriteLine("{0,-20}{1,-20}{2,-20}",
                         "Produktnamn",
                         "Pris",
                         "Popularitet\n");

                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-20}{1,-20}{2,-20}",
                            product.CategoryName,
                            product.ProductName,
                            product.Popularity);
                        }
                        Console.WriteLine();
                        Console.WriteLine("Antal produkter: " + this.myProductList.Count);
                        PressAnyKey();
                        break;


                    case Choice.InsertIntoCart:
                        Console.WriteLine("Lägg varor i varukorgen\n");
                        query = "SELECT * FROM GetAllProducts";
                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);
                        while (true)
                        {
                            Product tempProduct = new Product();
                            Console.Clear();
                            int productId = 0;
                            int amount = 0;

                            Console.WriteLine("{0,-5}{1,-20}{2,-20}{3,-20}{4,-20}",
                                                   "Id",
                                                   "Kategori",
                                                   "Produkt",
                                                   "Pris",
                                                   "Popularitet");

                            foreach (var product in this.myProductList)
                            {
                                Console.WriteLine("{0,-5}{1,-20}{2,-20}{3,-20}{3,-20}",
                                product.Id,
                                product.CategoryName,
                                product.ProductName,
                                product.Price,
                                product.Popularity);
                            }
                            Console.WriteLine();
                            Console.Write("Vilken produkt ska läggas till varukorgen (ange Id) eller tryck valfri tangent för att avbryta: ");
                            userinput = Console.ReadLine().ToLower();

                            try
                            {
                                productId = Int32.Parse(userinput);
                            }
                            catch (System.Exception)
                            {
                                break;
                            }

                            if (this.myProductList.Count >= productId)
                            {
                                Console.Write("Ange antal eller tryck valfri tangent för att avbryta: ");
                            }

                            else
                            {
                                Console.Write("Fel Id");
                                Console.ReadLine();
                                break;
                            }

                            try
                            {
                                amount = Int32.Parse(Console.ReadLine());
                            }
                            catch (System.Exception)
                            {
                                break;
                            }

                            tempProduct.Id = productId;
                            tempProduct.Amount = amount;
                            myCart.Add(tempProduct);
                            tempProduct = null;
                        }
                        break;

                    case Choice.ShowCart:
                        foreach (var product in myCart)
                        {
                            Console.WriteLine("Produkt Id " + product.Id + " Antal: " + product.Amount);
                        }
                        Console.ReadLine();
                        break;

                    case Choice.EmptyCart:
                        myCart.Clear();
                        break;

                    case Choice.PlaceOrder:
                        if (myCart.Count != 0)
                        {
                            foreach (var product in myCart)
                            {
                                query = $"EXEC InsertIntoCart {cartId}, {product.Id}, {product.Amount}";
                                myDB.QueryDB(myDB, query);
                            }
                            query = $"EXEC CheckoutCart {customerNumber}, {cartId}";
                            myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query, customerNumber, cartId);

                            Console.WriteLine("Tack för din order! Ditt ordernummer är " + myProductList[0].OrderNumber + ".");
                            orderId = myProductList[0].OrderId;
                            myCart.Clear();
                        }

                        else
                        {
                            Console.WriteLine("Varukorgen är tom");
                        }
                        PressAnyKey();
                        break;

                    case Choice.ShipOrder:
                        query = $"EXEC Shiporder {orderId}";
                        myDB.QueryDB(myDB, query);
                        Console.WriteLine("Ordern är skickad.");
                        PressAnyKey();
                        break;

                    case Choice.PopularityReport:
                        query = "SELECT CategoryName, ProductName, Popularity, Ranking FROM MostPopular WHERE Ranking <= 5";
                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-20}{1,-20}{2,-20}{3,-20}",
                        "Kategori",
                        "Produkt",
                        "Popularitet",
                        "Rangordning");

                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-20}{1,-20}{2,-20}{3,-20}",
                            product.CategoryName,
                            product.ProductName,
                            product.Popularity,
                            product.Ranking);
                        }
                        PressAnyKey();
                        break;

                    case Choice.ReturnsReport:
                        query = "SELECT TOP 5 Name ProductName, AmountReturned, Ranking FROM TopReturnedProducts";
                        this.myProductList = myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-20}{1,-20}{2,-20}",
                        "Produkt",
                        "Antal returnerad",
                        "Rangordning");

                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-20}{1,-20}{2,-20}",
                            product.ProductName,
                            product.AmountReturned,
                            product.Ranking);
                        }
                        PressAnyKey();
                        break;

                    case Choice.CategoryReport:
                        Console.Clear();
                        myProductList.Clear();
                        query = "SELECT Category CategoryName, Sold_This_Month FROM Sold_This_Month";
                        myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-15}{1,-15}",
                        "Kategori",
                        "Såld denna månad");
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-15}{1,-15}",
                            product.CategoryName,
                            product.Sold_This_Month);
                        }
                        Console.WriteLine();

                        myProductList.Clear();
                        query = "SELECT CategoryName, Sold_Last_Month FROM Sold_Last_Month()";
                        myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-15}{1,-15}",
                        "Kategori",
                        "Såld förra månad");
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-15}{1,-15}",
                            product.CategoryName,
                            product.Sold_Last_Month);
                        }
                        Console.WriteLine();

                        myProductList.Clear();
                        query = "SELECT Category CategoryName, Sold_Last_365 FROM Sold_Last_365_Days";
                        myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-15}{1,-15}",
                        "Kategori",
                        "Såld senaste 365 dagar");
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-15}{1,-15}",
                            product.CategoryName,
                            product.Sold_Last_365);
                        }
                        Console.WriteLine();

                        myProductList.Clear();
                        query = "SELECT Category CategoryName, Returned_This_Month FROM Returned_This_Month";
                        myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-15}{1,-15}",
                        "Kategori",
                        "Returnerad denna månad");
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-15}{1,-15}",
                            product.CategoryName,
                            product.Returned_This_Month);
                        }
                        Console.WriteLine();

                        myProductList.Clear();
                        query = "SELECT CategoryName, Returned_Last_Month FROM Returned_Last_Month()";
                        myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-15}{1,-15}",
                        "Kategori",
                        "Returnerad förra månad");
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-15}{1,-15}",
                            product.CategoryName,
                            product.Returned_Last_Month);
                        }
                        Console.WriteLine();

                        myProductList.Clear();
                        query = "SELECT Category CategoryName, Returned_Last_365 FROM Returned_Last_365_Days";
                        myProduct.QueryDB_ReturnList(this.myProductList, myDB, query);

                        Console.WriteLine("{0,-15}{1,-15}",
                        "Kategori",
                        "Returnerad senaste 365 dagar");
                        foreach (var product in this.myProductList)
                        {
                            Console.WriteLine("{0,-15}{1,-15}",
                            product.CategoryName,
                            product.Returned_Last_365);
                        }
                        Console.WriteLine();
                        PressAnyKey();
                        break;

                    case Choice.Quit:
                        return;

                    default:
                        Console.WriteLine("Mata in en siffra mellan "
                        + Convert.ToInt32(Choice.GetAllProducts) + " och "
                        + Convert.ToInt32(Choice.Quit) + "!");
                        PressAnyKey();
                        break;
                }
            }
        }



        public void PressAnyKey()
        {
            Console.Write("Press any key...");
            Console.ReadKey();
        }

        public int TryToConvertToInt(string input)
        {
            int result = 0;
            try
            {
                result = Convert.ToInt32(input);
            }
            catch (FormatException ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }
            return result;
        }

        Choice SetEnum(int input)
        {
            Choice enumToCast = (Choice)input;
            return enumToCast;
        }
    }
}
using System;
using System.Collections.Generic;

namespace ElGiganto
{
    public enum Choice
    {
        Quit, GetAllProducts, MostPopular, ListProductsByCategory,
        InsertIntoCart, ShowCart, EmptyCart, PlaceOrder, ShipOrder
    };

    class Menu
    {
        List<Product> myProductListFromDB = new List<Product>();
        List<Product> myCart = new List<Product>();

        public void StartMenu(Product myProduct, DB myDB)
        {
            // default user choice
            int choice = 0;
            int cartID = 0;
            string query = "";
            Random myRandomNumber = new Random();
            int customerNumber = myRandomNumber.Next(100000, 1000000);
            myDB.CreateCustomer(customerNumber);
            cartID = myProduct.CreateCart(myProductListFromDB, myDB, customerNumber);


            while (true)
            {
                Console.Clear();
                myProductListFromDB.Clear();

                System.Console.WriteLine($"Kundnummer: {customerNumber}");
                System.Console.WriteLine($"CartId: {cartID}");

                Console.WriteLine(Convert.ToInt32(Choice.GetAllProducts) + ": Visa alla produkter i lagret\n"
                + Convert.ToInt32(Choice.MostPopular) + ": Top 5 produkter per kategori\n"
                + Convert.ToInt32(Choice.ListProductsByCategory) + ": Produktlista per kategori och sorterat på popularitet\n"
                + Convert.ToInt32(Choice.InsertIntoCart) + ": Lägg varor i varukorgen\n"
                + Convert.ToInt32(Choice.ShowCart) + ": Visa varukorgen\n"
                + Convert.ToInt32(Choice.EmptyCart) + ": Töm varukorgen\n"
                + Convert.ToInt32(Choice.PlaceOrder) + ": Lägg order\n"
                + Convert.ToInt32(Choice.ShipOrder) + ": Skicka order\n"

                + Convert.ToInt32(Choice.Quit) + ": Avsluta\n");

                Console.Write("Gör ett val: ");

                try
                {
                    choice = TryToConvertToInt(Console.ReadLine());
                }
                catch
                {
                    PressAnyKey();
                    continue;
                }

                Choice enumIndex = SetEnum(choice);

                switch (enumIndex)
                {
                    case Choice.GetAllProducts:
                        Console.Clear();
                        query = "SELECT * FROM GetAllProducts";
                        myProductListFromDB = myProduct.QueryReturnList(myProductListFromDB, myDB, query);

                        Console.WriteLine("Produktkategori\t          Produktnamn\t          Pris\t          Popularitet");
                        foreach (var product in myProductListFromDB)
                        {
                            Console.WriteLine($"{product.CategoryName}\t          {product.ProductName}\t          {product.Price}\t          {product.Popularity}");
                        }
                        PressAnyKey();
                        break;

                    case Choice.MostPopular:
                        Console.Clear();
                        query = "SELECT CategoryName, ProductName, Popularity, Ranking FROM MostPopular WHERE Ranking <= 5";
                        myProductListFromDB = myProduct.QueryReturnList(myProductListFromDB, myDB, query);
                        Console.WriteLine("Produktkategori\t Produktnamn\t Popularitet \t  Rangordning");
                        foreach (var product in myProductListFromDB)
                        {
                            Console.WriteLine($"{product.CategoryName}\t {product.ProductName}\t {product.Popularity}\t {product.Ranking}");
                        }
                        PressAnyKey();
                        break;

                    case Choice.ListProductsByCategory:
                        Console.Clear();
                        System.Console.WriteLine("Vill du se [a]lla produkter eller de som finns i [l]ager?");
                        string userinput = Console.ReadLine();
                        int input;
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

                        myProductListFromDB = myProduct.QueryReturnList(myProductListFromDB, myDB, query, input);

                        Console.WriteLine("Antal produkter: " + myProductListFromDB.Count);
                        Console.WriteLine("Produktnamn\t Pris \t  Rangordning");
                        foreach (var product in myProductListFromDB)
                        {
                            Console.WriteLine($"{product.ProductName}\t {product.Price}\t {product.Popularity}");
                        }
                        PressAnyKey();
                        break;


                    case Choice.InsertIntoCart:
                        query = "SELECT * FROM GetAllProducts";
                        myProductListFromDB = myProduct.QueryReturnList(myProductListFromDB, myDB, query);
                        while (true)
                        {
                            Product tempProduct = new Product();
                            Console.Clear();
                            int productId = 0;
                            int amount = 0;
                            Console.WriteLine("Id \t\t Produktkategori   \t Produktnamn \t\t\t      Pris \t\t  Popularitet");
                            foreach (var product in myProductListFromDB)
                            {
                                Console.WriteLine($"{product.Id} \t\t {product.CategoryName}   \t\t {product.ProductName} \t\t\t      {product.Price} \t\t {product.Popularity}");
                            }
                            System.Console.Write("Vilken produkt ska läggas till varukorgen (ange Id) eller tryck valfri tangent för att avbryta: ");
                            userinput = Console.ReadLine().ToLower();

                            try
                            {
                                productId = Int32.Parse(userinput);
                            }
                            catch (System.Exception)
                            {
                                break;
                            }

                            if (myProductListFromDB.Count >= productId)
                            {
                                System.Console.Write("Ange antal eller tryck valfri tangent för att avbryta: ");
                            }

                            else
                            {
                                System.Console.Write("Fel Id");
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
                            System.Console.WriteLine("Produkt Id " + product.Id + " Antal: " + product.Amount);
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
                                myDB.InsertIntoCart(cartID, product.Id, product.Amount);
                            }
                            int orderNumber = myProduct.CheckOutCart(myProductListFromDB, myDB, customerNumber, cartID);
                            System.Console.WriteLine("Tack för din order! Ditt ordernummer är " + orderNumber + ".");
                            myCart.Clear();
                        }

                        else
                        {
                            System.Console.WriteLine("Varukorgen är tom");
                        }

                        Console.ReadLine();
                        break;

                    case Choice.ShipOrder:
                        myDB.ShipOrder(cartID);
                        Console.WriteLine("Ordern är skickad.");
                        Console.ReadLine();
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
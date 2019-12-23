using System;
using System.Collections.Generic;

namespace ElGiganto
{
    public enum Choice { Quit, GetAllProducts, MostPopular, ListProductsByCategory, CreateCart, InsertIntoCart, ShowCart, PlaceOrder };

    class Menu
    {
        List<Product> myProductListFromDB = new List<Product>();
        List<Product> myCart = new List<Product>();

        public void StartMenu(Product myProduct, DB myDB)
        {
            // default user choice
            int choice = 0;
            int cartIdOut = 0;
            Random myRandomNumber = new Random();
            int customerNumber = myRandomNumber.Next(100000, 1000000);
            myDB.CreateCustomer(customerNumber);
            
            while (true)
            {
                Console.Clear();
                myProductListFromDB.Clear();

                System.Console.WriteLine($"Kundnummer: {customerNumber}");
                System.Console.WriteLine($"CartId: {cartIdOut}");

                Console.WriteLine(Convert.ToInt32(Choice.GetAllProducts) + ": Visa alla produkter i lagret\n"
                + Convert.ToInt32(Choice.MostPopular) + ": Top 5 produkter per kategori\n"
                + Convert.ToInt32(Choice.ListProductsByCategory) + ": Produktlista per kategori och sorterat på popularitet\n"
                + Convert.ToInt32(Choice.CreateCart) + ": Skapa varukorg\n"
                + Convert.ToInt32(Choice.InsertIntoCart) + ": Lägg varor i varukorgen\n"
                + Convert.ToInt32(Choice.ShowCart) + ": Visa varukorgen\n"
                + Convert.ToInt32(Choice.PlaceOrder) + ": Lägg order\n"

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
                        myProductListFromDB = myProduct.GetAllProducts(myProductListFromDB, myDB);
                        Console.WriteLine("Produktkategori\t Produktnamn\t Pris \t  Popularitet");
                        foreach (var product in myProductListFromDB)
                        {
                            Console.WriteLine($"{product.CategoryName}\t {product.ProductName}\t {product.Price}\t {product.Popularity}");
                        }
                        PressAnyKey();
                        break;

                    case Choice.MostPopular:
                        Console.Clear();
                        myProductListFromDB = myProduct.MostPopular(myProductListFromDB, myDB);
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

                        myProductListFromDB = myProduct.ListProductsByCategory(myProductListFromDB, myDB, input);

                        Console.WriteLine("Antal produkter: " + myProductListFromDB.Count);
                        Console.WriteLine("Produktnamn\t Pris \t  Rangordning");
                        foreach (var product in myProductListFromDB)
                        {
                            Console.WriteLine($"{product.ProductName}\t {product.Price}\t {product.Popularity}");
                        }
                        PressAnyKey();
                        break;

                    case Choice.CreateCart:
                        Console.Clear();
                        cartIdOut = myProduct.CreateCart(myProductListFromDB, myDB, customerNumber);
                        System.Console.WriteLine("Varukorg skapad.");
                        PressAnyKey();
                        break;

                    case Choice.InsertIntoCart:
                        myProductListFromDB = myProduct.GetAllProducts(myProductListFromDB, myDB);
                        while (true)
                        {
                            Product tempProduct = new Product();
                            Console.Clear();
                            int productId = 0;
                            Console.WriteLine("Id \t\t Produktkategori   \t Produktnamn \t\t Pris \t\t  Popularitet");
                            foreach (var product in myProductListFromDB)
                            {
                                Console.WriteLine($"{product.Id} \t\t {product.CategoryName}   \t\t {product.ProductName} \t\t\t {product.Price} \t\t {product.Popularity}");
                            }
                            System.Console.Write("Vilken produkt ska läggas till varukorgen (ange Id) eller [a]vbryt: ");
                            userinput = Console.ReadLine().ToLower();
                            if (userinput == "a")
                            {
                                break;
                            }
                            else
                            {
                                productId = Int32.Parse(userinput);
                            }
                            System.Console.Write("Ange antal: ");
                            int amount = Int32.Parse(Console.ReadLine());

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

                    case Choice.PlaceOrder:
                        foreach (var product in myCart)
                        {
                            myDB.InsertIntoCart(cartIdOut, product.Id, product.Amount);
                        }
                       myDB.CheckOutCart(customerId, cartId);


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
using System;
using System.Collections.Generic;

namespace ElGiganto
{
    public enum Choice { Quit, GetAllProducts, MostPopular, ListProductsByCategory };

    class Menu
    {
        List<Product> myProductList = new List<Product>();

        public void StartMenu(Product myProduct, DB myDB)
        {
            // default user choice
            int choice = 0;

            while (true)
            {
                Console.Clear();
                myProductList.Clear();

                Console.WriteLine(Convert.ToInt32(Choice.GetAllProducts) + ": Visa alla produkter i lagret\n"
                + Convert.ToInt32(Choice.MostPopular) + ": Top 5 produkter per kategori\n"
                + Convert.ToInt32(Choice.ListProductsByCategory) + ": Produktlista per kategori och sorterat på popularitet\n"

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
                        myProductList = myProduct.GetAllProducts(myProductList, myDB);
                        Console.WriteLine("Produktkategori\t Produktnamn\t Pris \t  Popularitet");
                        foreach (var product in myProductList)
                        {
                            Console.WriteLine($"{product.CategoryName}\t {product.ProductName}\t {product.Price}\t {product.Popularity}");
                        }
                        PressAnyKey();
                        break;

                    case Choice.MostPopular:
                        Console.Clear();
                        myProductList = myProduct.MostPopular(myProductList, myDB);
                        Console.WriteLine("Produktkategori\t Produktnamn\t Popularitet \t  Rangordning");
                        foreach (var product in myProductList)
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
                                input = 1;
                                break;

                            case "l":
                                input = 0;
                                break;
                            default:
                                input = 1;
                                break;
                        }

                        myProductList = myProduct.ListProductsByCategory(myProductList, myDB, input);
                        Console.WriteLine("Produktnamn\t Pris \t  Rangordning");
                        foreach (var product in myProductList)
                        {
                            Console.WriteLine($"{product.ProductName}\t {product.Price}\t {product.Popularity}");
                        }
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
using System;
using System.Collections.Generic;

namespace ElGiganto
{
    public enum Choice { Quit, GetAllProducts };

    class Menu
    {
        List<Product> myProductList = new List<Product>();

        public void StartMenu(Product myProduct, DB myDB)
        {
            // default user choice
            int choice = 0;
            // default result from methods
            // int result = 0;

            while (true)
            {
                Console.Clear();
                myProductList.Clear();
                
                Console.WriteLine(Convert.ToInt32(Choice.GetAllProducts) + ": Visa alla produkter i lagret\n"
                // + Convert.ToInt32(Choice.CountAllProducts) + ": Visa antal hundar i databas\n"
                // + Convert.ToInt32(Choice.CountVeterinaryData) + ": Visa antal veterinärdata i databas\n"
                // + Convert.ToInt32(Choice.GetDogInfo) + ": Visa hundinfo för Hund med Id 9 (Fantasia Li)\n"
                // + Convert.ToInt32(Choice.GetSyblings) + ": Visa syskonpar\n"
                // + Convert.ToInt32(Choice.SearchOwner) + ": Leta efter ägare\n"
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
                            Console.WriteLine("Produktnamn \t\t\t Detaljer \t\t\t Pris \t\t\t Popularitet");
                        foreach (var product in myProductList)
                        {
                            Console.WriteLine($"{product.Category} \t\t\t {product.Name} \t\t\t {product.Price}");
                        }
                        PressAnyKey();
                        break;

                    // case Choice.CountAllProducts:
                    //     result = myProduct.CountAllProducts();
                    //     Console.WriteLine("Antal hundar i databas: " + result);
                    //     PressAnyKey();

                    //     break;

                    // case Choice.CountVeterinaryData:
                    //     result = myProduct.CountVeterinaryData();
                    //     Console.WriteLine("Antal veterinärdata i databas: " + result);
                    //     PressAnyKey();
                    //     break;

                    // case Choice.GetDogInfo:
                    //     myProduct.GetDogInfo(9);
                    //     PressAnyKey();
                    //     break;

                    // case Choice.GetSyblings:
                    //     myProduct.GetSyblings();
                    //     PressAnyKey();
                    //     break;

                    // case Choice.SearchOwner:
                    //     O.SearchOwner();
                    //     PressAnyKey();
                    //     break;

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
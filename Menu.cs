using System;
namespace ElGiganto
{
    public enum Choice { Quit, GetAllDogs, CountAllDogs, CountVeterinaryData, GetDogInfo, GetSyblings, SearchOwner };

    class Menu
    {
        public void StartMenu(Dog D, Owner O)
        {
            // default user choice
            int choice = 0;
            // default result from methods
            int result = 0;

            while (true)
            {
                Console.Clear();
                Console.WriteLine(Convert.ToInt32(Choice.GetAllDogs) + ": Visa alla hundar\n"
                + Convert.ToInt32(Choice.CountAllDogs) + ": Visa antal hundar i databas\n"
                + Convert.ToInt32(Choice.CountVeterinaryData) + ": Visa antal veterinärdata i databas\n"
                + Convert.ToInt32(Choice.GetDogInfo) + ": Visa hundinfo för Hund med Id 9 (Fantasia Li)\n"
                + Convert.ToInt32(Choice.GetSyblings) + ": Visa syskonpar\n"
                + Convert.ToInt32(Choice.SearchOwner) + ": Leta efter ägare\n"
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
                    case Choice.GetAllDogs:
                        D.GetAllDogs();
                        PressAnyKey();
                        break;

                    case Choice.CountAllDogs:
                        result = D.CountAllDogs();
                        Console.WriteLine("Antal hundar i databas: " + result);
                        PressAnyKey();

                        break;

                    case Choice.CountVeterinaryData:
                        result = D.CountVeterinaryData();
                        Console.WriteLine("Antal veterinärdata i databas: " + result);
                        PressAnyKey();
                        break;

                    case Choice.GetDogInfo:
                        D.GetDogInfo(9);
                        PressAnyKey();
                        break;

                    case Choice.GetSyblings:
                        D.GetSyblings();
                        PressAnyKey();
                        break;

                    case Choice.SearchOwner:
                        O.SearchOwner();
                        PressAnyKey();
                        break;

                    case Choice.Quit:
                        return;

                    default:
                        Console.WriteLine("Mata in en siffra mellan "
                        + Convert.ToInt32(Choice.GetAllDogs) + " och "
                        + Convert.ToInt32(Choice.GetSyblings) + "!");
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
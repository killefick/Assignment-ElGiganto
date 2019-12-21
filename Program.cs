using System;

namespace ElGiganto
{
    class Program
    {
        static void Main(string[] args)
        {
            Menu myMenu = new Menu();
            Product myProduct = new Product();
            DB myDB = new DB();
            myMenu.StartMenu(myProduct, myDB);
        }
    }
}

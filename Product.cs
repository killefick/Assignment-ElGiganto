using System.Collections.Generic;
using System;

namespace ElGiganto
{
    public class Product
    {
        public string ProductName { get; set; }
        public string CategoryName { get; set; }
        public string ProductDetails { get; set; }

        public int CategoryId { get; set; }
        public int Price { get; set; }
        public int Popularity { get; set; }
        public int Ranking { get; set; }

        public bool IsInStock { get; set; }

        public List<Product> GetAllProducts(List<Product> myProductList, DB myDB)
        {
            foreach (var product in myDB.GetAllProductsFromDB())
            {
                myProductList.Add(product);
            }
            return myProductList;
        }
       
        public List<Product> MostPopular(List<Product> myProductList, DB myDB)
        {
            foreach (var product in myDB.MostPopularFromDB())
            {
                myProductList.Add(product);
            }
            return myProductList;
        }

        public List<Product> ListProductsByCategory(List<Product> myProductList, DB myDB, int input)
        {
            foreach (var product in myDB.ListProductsByCategoryFromDB(input))
            {
                myProductList.Add(product);
            }
            return myProductList;
        }
    }
}
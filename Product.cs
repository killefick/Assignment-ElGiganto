using System.Collections.Generic;
using System;

namespace ElGiganto
{
    public class Product
    {
        public string Name { get; set; }
        public string ProductDetails { get; set; }
        public string Category { get; set; }

        public int Price { get; set; }
        public int Popularity { get; set; }
        public int CategoryId { get; set; }

        public bool IsInStock { get; set; }

        public List<Product> GetAllProducts(List<Product> myProductList, DB myDB)
        {
            foreach (var product in myDB.GetAllProductsFromDB())
            {
                myProductList.Add(product);
            }
            return myProductList;
        }
    }
}
using System.Collections.Generic;
using System;

namespace ElGiganto
{
    public class Product
    {
        public string ProductName { get; set; }
        public string CategoryName { get; set; }
        public string ProductDetails { get; set; }

        public int OrderNumber { get; set; }
        public int CustomerId { get; set; }
        public int CustomerNumber { get; set; }
        public int CategoryId { get; set; }
        public int Price { get; set; }
        public int Popularity { get; set; }
        public int Ranking { get; set; }
        public int CartId { get; set; }
        public int Id { get; set; }
        public int Amount { get; set; }

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

        public int CreateCart(List<Product> myProductList, DB myDB, int customerNumber)
        {
            int cartIdOut = 0;
            foreach (var product in myDB.CreateCartOnDB(customerNumber))
            {
                myProductList.Add(product);
            }
            cartIdOut = myProductList[0].CartId;
            return cartIdOut;
        }

    }
}
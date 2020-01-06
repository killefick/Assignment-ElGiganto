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
        public int AmountReturned { get; set; }
        public int Sold_This_Month { get; set; }
        public int Returned_This_Month { get; set; }
        public int Sold_Last_Month { get; set; }
        public int Returned_Last_Month { get; set; }
        public int Sold_Last_365 { get; set; }
        public int Returned_Last_365 { get; set; }

        public bool IsInStock { get; set; }

        public List<Product> QueryDB_ReturnList(List<Product> myProductList, DB myDB, string query)
        {
            foreach (var product in myDB.QueryDB_ReturnIEnumerable(query))
            {
                myProductList.Add(product);
            }
            return myProductList;
        }

        public List<Product> QueryDB_ReturnList(List<Product> myProductList, DB myDB, string query, int input)
        {

            foreach (var product in myDB.QueryDB_ReturnIEnumerable(query, input))
            {
                myProductList.Add(product);
            }
            return myProductList;
        }
    }
}
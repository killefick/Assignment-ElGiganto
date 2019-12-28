using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using Dapper;

namespace ElGiganto
{
    public class DB

    {
        private readonly string connectionString;

        // constructor
        public DB()
        {
            this.connectionString = "Server=40.85.84.155;Database=ELGIGANTO13;User=Student13;Password=YH-student@2019;";
        }
        // public method to call from application
        // IEnumerable: allows looping over generic or non-generic lists
        public IEnumerable<Product> GetAllProductsFromDB()
        {
            try
            {
                // connects to the database
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>("SELECT * FROM GetAllProducts");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public dynamic CreateCustomer(int customerNumber)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<dynamic>($"EXEC CreateCustomer {customerNumber} ");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public IEnumerable<Product> MostPopularFromDB()
        {
            try
            {
                // connects to the database
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>("SELECT CategoryName, ProductName, Popularity, Ranking FROM MostPopular WHERE Ranking <= 5");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public IEnumerable<Product> ListProductsByCategoryFromDB(int input)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>($"EXEC ListProductsByCategory {input}");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public IEnumerable<Product> CreateCartOnDB(int customerNumber)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>($"DECLARE @CartIdOut int; EXEC @CartIdOut = CreateCart {customerNumber}; SELECT @CartIdOut AS CartId");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public void InsertIntoCart(int cartIdOut, int productId, int amount)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Query($"EXEC InsertIntoCart  {cartIdOut}, {productId}, {amount}");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }


        public IEnumerable<Product> CheckOutCartOnDB(int customerNumber, int cartIdOut)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>($"DECLARE @orderno int; EXEC CheckoutCart {customerNumber}, {cartIdOut}, @OrderNumberToCustomer = @orderno; SELECT @orderno OrderNumber");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

       
    }
}

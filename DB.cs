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

        //     public int CountAllProductsDB()
        //     {
        //         try
        //         {
        //             // connects to the database
        //             using (SqlConnection connection = new SqlConnection(connectionString))
        //             {
        //                 int result = 0;
        //                 string sql = "EXEC CountAllProducts";
        //                 SqlCommand cmd = new SqlCommand(sql, connection);
        //                 try
        //                 {
        //                     connection.Open();
        //                     result = (Int32)cmd.ExecuteScalar();
        //                 }
        //                 catch (Exception ex)
        //                 {
        //                     Console.WriteLine(ex.Message);
        //                 }
        //                 return result;
        //             }
        //         }
        //         catch (System.Exception)
        //         {
        //             throw;
        //         }
        //     }

        //     public int CountVeterinaryInfoDB()
        //     {
        //         try
        //         {
        //             using (SqlConnection connection = new SqlConnection(connectionString))
        //             {
        //                 int result = 0;
        //                 string sql = "EXEC CountVeterinaryData";
        //                 SqlCommand cmd = new SqlCommand(sql, connection);
        //                 try
        //                 {
        //                     connection.Open();
        //                     result = (Int32)cmd.ExecuteScalar();
        //                 }
        //                 catch (Exception ex)
        //                 {
        //                     Console.WriteLine(ex.Message);
        //                 }
        //                 return result;
        //             }

        //         }
        //         catch (System.Exception)
        //         {
        //             throw;
        //         }
        //     }


        //     public IEnumerable<Product> GetProductInfoDB(int id)
        //     {
        //         try
        //         {
        //             // connects to the database
        //             using (SqlConnection connection = new SqlConnection(connectionString))
        //             {
        //                 return connection.Query<Product>($"EXEC GetProductInfo {id}");
        //             }

        //         }
        //         catch (System.Exception)
        //         {
        //             throw;
        //         }
        //     }

        //     public IEnumerable<Product> GetSyblingsDB()
        //     {
        //         try
        //         {
        //             // connects to the database
        //             using (SqlConnection connection = new SqlConnection(connectionString))
        //             {
        //                 return connection.Query<Product>($"EXEC GetSyblings");
        //             }

        //         }
        //         catch (System.Exception)
        //         {
        //             throw;
        //         }
        //     }

        //     public Owner SearchOwnerDB(int id)
        //     {
        //         try
        //         {
        //             using (SqlConnection connection = new SqlConnection(connectionString))
        //             {
        //                 return connection.Query<Owner>($"EXEC FindOwner @Id = 1").First();
        //             }
        //         }
        //         catch (System.Exception)
        //         {
        //             throw;
        //         }
        //     }
        // }

    }
}

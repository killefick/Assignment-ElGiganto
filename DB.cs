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
    }
}
    // public method to call from application
    // IEnumerable: allows looping over generic or non-generic lists
    // public IEnumerable<Dog> GetAllDogsDB()
    // {
    //     try
    //     {
    //         // connects to the database
    //         using (SqlConnection connection = new SqlConnection(connectionString))
    //         {
    //             return connection.Query<Dog>("EXEC GetAllDogs");
    //         }
    //     }
    //     catch (System.Exception)
    //     {
    //         throw;
    //     }
    // }

    //     public int CountAllDogsDB()
    //     {
    //         try
    //         {
    //             // connects to the database
    //             using (SqlConnection connection = new SqlConnection(connectionString))
    //             {
    //                 int result = 0;
    //                 string sql = "EXEC CountAllDogs";
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


    //     public IEnumerable<Dog> GetDogInfoDB(int id)
    //     {
    //         try
    //         {
    //             // connects to the database
    //             using (SqlConnection connection = new SqlConnection(connectionString))
    //             {
    //                 return connection.Query<Dog>($"EXEC GetDogInfo {id}");
    //             }

    //         }
    //         catch (System.Exception)
    //         {
    //             throw;
    //         }
    //     }

    //     public IEnumerable<Dog> GetSyblingsDB()
    //     {
    //         try
    //         {
    //             // connects to the database
    //             using (SqlConnection connection = new SqlConnection(connectionString))
    //             {
    //                 return connection.Query<Dog>($"EXEC GetSyblings");
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

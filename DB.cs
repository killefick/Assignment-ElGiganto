using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using Dapper;

namespace ElGiganto
{
    public class DB
    {
        private readonly string connectionString;

        public DB()
        {
            this.connectionString = "Server=40.85.84.155;Database=ELGIGANTO13;User=Student13;Password=YH-student@2019;";
        }

        public IEnumerable<Product> QueryDB_ReturnIEnumerable(string query)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>(query);
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public IEnumerable<Product> QueryDB_ReturnIEnumerable(string query, int input)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>(query);
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public int QueryDB_ReturnInt(DB myDB, string query)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.QueryFirst<int>(query);
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public int QueryDB_ReturnInt(DB myDB, List<Product> myList, string query, int input1, int input2)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.QueryFirst<int>(query);
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public void QueryDB(DB myDB, string query)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Query(query);
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        // public List<Product> test(List<Product> myList, DB myDB, string query)
        // {
        //     using (SqlConnection connection = new SqlConnection(connectionString))
        //     {
        //         connection.Open();

        //         using (var multi = connection.QueryMultiple(query))
        //         {
        //             var product = multi.Read<Product>().First();
        //             var productList = multi.Read<Product>().ToList();
        //             return productList;
        //         }
        //     }
        // }

    }
}
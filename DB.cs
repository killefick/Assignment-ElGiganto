using System.Collections.Generic;
using System.Data.SqlClient;
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

        public IEnumerable<Product> CheckOutCartOnDB(int customerNumber, int cartIdOut)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    return connection.Query<Product>($"EXEC CheckoutCart {customerNumber}, {cartIdOut}");
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
                    connection.Query($"EXEC InsertIntoCart {cartIdOut}, {productId}, {amount}");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }

        public void ShipOrder(int orderId)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Query($"EXEC Shiporder {orderId}");
                }
            }
            catch (System.Exception)
            {
                throw;
            }
        }
    }
}
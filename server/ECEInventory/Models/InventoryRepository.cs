using System.Collections.Generic;
using MySql.Data.MySqlClient;

namespace ECEInventory.Models
{
    public class InventoryRepository : IInventoryRepository
    {
        private MySqlConnection _conn;
        private string _connectionString;

        public InventoryRepository()
        {
            _connectionString = "server=inventorydb.c3zcn5xm8exo.us-west-2.rds.amazonaws.com;"
                + "uid=inventoryadmin;" + "pwd=eceinventory;" + "database=InventoryDB;";
            _conn = new MySqlConnection();
            _conn.ConnectionString = _connectionString;
        }

        public IEnumerable<User> getAllUsers()
        {
            _conn.Open();
            string sql = "select * from user_table";
            MySqlCommand cmd = new MySqlCommand(sql, _conn);
            MySqlDataReader reader = cmd.ExecuteReader();
            List<User> user_list = new List<User>();
            while (reader.Read())
            {
                user_list.Add(new User { Id = (int)reader[0], Name = (string)reader[1] });
            }
            _conn.Close();
            return user_list;
        }

        public User getUser(int id)
        {
            _conn.Open();
            string sql = "select * from user_table where id = " + id;
            MySqlCommand cmd = new MySqlCommand(sql, _conn);
            MySqlDataReader reader = cmd.ExecuteReader();
            User user = null;
            if (reader.Read())
            {
                user = new User { Id = (int)reader[0], Name = (string)reader[1] };
            }
            _conn.Close();
            return user;
        }

        public IEnumerable<Item> getAllItems()
        {
            _conn.Open();
            string sql = "select * from item_table";
            MySqlCommand cmd = new MySqlCommand(sql, _conn);
            MySqlDataReader reader = cmd.ExecuteReader();
            List<Item> item_list = new List<Item>();
            while (reader.Read())
            {
                item_list.Add(new Item { Id = (int)reader[0], Name = (string)reader[1] });
            }
            _conn.Close();
            return item_list;
        }

        public Item getItem(int id)
        {
            _conn.Open();
            string sql = "select * from item_table where id = " + id;
            MySqlCommand cmd = new MySqlCommand(sql, _conn);
            MySqlDataReader reader = cmd.ExecuteReader();
            Item item = null;
            if (reader.Read())
            {
                item = new Item { Id = (int)reader[0], Name = (string)reader[1] };
            }
            _conn.Close();
            return item;
        }
    }
}
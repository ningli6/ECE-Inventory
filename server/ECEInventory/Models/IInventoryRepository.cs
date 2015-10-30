using System.Collections.Generic;

namespace ECEInventory.Models
{
    public interface IInventoryRepository
    {
        IEnumerable<User> getAllUsers();
        User getUser(int id);
        IEnumerable<Item> getAllItems();
        Item getItem(int id); 
    }
}

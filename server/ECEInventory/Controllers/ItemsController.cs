using ECEInventory.Models;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ECEInventory.Controllers
{
    public class ItemsController : ApiController
    {
        private static readonly IInventoryRepository _repo = new InventoryRepository();

        public IEnumerable<Item> GetAllItems()
        {
            return _repo.getAllItems();
        }

        public Item getItem(int id)
        {
            Item item = _repo.getItem(id);
            if (item == null)
            {
                throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.NotFound));
            }
            return item;
        }
    }
}

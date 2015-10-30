using ECEInventory.Models;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ECEInventory.Controllers
{
    public class UsersController : ApiController
    {
        private static readonly IInventoryRepository _repo = new InventoryRepository();

        public IEnumerable<User> GetAllUsers()
        {
            return _repo.getAllUsers();
        }

        public User getUser(int id)
        {
            User user = _repo.getUser(id);
            if (user == null)
            {
                throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.NotFound));
            }
            return user;
        }
    }
}

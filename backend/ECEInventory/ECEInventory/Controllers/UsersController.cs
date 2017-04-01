using ECEInventory.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;


namespace ECEInventory.Controllers
{
    public class UsersController : ApiController
        {
        private InventoryDBContext db = new InventoryDBContext();
        // GET: Users
        [Route("api/Users")]
        public IQueryable<PID> GetAllUsers() {
            return from r in db.PIDs select r;
        }
    }
}
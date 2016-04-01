using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using ECEInventory.Models;

namespace ECEInventory.Controllers
{
    public class ItemsController : ApiController
    {
        private InventoryDBContext db = new InventoryDBContext();

        // GET: api/Items
        public IQueryable<Item> GetItems()
        {
            return db.Items;
        }

        //// GET: api/Items/5
        //[ResponseType(typeof(Item))]
        //public async Task<IHttpActionResult> GetItem(int id)
        //{
        //    Item item = await db.Items.FindAsync(id);
        //    if (item == null)
        //    {
        //        return NotFound();
        //    }

        //    return Ok(item);
        //}

        // get item by barcode
        [Route("api/Items/{barcode}")]
        public IQueryable<Item> GetItemByBarcode(string barcode)
        {
            return db.Items.Where(item => item.Ptag == barcode);
        }

        // get items by user
        [Route("api/Users/{user}")]
        public IQueryable<Item> GetItemsByUser(string user)
        {
            return db.Items.Where(item => item.Custodian == user);
        }

        // get item history
        [Route("api/Items/{barcode}/history")]
        public IQueryable<History> GetItemHistory(string barcode)
        {
            return db.Histories.Where(record => record.Ptag == barcode).OrderByDescending(record => record.Time);
        }

        //// PUT: api/Items/5
        //[ResponseType(typeof(void))]
        //public async Task<IHttpActionResult> PutItem(int id, Item item)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    if (id != item.Id)
        //    {
        //        return BadRequest();
        //    }

        //    db.Entry(item).State = EntityState.Modified;

        //    try
        //    {
        //        await db.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!ItemExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return StatusCode(HttpStatusCode.NoContent);
        //}

        // POST: api/Items
        [ResponseType(typeof(Item))]
        public async Task<IHttpActionResult> PostItem(Item item)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Items.Add(item);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { pTag = item.Ptag }, item);
        }

        // DELETE: api/Items/5
        [ResponseType(typeof(Item))]
        public async Task<IHttpActionResult> DeleteItem(int id)
        {
            Item item = await db.Items.FindAsync(id);
            if (item == null)
            {
                return NotFound();
            }

            db.Items.Remove(item);
            await db.SaveChangesAsync();

            return Ok(item);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        //private bool ItemExists(int id)
        //{
        //    return db.Items.Count(e => e.Id == id) > 0;
        //}
    }
}
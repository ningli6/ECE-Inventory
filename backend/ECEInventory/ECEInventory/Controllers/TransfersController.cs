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

// This controller is for web api

namespace ECEInventory.Controllers
{
    public class TransfersController : ApiController
    {
        private InventoryDBContext db = new InventoryDBContext();
        
        //// GET: api/Transfers
        //public IQueryable<Transfer> GetTransfers()
        //{
        //    return db.Transfers;
        //}

        /// <summary>
        /// Get transfer requests by barcode
        /// </summary>
        /// <param name="barcode"></param>
        /// <returns></returns>
        [Route("api/Transfers/{barcode}")]
        public IQueryable<Transfer> GetTransfersByBarcode(string barcode)
        {
            return db.Transfers.Where(transfer => transfer.Ptag == barcode);
        }

        //// GET: api/Transfers/5
        //[ResponseType(typeof(Transfer))]
        //public async Task<IHttpActionResult> GetTransfer(int id)
        //{
        //    Transfer transfer = await db.Transfers.FindAsync(id);
        //    if (transfer == null)
        //    {
        //        return NotFound();
        //    }

        //    return Ok(transfer);
        //}

        /// <summary>
        /// Get transfer requests by sender name
        /// </summary>
        /// <param name="sender"></param>
        /// <returns></returns>
        [Route("api/Transfers/Sender/{sender}")]
        public IQueryable<Transfer> GetTransfersBySender(string sender)
        {
            return db.Transfers.Where(transfer => transfer.Sender == sender);
        }

        /// <summary>
        /// Get transfer requests by receiver name
        /// </summary>
        /// <param name="receiver"></param>
        /// <returns></returns>
        [Route("api/Transfers/Receiver/{receiver}")]
        public IQueryable<Transfer> GetTransfersByReceiver(string receiver)
        {
            return db.Transfers.Where(transfer => transfer.Receiver == receiver);
        }

        //// PUT: api/Transfers/5
        //[ResponseType(typeof(void))]
        //public async Task<IHttpActionResult> PutTransfer(int id, Transfer transfer)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    if (id != transfer.Id)
        //    {
        //        return BadRequest();
        //    }

        //    db.Entry(transfer).State = EntityState.Modified;

        //    try
        //    {
        //        await db.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!TransferExists(id))
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

        /// <summary>
        /// Post a new transfer request
        /// </summary>
        /// <param name="transfer"></param>
        /// <returns></returns>
        [ResponseType(typeof(Transfer))]
        public async Task<IHttpActionResult> PostTransfer(Transfer transfer)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // check that it is transfered to a valid user of inventory
            string receiver = transfer.Receiver;
            if (!db.Items.Any(item => item.Custodian == receiver))
            {
                return BadRequest("The receiver is not a valid user of inventory");
            }

            // initial request was not approved
            transfer.Status = 0;
            // generate timestamp for that request
            int unixTimestamp = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
            transfer.Time = unixTimestamp.ToString();

            db.Transfers.Add(transfer);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { ptag = transfer.Ptag }, transfer);
        }

        //// DELETE: api/Transfers/5
        //[ResponseType(typeof(Transfer))]
        //public async Task<IHttpActionResult> DeleteTransfer(int id)
        //{
        //    Transfer transfer = await db.Transfers.FindAsync(id);
        //    if (transfer == null)
        //    {
        //        return NotFound();
        //    }

        //    db.Transfers.Remove(transfer);
        //    await db.SaveChangesAsync();

        //    return Ok(transfer);
        //}

        //protected override void Dispose(bool disposing)
        //{
        //    if (disposing)
        //    {
        //        db.Dispose();
        //    }
        //    base.Dispose(disposing);
        //}

        //private bool TransferExists(int id)
        //{
        //    return db.Transfers.Count(e => e.Id == id) > 0;
        //}
    }
}
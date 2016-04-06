using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ECEInventory.Models;

// this controller is for mvc

namespace ECEInventory.Controllers
{
    public class TransfersViewController : Controller
    {
        private InventoryDBContext db = new InventoryDBContext();

        /// <summary>
        /// Get unprocessed transfer requests
        /// </summary>
        /// <returns></returns>
        public async Task<ActionResult> Index()
        {
            return View(await db.Transfers.ToListAsync());
        }

        /// <summary>
        /// Get all transfer requests
        /// </summary>
        /// <returns></returns>
        public async Task<ActionResult> AllRequests()
        {
            return View(await db.AllTimeRequests.ToListAsync());
        }

        /// <summary>
        /// If the request was approved, also need to update transfer history
        /// </summary>
        /// <param name="barcode"></param>
        /// <returns></returns>
        public async Task<ActionResult> Approve(string barcode)
        {
            if (barcode == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Transfer transfer = await db.Transfers.FindAsync(barcode);
            if (transfer == null)
            {
                return HttpNotFound();
            }
            // remove from pending list
            db.Transfers.Remove(transfer);
            
            // update transfer status and save to all time requests
            transfer.Status = 1;
            db.AllTimeRequests.Add(new AllTimeRequest(transfer));

            Item item = await db.Items.FindAsync(barcode);
            if (item == null)
            {
                return HttpNotFound();
            }
            // update the custodian
            item.Custodian = transfer.Receiver;

            // get a new history with new custodian (item was updated)
            History record = new History(item);
            record.Time = transfer.Time;

            // update existing entry in item table
            db.Items.Attach(item);
            var itemEntry = db.Entry(item);
            itemEntry.Property(e => e.Custodian).IsModified = true;
            
            // save the new record to history
            db.Histories.Add(record);

            // save all changes
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        /// <summary>
        /// If the request was denied, do nothing
        /// </summary>
        /// <param name="barcode"></param>
        /// <returns></returns>
        public async Task<ActionResult> Deny(string barcode)
        {
            if (barcode == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Transfer transfer = await db.Transfers.FindAsync(barcode);
            if (transfer == null)
            {
                return HttpNotFound();
            }

            // remove from pending list
            db.Transfers.Remove(transfer);

            // update status and save to all time requests
            transfer.Status = 2;
            db.AllTimeRequests.Add(new AllTimeRequest(transfer));

            db.SaveChanges();
            return RedirectToAction("Index");
        }

        // GET:  details in the pending request list
        public async Task<ActionResult> Details(string barcode)
        {
            if (barcode == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Item item = await db.Items.FindAsync(barcode);
            if (item == null)
            {
                return HttpNotFound();
            }
            return View(item);
        }

        // GET: details in the all request list
        public async Task<ActionResult> AllRequestsDetails(string barcode)
        {
            if (barcode == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Item item = await db.Items.FindAsync(barcode);
            if (item == null)
            {
                return HttpNotFound();
            }
            return View(item);
        }

        //// GET: TransfersView/Create
        //public ActionResult Create()
        //{
        //    return View();
        //}

        //// POST: TransfersView/Create
        //// To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        //// more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<ActionResult> Create([Bind(Include = "Ptag,Sender,Receiver,Status,Time")] Transfer transfer)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        db.Transfers.Add(transfer);
        //        await db.SaveChangesAsync();
        //        return RedirectToAction("Index");
        //    }

        //    return View(transfer);
        //}

        //// GET: TransfersView/Edit/5
        //public async Task<ActionResult> Edit(string id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    Transfer transfer = await db.Transfers.FindAsync(id);
        //    if (transfer == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(transfer);
        //}

        //// POST: TransfersView/Edit/5
        //// To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        //// more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<ActionResult> Edit([Bind(Include = "Ptag,Sender,Receiver,Status,Time")] Transfer transfer)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        db.Entry(transfer).State = EntityState.Modified;
        //        await db.SaveChangesAsync();
        //        return RedirectToAction("Index");
        //    }
        //    return View(transfer);
        //}

        //// GET: TransfersView/Delete/5
        //public async Task<ActionResult> Delete(string id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    Transfer transfer = await db.Transfers.FindAsync(id);
        //    if (transfer == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(transfer);
        //}

        //// POST: TransfersView/Delete/5
        //[HttpPost, ActionName("Delete")]
        //[ValidateAntiForgeryToken]
        //public async Task<ActionResult> DeleteConfirmed(string id)
        //{
        //    Transfer transfer = await db.Transfers.FindAsync(id);
        //    db.Transfers.Remove(transfer);
        //    await db.SaveChangesAsync();
        //    return RedirectToAction("Index");
        //}

        //protected override void Dispose(bool disposing)
        //{
        //    if (disposing)
        //    {
        //        db.Dispose();
        //    }
        //    base.Dispose(disposing);
        //}
    }
}

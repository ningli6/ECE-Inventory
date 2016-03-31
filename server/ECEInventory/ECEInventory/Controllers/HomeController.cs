using ECEInventory.Models;
using LinqToExcel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ECEInventory.Controllers
{
    public class HomeController : Controller
    {

        private InventoryContext db = new InventoryContext();

        public ActionResult Index()
        {
            ViewBag.Title = "ECE Inventory";

            return View();
        }

        // handler for uploading the spreadsheet
        public ActionResult Upload()
        {
            // check for user input
            if (Request.Files == null || Request.Files.Count == 0) return RedirectToAction("Index");
            if (Request.Files[0].FileName == "") return RedirectToAction("Index");
            var file = Request.Files[0];
            var fileName = file.FileName;
            if (Path.GetExtension(fileName) != ".xlsx") return RedirectToAction("Index");
            // save the file
            // save to local for now. Need to add permissions to access the file
            string savedFileName = Path.Combine(Server.MapPath("~/App_Data/"), fileName);
            file.SaveAs(savedFileName);
            // access the file
            var excel = new ExcelQueryFactory(savedFileName);
            var updates = from r in excel.Worksheet<Item>("Item")
                          select r;
            // add new items or update existing items
            foreach (var r in updates)
            {
                // update
                if (db.Items.Any(item => item.Ptag.Equals(r.Ptag)))
                {
                    db.Items.Attach(r);
                    var entry = db.Entry(r);
                    entry.Property(e => e.Custodian).IsModified = true;
                    entry.Property(e => e.Room).IsModified = true;
                    entry.Property(e => e.Bldg).IsModified = true;
                    entry.Property(e => e.SortRoom).IsModified = true;
                    // add new record history record
                    Record record = new Record(r.Ptag, r.Custodian, r.Room, r.Bldg, r.SortRoom);
                    db.History.Add(record);
                    db.SaveChanges();
                } else { // add new item
                    db.Items.Add(r);
                    db.SaveChanges();
                }
            }
            
            var count = updates.Count();
            return RedirectToAction("Result", new { s = count.ToString() });
        }

        public ActionResult Result(string s)
        {
            ViewBag.FileName = s;
            return View();
        }
    }
}

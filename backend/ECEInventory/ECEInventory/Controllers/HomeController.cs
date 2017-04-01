using ECEInventory.Models;
using LinqToExcel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Validation;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ECEInventory.Controllers
{
    public class HomeController : Controller
    {

        private InventoryDBContext db = new InventoryDBContext();

       
        public ActionResult Index()
        {
            ViewBag.Title = "ECE Inventory";
            return View();
        }
        [NonAction]
        public Boolean FileIsValid(HttpRequestBase Request) {
            if (Request.Files == null || Request.Files.Count == 0) return false;
            if (Request.Files[0].FileName == "") return false;
            var file = Request.Files[0];
            var fileName = file.FileName;
            if (Path.GetExtension(fileName) != ".xlsx" && Path.GetExtension(fileName) != ".xls") {
                return false;
            }
            return true;
        }
        [NonAction]
        public IQueryable<T> GetInfoFromExcel<T>(HttpPostedFileBase file) {
            // check for user input
            // save the file
            var fileName = file.FileName;
            // save to local for now. Need to add permissions to access the file
            string savedFileName = Path.Combine(Server.MapPath("~/"), fileName);
            
            file.SaveAs(savedFileName);
            // access the file
            var excel = new ExcelQueryFactory(savedFileName);


            var updates = from r in excel.Worksheet<T>()
                          select r;
            return updates;
        }
        [NonAction]
        public ActionResult AddInfo<T>(Action<IQueryable<T>> process) {
            if (!FileIsValid(Request)) {
                return Content("Something was wrong. Please check the requirements of uploading files");
            }
            // add new items or update existing items   
            process(GetInfoFromExcel<T>(Request.Files[0]));
            try {   // update the database
                db.SaveChanges();
            } catch (DbEntityValidationException ex) {
                // Retrieve the error messages as a list of strings.
                var errorMessages = ex.EntityValidationErrors
                        .SelectMany(x => x.ValidationErrors)
                        .Select(x => x.ErrorMessage);
                // Join the list to a single string.
                var fullErrorMessage = string.Join("; ", errorMessages);
                // Combine the original exception message with the new one.
                var exceptionMessage = string.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);
                // Throw a new DbEntityValidationException with the improved exception message.
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }
            return RedirectToAction("Result", new { s = "Inventory was updated!" });
        }

        // handler for uploading the spreadsheet
        public ActionResult AddItems()
        {
            return AddInfo<Item>(AddItem);
        }
        public void AddItem(IQueryable<Item> updates) {
            foreach (var r in updates) {
                if (r.Ptag == null || r.Ptag == "") continue;
                History record = new History(r);
                int unixTimestamp = (int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
                record.Time = unixTimestamp.ToString();
                // update
                if (db.Items.Any(item => item.Ptag == r.Ptag)) {
                    db.Items.Attach(r);
                    var entry = db.Entry(r);
                    entry.Property(e => e.Custodian).IsModified = true;
                    entry.Property(e => e.Room).IsModified = true;
                    entry.Property(e => e.Bldg).IsModified = true;
                    entry.Property(e => e.SortRoom).IsModified = true;
                } else {   // add new item
                    db.Items.Add(r);
                }
                // add new history record
                db.Histories.Add(record);
            }
        }
        public ActionResult AddPIDs() {
            return AddInfo<PID>(AddPID);
        }
        public void AddPID(IQueryable<PID> updates) {
            foreach (var r in updates) {
                if (db.PIDs.Any(p => p.pid == r.pid)) { 
                    db.PIDs.Attach(r);
                } else {
                    db.PIDs.Add(r);
                }
            }
        }
        public ActionResult Result(string s)
        {
            ViewBag.result = s;
            return View();
        }
        public ActionResult FileFormatError()
        {
            return View();
        }
    }

}

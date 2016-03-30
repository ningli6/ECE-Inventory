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
            string savedFileName = Path.Combine(Server.MapPath("~/App_Data/"), fileName);
            file.SaveAs(savedFileName);
            // access the file
            var excel = new ExcelQueryFactory(savedFileName);
            var records = from r in excel.Worksheet<Record>("Item")
                          select r;
            var count = records.Count();
            return RedirectToAction("Result", new { s = count.ToString() });
        }

        public ActionResult Result(string s)
        {
            ViewBag.FileName = s;
            return View();
        }
    }
}

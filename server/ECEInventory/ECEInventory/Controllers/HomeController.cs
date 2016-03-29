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
            var fileName = Request.Files[0].FileName;
            //if (!Request.Files[upload].HasFile()) continue;
            //string path = AppDomain.CurrentDomain.BaseDirectory + "uploads/";
            //string filename = Path.GetFileName(Request.Files[upload].FileName);
            //Request.Files[upload].SaveAs(Path.Combine(path, filename));
            //var fileName = string.Format("{0}\\temp", Directory.GetCurrentDirectory());
            //var connectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0}; Extended Properties=Excel 12.0;", fileName);

            //var adapter = new OleDbDataAdapter("SELECT * FROM [Item]", connectionString);
            //var ds = new DataSet();

            //adapter.Fill(ds, "anyNameHere");

            //DataTable data = ds.Tables["anyNameHere"];

            return RedirectToAction("Result");
        }

        public ActionResult Result()
        {
            ViewBag.FileName = "Hello world!";
            return View();
        }
    }
}

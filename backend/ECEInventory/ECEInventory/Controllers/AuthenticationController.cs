using DotNetCasClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ECEInventory.Controllers
{
    public class AuthenticationController : Controller
    {
        // GET: Authentication
        [Authorize]
        public ActionResult LogOn()
        {
            
            return RedirectToAction("ProduceCookie", "Authentication");
        }
        public ActionResult LogOff() {
            CasAuthentication.SingleSignOut();
            return RedirectToAction("Index", "Home");
        }
        
        public ActionResult ProduceCookie() {
            Response.Cookies["pep3"]["pep3"] = "pep3";
            return Content("cookies!");
        }
    }
}
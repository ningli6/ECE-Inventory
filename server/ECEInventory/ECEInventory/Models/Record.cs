using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ECEInventory.Models
{
    public class Record
    {
        public string Owner { get; set; }

        public string OrgnCode { get; set; }

        public string OrgnTitle { get; set; }

        public string Room { get; set; }

        public string Bldg { get; set; }

        public string SortRoom { get; set; }

        public string Ptag { get; set; }

        public string Manufacturer { get; set; }

        public string Model { get; set; }

        public string SN { get; set; }

        public string Description { get; set; }

        public string Custodian { get; set; }

        public string PO { get; set; }

        public string AcqDate { get; set; }

        public string Amt { get; set; }

        public string Ownership { get; set; }

        public string SchevYear { get; set; }

        public string TagType { get; set; }

        public string AssetType { get; set; }

        public string AtypTitle { get; set; }

        public string Condition { get; set; }

        public string LastInvDate { get; set; }

        public string Designation { get; set; }
    }
}
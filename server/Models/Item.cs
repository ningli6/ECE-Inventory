namespace ECEInventory.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Item
    {
        public int Id { get; set; }

        [StringLength(255)]
        public string Owner { get; set; }

        [StringLength(255)]
        public string OrgnCode { get; set; }

        [StringLength(255)]
        public string OrgnTitle { get; set; }

        [StringLength(255)]
        public string Room { get; set; }

        [StringLength(255)]
        public string Bldg { get; set; }

        [StringLength(255)]
        public string SortRoom { get; set; }

        [StringLength(255)]
        public string Ptag { get; set; }

        [StringLength(255)]
        public string Manufacturer { get; set; }

        [StringLength(255)]
        public string Model { get; set; }

        [StringLength(255)]
        public string SN { get; set; }

        [StringLength(255)]
        public string Description { get; set; }

        [StringLength(255)]
        public string Custodian { get; set; }

        [StringLength(255)]
        public string PO { get; set; }

        [StringLength(255)]
        public string AcqDate { get; set; }

        [StringLength(255)]
        public string Amt { get; set; }

        [StringLength(255)]
        public string Ownership { get; set; }

        [StringLength(255)]
        public string SchevYear { get; set; }

        [StringLength(255)]
        public string TagType { get; set; }

        [StringLength(255)]
        public string AssetType { get; set; }

        [StringLength(255)]
        public string AtypTitle { get; set; }

        [StringLength(255)]
        public string Condition { get; set; }

        [StringLength(255)]
        public string LastInvDate { get; set; }

        [StringLength(255)]
        public string Designation { get; set; }
    }
}

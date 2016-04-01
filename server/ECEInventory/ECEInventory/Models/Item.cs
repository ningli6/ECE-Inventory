namespace ECEInventory.Models
{
    using LinqToExcel.Attributes;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Item
    {
        public Item() { }

        // copy constructor
        public Item(string owner, string orgncode, string orgntitle,
            string room, string bldg, string sortroom, string ptag, string manufacturer,
            string model, string sn, string description, string custodian, string po,
            string acqDate, string amt, string ownership, string schev, string tagtype,
            string assettype, string atyptitle, string cond, string lastinvedate, string designation)
        {
            Owner = owner;
            OrgnCode = orgncode;
            OrgnTitle = orgntitle;
            Room = room;
            Bldg = bldg;
            SortRoom = sortroom;
            Ptag = ptag;
            Manufacturer = manufacturer;
            Model = model;
            SN = sn;
            Description = description;
            Custodian = custodian;
            PO = po;
            AcqDate = acqDate;
            Amt = amt;
            Ownership = ownership;
            SchevYear = schev;
            TagType = tagtype;
            AssetType = assettype;
            AtypTitle = atyptitle;
            Condition = cond;
            LastInvDate = lastinvedate;
            Designation = designation;
        }

        // copy constructor
        public Item(Item item)
        {
            Owner = item.Owner;
            OrgnCode = item.OrgnCode;
            OrgnTitle = item.OrgnTitle;
            Room = item.Room;
            Bldg = item.Bldg;
            SortRoom = item.SortRoom;
            Ptag = item.Ptag;
            Manufacturer = item.Manufacturer;
            Model = item.Model;
            SN = item.SN;
            Description = item.Description;
            Custodian = item.Custodian;
            PO = item.PO;
            AcqDate = item.AcqDate;
            Amt = item.Amt;
            Ownership = item.Ownership;
            SchevYear = item.SchevYear;
            TagType = item.TagType;
            AssetType = item.AssetType;
            AtypTitle = item.AtypTitle;
            Condition = item.Condition;
            LastInvDate = item.LastInvDate;
            Designation = item.Designation;
        }

        [ExcelColumn("Owner")]
        [StringLength(255)]
        public string Owner { get; set; }

        [ExcelColumn("Orgn Code")]
        [StringLength(255)]
        public string OrgnCode { get; set; }

        [ExcelColumn("Orgn Title")]
        [StringLength(255)]
        public string OrgnTitle { get; set; }

        [ExcelColumn("Room")]
        [StringLength(255)]
        public string Room { get; set; }

        [ExcelColumn("Bldg")]
        [StringLength(255)]
        public string Bldg { get; set; }

        [ExcelColumn("Sort Room")]
        [StringLength(255)]
        public string SortRoom { get; set; }

        [ExcelColumn("Ptag")]
        [Key]
        [StringLength(255)]
        public string Ptag { get; set; }

        [ExcelColumn("Manufacturer")]
        [StringLength(255)]
        public string Manufacturer { get; set; }

        [ExcelColumn("Model")]
        [StringLength(255)]
        public string Model { get; set; }

        [ExcelColumn("S/N")]
        [StringLength(255)]
        public string SN { get; set; }

        [ExcelColumn("Description")]
        [StringLength(255)]
        public string Description { get; set; }

        [ExcelColumn("Custodian")]
        [StringLength(255)]
        public string Custodian { get; set; }

        [ExcelColumn("PO")]
        [StringLength(255)]
        public string PO { get; set; }

        [ExcelColumn("Acq Date")]
        [StringLength(255)]
        public string AcqDate { get; set; }

        [ExcelColumn("Amt")]
        [StringLength(255)]
        public string Amt { get; set; }

        [ExcelColumn("Ownership")]
        [StringLength(255)]
        public string Ownership { get; set; }

        [ExcelColumn("Schev Year")]
        [StringLength(255)]
        public string SchevYear { get; set; }

        [ExcelColumn("Tag Type")]
        [StringLength(255)]
        public string TagType { get; set; }

        [ExcelColumn("Asset Type")]
        [StringLength(255)]
        public string AssetType { get; set; }

        [ExcelColumn("Atyp Title")]
        [StringLength(255)]
        public string AtypTitle { get; set; }

        [ExcelColumn("Condition")]
        [StringLength(255)]
        public string Condition { get; set; }

        [ExcelColumn("Last Inv Date")]
        [StringLength(255)]
        public string LastInvDate { get; set; }

        [ExcelColumn("Designation")]
        [StringLength(255)]
        public string Designation { get; set; }
    }
}

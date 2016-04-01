namespace ECEInventory.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class History
    {
        public int Id { get; set; }

        public History() { }

        public History(string ptag, string custodian, string room, string bldg, string sortRoom)
        {
            Ptag = ptag;
            Custodian = custodian;
            Room = room;
            Bldg = bldg;
            SortRoom = sortRoom;
        }

        public History(Item item)
        {
            Ptag = item.Ptag;
            Custodian = item.Custodian;
            Room = item.Room;
            Bldg = item.Bldg;
            SortRoom = item.SortRoom;
        }

        [Required]
        [StringLength(255)]
        public string Ptag { get; set; }

        [StringLength(255)]
        public string Custodian { get; set; }

        [StringLength(255)]
        public string Room { get; set; }

        [StringLength(255)]
        public string Bldg { get; set; }

        [StringLength(255)]
        public string SortRoom { get; set; }

        [Required]
        [StringLength(255)]
        public string Time { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ECEInventory.Models
{
    public class Record
    {
        public Record(string ptag, string custodian, string room, string bldg, string sortRoom)
        {
            Ptag = ptag;
            Custodian = custodian;
            Room = room;
            Bldg = bldg;
            SortRoom = sortRoom;
        }

        [Key]
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

        [Timestamp]
        public byte[] Time { get; set; }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using LinqToExcel.Attributes;
using System.ComponentModel.DataAnnotations;

namespace ECEInventory.Models {
    public partial class PID {
        public PID() { }
        public PID(String pid, String name) {
            this.pid = pid;
            this.name = name;
        }

        [ExcelColumn("pid")]
        [Key]
        [StringLength(255)]
        public String pid { get; set; }

        [ExcelColumn("name")]
        [StringLength(255)]
        public String name { get; set; }

    }
}
namespace ECEInventory.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class Transfer
    {
        [Key]
        [StringLength(255)]
        public string Ptag { get; set; }

        [Required]
        [StringLength(255)]
        public string Sender { get; set; }

        [Required]
        [StringLength(255)]
        public string Receiver { get; set; }

        public int? Status { get; set; }

        [StringLength(255)]
        public string Time { get; set; }
    }
}

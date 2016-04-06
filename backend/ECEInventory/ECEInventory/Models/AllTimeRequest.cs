namespace ECEInventory.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class AllTimeRequest
    {
        public AllTimeRequest() { }

        public AllTimeRequest(Transfer t)
        {
            Ptag = t.Ptag;
            Sender = t.Sender;
            Receiver = t.Receiver;
            Status = t.Status;
            Time = t.Time;
        }

        public int Id { get; set; }

        [Required]
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

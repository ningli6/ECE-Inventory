namespace ECEInventory.Models
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class InventoryDBContext : DbContext
    {
        public InventoryDBContext()
            : base("name=InventoryDBContext")
        {
        }

        public virtual DbSet<History> Histories { get; set; }
        public virtual DbSet<Item> Items { get; set; }
        public virtual DbSet<Transfer> Transfers { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<History>()
                .Property(e => e.Time)
                .IsFixedLength();
        }
        
    }
}

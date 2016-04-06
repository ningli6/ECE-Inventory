namespace ECEInventory2.Migrations
{
    using ECEInventory.Models;
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;

    internal sealed class Configuration : DbMigrationsConfiguration<ECEInventory2.Models.ECEInventory2Context>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(ECEInventory2.Models.ECEInventory2Context context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method 
            //  to avoid creating duplicate seed data. E.g.
            //
            //    context.People.AddOrUpdate(
            //      p => p.FullName,
            //      new Person { FullName = "Andrew Peters" },
            //      new Person { FullName = "Brice Lambson" },
            //      new Person { FullName = "Rowan Miller" }
            //    );
            //
            context.Users.AddOrUpdate(
                u => u.UserId,
                new User { UserId = 1, Name = "Mark" },
                new User { UserId = 2, Name = "Jack" },
                new User { UserId = 3, Name = "Peter" }
                );

            context.Items.AddOrUpdate(
                i => i.ItemId,
                new Item { ItemId = 1, Name = "Surface", UserId = 1 },
                new Item { ItemId = 2, Name = "Mac", UserId = 1 },
                new Item { ItemId = 3, Name = "Nexus 7", UserId = 2 },
                new Item { ItemId = 4, Name = "Nexus 5", UserId = 2 },
                new Item { ItemId = 5, Name = "Kindle", UserId = 3 },
                new Item { ItemId = 6, Name = "Ipad", UserId = 3 }
                );
        }
    }
}

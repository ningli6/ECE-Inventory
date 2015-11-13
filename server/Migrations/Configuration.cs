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
                u => u.Id,
                new User { Id = 1, Name = "Mark" },
                new User { Id = 2, Name = "Jack" },
                new User { Id = 3, Name = "Peter" }
                );

            context.Items.AddOrUpdate(
                i => i.Id,
                new Item { Id = 1, Name = "Surface" },
                new Item { Id = 2, Name = "Mac" },
                new Item { Id = 3, Name = "Nexus 7" }
                );
        }
    }
}

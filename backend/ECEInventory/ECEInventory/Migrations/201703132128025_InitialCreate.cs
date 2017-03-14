namespace ECEInventory.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.AllTimeRequests",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Ptag = c.String(nullable: false, maxLength: 255),
                        Sender = c.String(nullable: false, maxLength: 255),
                        Receiver = c.String(nullable: false, maxLength: 255),
                        Status = c.Int(),
                        Time = c.String(maxLength: 255),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Histories",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Ptag = c.String(nullable: false, maxLength: 255),
                        Custodian = c.String(maxLength: 255),
                        Room = c.String(maxLength: 255),
                        Bldg = c.String(maxLength: 255),
                        SortRoom = c.String(maxLength: 255),
                        Time = c.String(nullable: false, maxLength: 255, fixedLength: true),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "dbo.Items",
                c => new
                    {
                        Ptag = c.String(nullable: false, maxLength: 255),
                        Owner = c.String(maxLength: 255),
                        OrgnCode = c.String(maxLength: 255),
                        OrgnTitle = c.String(maxLength: 255),
                        Room = c.String(maxLength: 255),
                        Bldg = c.String(maxLength: 255),
                        SortRoom = c.String(maxLength: 255),
                        Manufacturer = c.String(maxLength: 255),
                        Model = c.String(maxLength: 255),
                        SN = c.String(maxLength: 255),
                        Description = c.String(maxLength: 255),
                        Custodian = c.String(maxLength: 255),
                        PO = c.String(maxLength: 255),
                        AcqDate = c.String(maxLength: 255),
                        Amt = c.String(maxLength: 255),
                        Ownership = c.String(maxLength: 255),
                        SchevYear = c.String(maxLength: 255),
                        TagType = c.String(maxLength: 255),
                        AssetType = c.String(maxLength: 255),
                        AtypTitle = c.String(maxLength: 255),
                        Condition = c.String(maxLength: 255),
                        LastInvDate = c.String(maxLength: 255),
                        Designation = c.String(maxLength: 255),
                    })
                .PrimaryKey(t => t.Ptag);
            
            CreateTable(
                "dbo.Transfers",
                c => new
                    {
                        Ptag = c.String(nullable: false, maxLength: 255),
                        Sender = c.String(nullable: false, maxLength: 255),
                        Receiver = c.String(nullable: false, maxLength: 255),
                        Status = c.Int(),
                        Time = c.String(maxLength: 255),
                    })
                .PrimaryKey(t => t.Ptag);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Transfers");
            DropTable("dbo.Items");
            DropTable("dbo.Histories");
            DropTable("dbo.AllTimeRequests");
        }
    }
}

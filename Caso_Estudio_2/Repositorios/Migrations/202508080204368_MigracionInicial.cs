namespace Repositorios.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MigracionInicial : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Products",
                c => new
                    {
                        IdProduct = c.Int(nullable: false, identity: true),
                        Name = c.String(nullable: false),
                        Description = c.String(),
                        Price = c.Decimal(nullable: false, precision: 18, scale: 2),
                        Stock = c.Int(nullable: false),
                        Category = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.IdProduct);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.Products");
        }
    }
}

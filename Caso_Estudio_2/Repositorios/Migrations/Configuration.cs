namespace Repositorios.Migrations
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;

    internal sealed class Configuration : DbMigrationsConfiguration<Repositorios.Data.Caso2DbContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(Repositorios.Data.Caso2DbContext context)
        {
            //  This method will be called after migrating to the latest version.

            //  You can use the DbSet<T>.AddOrUpdate() helper extension method
            //  to avoid creating duplicate seed data.
            
            context.Product.AddOrUpdate(
                p => p.Name,
                new Modelos.Product
                {
                    Name = "Balon de Futbol Adidas",
                    Description = "Balon oficial de futbol marca Adidas, talla 5",
                    Price = 35.99m,
                    Stock = 25,
                    Category = "Futbol"
                },
                new Modelos.Product
                {
                    Name = "Balon de Basquetbol Spalding",
                    Description = "Balon oficial de basquetbol marca Spalding NBA",
                    Price = 45.50m,
                    Stock = 15,
                    Category = "Basquetbol"
                },
                new Modelos.Product
                {
                    Name = "Gafas de Natacion Speedo",
                    Description = "Gafas profesionales para natacion marca Speedo",
                    Price = 18.75m,
                    Stock = 40,
                    Category = "Natacion"
                },
                new Modelos.Product
                {
                    Name = "Raqueta de Tenis Wilson",
                    Description = "Raqueta profesional de tenis marca Wilson Pro Staff",
                    Price = 120.00m,
                    Stock = 8,
                    Category = "Tenis"
                },
                new Modelos.Product
                {
                    Name = "Guayos Nike Mercurial",
                    Description = "Guayos profesionales para futbol marca Nike",
                    Price = 89.99m,
                    Stock = 20,
                    Category = "Futbol"
                },
                new Modelos.Product
                {
                    Name = "Traje de Baño Speedo",
                    Description = "Traje de baño competitivo para natacion",
                    Price = 65.00m,
                    Stock = 12,
                    Category = "Natacion"
                }
            );
        }
    }
}

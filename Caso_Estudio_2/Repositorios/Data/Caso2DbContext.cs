using Modelos;
using System.Data.Entity;

namespace Repositorios.Data
{
    public class Caso2DbContext : DbContext
    {
        public Caso2DbContext() : base("name=Caso2DbContext")
        {
            Database.SetInitializer<Caso2DbContext>(null);
        }

        public DbSet<Product> Product { get; set; }

    }
}

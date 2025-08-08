using Modelos;
using Repositorios.Data;
using System.Collections.Generic;
using System.Linq;

namespace Repositorios.Products
{
    public class ProductRepository : IProductRepository
    {

        private readonly Caso2DbContext _ctx;
        public ProductRepository()
        {
            _ctx = new Caso2DbContext();
        }
        public IEnumerable<Product> GetAll()
        {
            return _ctx.Product.ToList();
        }

        public Product GetById(int id)
        {
            return _ctx.Product.Find(id);
        }

        public void Add(Product product)
        {
            _ctx.Product.Add(product);
            _ctx.SaveChanges();
        }
        public void Update(Product product)
        {
            var existing = _ctx.Product.Find(product.IdProduct);
            if (existing == null)
                throw new KeyNotFoundException($"Product {product.IdProduct} not found.");

            _ctx.Entry(existing).CurrentValues.SetValues(product);
            _ctx.SaveChanges();
        }

        public void Delete(int id)
        {
            var toRemove = _ctx.Product.Find(id);
            if (toRemove == null)
                throw new KeyNotFoundException($"Product {id} not found.");

            _ctx.Product.Remove(toRemove);
            _ctx.SaveChanges();
        }
    }
}

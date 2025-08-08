using Modelos;
using System.Collections.Generic;

namespace Servicios.Products
{
    public interface IProductServicio
    {
        IEnumerable<Product> GetProducts();
        Product GetProduct(int id);
        void CreateProduct(Product product);
    }
}

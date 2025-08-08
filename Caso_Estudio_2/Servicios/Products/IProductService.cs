using Modelos;
using System.Collections.Generic;

namespace Servicios.Products
{
    public interface IProductService
    {
        IEnumerable<Product> GetProducts();
        Product GetProduct(int id);
        void CreateProduct(Product product);
        Product EditProduct(Product updatedProduct);
        void DeleteProduct(int id);
    }
}

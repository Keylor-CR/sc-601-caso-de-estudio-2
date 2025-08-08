using Modelos;
using Repositorios.Products;
using System.Collections.Generic;

namespace Servicios.Products
{
    public class ProductServicio : IProductServicio
    {
        private readonly IProductRepository _repository;

        public ProductServicio(IProductRepository productRepository)
        {
            _repository = productRepository;
        }

        public IEnumerable<Product> GetProducts()
        {
            return _repository.GetAll();
        }

        public Product GetProduct(int id)
        {
            return _repository.GetById(id);
        }

        public void CreateProduct(Product product)
        {
            // Aquí se puede incluir lógica de negocio adicional
            _repository.Add(product);
        }
    }
}

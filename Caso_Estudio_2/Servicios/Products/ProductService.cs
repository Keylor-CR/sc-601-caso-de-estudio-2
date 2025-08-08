using Modelos;
using Repositorios.Products;
using System;
using System.Collections.Generic;

namespace Servicios.Products
{
    public class ProductService : IProductService
    {
        private readonly IProductRepository _repository;

        public ProductService(IProductRepository productRepository)
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
            _repository.Add(product);
        }
        public void DeleteProduct(int id)
        {
            var existing = _repository.GetById(id);
            if (existing == null)
                throw new KeyNotFoundException($"Producto {id} no encontrado.");

            _repository.Delete(id);
        }
        public Product EditProduct(Product updatedProduct)
        {
            if (updatedProduct == null) throw new ArgumentNullException(nameof(updatedProduct));
            _repository.Update(updatedProduct);
            return updatedProduct;
        }
    }
}

using Modelos;
using Repositorios.Products;
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
            // Aquí se puede incluir lógica de negocio adicional
            _repository.Add(product);
        }
        public void DeleteProduct(int id)
        {
            var product = _repository.GetById(id);
            if (product != null)
            {
                // Aquí se puede incluir lógica de negocio adicional
                _repository.Delete(id);
            }
        }
        public Product EditProduct(Product updatedProduct)
        {
            var existingProduct = _repository.GetById(updatedProduct.IdProduct);
            if (existingProduct != null)
            {
                // Actualizar las propiedades del producto existente
                existingProduct.Name = updatedProduct.Name;
                existingProduct.Description = updatedProduct.Description;
                existingProduct.Price = updatedProduct.Price;
                existingProduct.Stock = updatedProduct.Stock;
                existingProduct.Category = updatedProduct.Category;
                // Aquí se puede incluir lógica de negocio adicional
                _repository.Update(existingProduct);
            }
            return existingProduct;
        }
    }
}

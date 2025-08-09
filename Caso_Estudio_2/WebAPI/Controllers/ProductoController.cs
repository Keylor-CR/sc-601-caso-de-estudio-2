using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using Modelos;
using Repositorios;
using Repositorios.Products;
using Servicios;
using Servicios.Products;
using Web.Models;
using Repositorios.Data;

namespace WebAPI.Controllers
{
    [RoutePrefix("api/producto")]
    [Authorize]
    public class ProductoController : ApiController
    {
        private readonly ProductService _service;

        public ProductoController()
        {
            var repo = new ProductRepository();
            _service = new ProductService(repo);
        }

        [HttpGet]
        [Route("obtenertodos")]
        public IEnumerable<Product> GetAll()
        {
            return _service.GetProducts();
        }

        [HttpGet]
        [Route("obtenerporid/{id:int}")]
        public IHttpActionResult Get(int id)
        {
            var product = _service.GetProduct(id);
            if (product == null) return NotFound();
            return Ok(product);
        }

        [HttpPost]
        [Route("crear")]
        [Authorize(Roles = "Admin")]
        public IHttpActionResult Post([FromBody] Product product)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            _service.CreateProduct(product);
            return Ok(product);
        }

        [HttpPut]
        [Route("actualizar/{id:int}")]
        [Authorize(Roles = "Admin")]
        public IHttpActionResult Put(int id, [FromBody] Product product)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var existing = _service.GetProduct(id);
            if (existing == null) return NotFound();

            product.IdProduct = id;
            var updated = _service.EditProduct(product);
            return Ok(updated);
        }

        [HttpDelete]
        [Route("eliminar/{id:int}")]
        [Authorize(Roles = "Admin")]
        public IHttpActionResult Delete(int id)
        {
            var existing = _service.GetProduct(id);
            if (existing == null) return NotFound();

            _service.DeleteProduct(id);
            return Ok();
        }
    }
}
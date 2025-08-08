using System.ComponentModel.DataAnnotations;

namespace Modelos
{
    public class Product
    {
        [Key]
        public int IdProduct { get; set; }
        [Required]
        public string Name { get; set; }
        public string Description { get; set; }
        [Range(0.01, double.MaxValue, ErrorMessage = "El precio no puede ser negativo")]

        public decimal Price { get; set; }
        [Range(0, int.MaxValue, ErrorMessage = "El Stock no puede ser negativo")]

        public int Stock { get; set; }
        [Required]
        public string Category { get; set; }
    }
}

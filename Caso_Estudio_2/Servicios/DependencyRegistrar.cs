using Repositorios.Products;
using Servicios.Products;
using Unity;
using Unity.Lifetime;

namespace Servicios
{
    public static class DependencyRegistrar
    {
        public static void Register(IUnityContainer container)
        {

            // 2) Repositorio genérico (inyección open-generic)
            container.RegisterType(typeof(IProductRepository), typeof(ProductRepository),
                new HierarchicalLifetimeManager());

            // 3) Servicios
            container.RegisterType(typeof(IProductService), typeof(ProductService),
                new HierarchicalLifetimeManager());
        }
    }
}

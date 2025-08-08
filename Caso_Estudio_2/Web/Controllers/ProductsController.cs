using System.Web.Mvc;

namespace Web.Controllers
{
    [Authorize]
    public class ProductsController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }
    }
}

using System.Web.Mvc;
using System.Web.Security;

namespace Web.Controllers
{
    public class BaseController : Controller
    {
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            // Verificar si el usuario está autenticado cuando se requiere autorización
            if (RequiresAuthorization() && !User.Identity.IsAuthenticated)
            {
                // Redirigir a la página de login
                filterContext.Result = RedirectToAction("Login", "Account");
                return;
            }

            base.OnActionExecuting(filterContext);
        }

        protected virtual bool RequiresAuthorization()
        {
            // Por defecto, verificar si el controlador o acción tiene el atributo [Authorize]
            var controllerDescriptor = new ReflectedControllerDescriptor(GetType());
            var actionDescriptor = controllerDescriptor.FindAction(ControllerContext, RouteData.Values["action"].ToString());

            // Verificar atributo en el controlador
            if (controllerDescriptor.IsDefined(typeof(AuthorizeAttribute), true))
                return true;

            // Verificar atributo en la acción
            if (actionDescriptor != null && actionDescriptor.IsDefined(typeof(AuthorizeAttribute), true))
                return true;

            return false;
        }

        protected string GetCurrentUserName()
        {
            return User.Identity.IsAuthenticated ? User.Identity.Name : string.Empty;
        }
    }
}

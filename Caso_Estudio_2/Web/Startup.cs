using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Web.Models;
using System.Threading.Tasks;

namespace Web
{
    public class ApplicationRoleManager : RoleManager<IdentityRole>
    {
        public ApplicationRoleManager() : base(new RoleStore<IdentityRole>(new ApplicationDbContext()))
        {
        }
    }

    public class ApplicationUserManager : UserManager<ApplicationUser>
    {
        public ApplicationUserManager() : base(new UserStore<ApplicationUser>(new ApplicationDbContext()))
        {
            PasswordValidator = new PasswordValidator
            {
                RequiredLength = 6,
                RequireNonLetterOrDigit = false,
                RequireDigit = false,
                RequireLowercase = false,
                RequireUppercase = false,
            };
        }

        public static async Task InitializeRoles()
        {
            var roleManager = new ApplicationRoleManager();
            var userManager = new ApplicationUserManager();

            if (!await roleManager.RoleExistsAsync("Admin"))
            {
                await roleManager.CreateAsync(new IdentityRole("Admin"));
            }

            if (!await roleManager.RoleExistsAsync("Usuario"))
            {
                await roleManager.CreateAsync(new IdentityRole("Usuario"));
            }

            var adminEmail = "admin@admin.com";
            var adminUser = await userManager.FindByEmailAsync(adminEmail);
            if (adminUser == null)
            {
                adminUser = new ApplicationUser
                {
                    UserName = adminEmail,
                    Email = adminEmail,
                    FirstName = "Admin",
                    LastName = "System"
                };
                await userManager.CreateAsync(adminUser, "admin123");
                await userManager.AddToRoleAsync(adminUser.Id, "Admin");
            }
        }
    }
}

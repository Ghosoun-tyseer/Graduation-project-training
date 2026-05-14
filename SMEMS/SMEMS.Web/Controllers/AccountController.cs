using Microsoft.AspNetCore.Mvc;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Account;

namespace SMEMS.Web.Controllers
{
    public class AccountController : Controller
    {
        private readonly IUserService _userService;

        public AccountController(IUserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public IActionResult Login(string? returnUrl = null)
        {
            // If already logged in, redirect to appropriate dashboard
            if (HttpContext.Session.GetInt32("UserId") != null)
            {
                return RedirectToDashboard();
            }

            return View(new LoginViewModel { ReturnUrl = returnUrl });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var user = await _userService.AuthenticateAsync(model.Username, model.Password);

            if (user == null)
            {
                ModelState.AddModelError("", "Invalid username or password");
                return View(model);
            }

            if (!user.IsActive)
            {
                ModelState.AddModelError("", "Your account has been deactivated. Please contact administrator.");
                return View(model);
            }

            // Set session values
            HttpContext.Session.SetInt32("UserId", user.Id);
            HttpContext.Session.SetString("Username", user.Username);
            HttpContext.Session.SetString("FullName", user.FullName);
            HttpContext.Session.SetString("UserRole", user.Role?.Name ?? "");
            HttpContext.Session.SetString("RoleDisplayName", user.Role?.DisplayName ?? "");
            
            if (user.DepartmentId.HasValue)
            {
                HttpContext.Session.SetInt32("DepartmentId", user.DepartmentId.Value);
                HttpContext.Session.SetString("DepartmentName", user.Department?.Name ?? "");
            }

            if (!string.IsNullOrEmpty(user.ProfileImage))
            {
                HttpContext.Session.SetString("ProfileImage", user.ProfileImage);
            }

            // Update last login
            await _userService.UpdateLastLoginAsync(user.Id);

            // Redirect to return URL or dashboard
            if (!string.IsNullOrEmpty(model.ReturnUrl) && Url.IsLocalUrl(model.ReturnUrl))
            {
                return Redirect(model.ReturnUrl);
            }

            return RedirectToDashboard();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login");
        }

        [HttpGet]
        public IActionResult Logout_Get()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login");
        }

        [HttpGet]
        public IActionResult ResetPassword()
        {
            return View(new ResetPasswordViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(ResetPasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // In a real application, you would send an email with a reset link
            // For now, we'll just show a success message
            TempData["SuccessMessage"] = "If an account with that email exists, password reset instructions have been sent.";
            return RedirectToAction("Login");
        }

        [HttpGet]
        public IActionResult AccessDenied()
        {
            return View();
        }

        private IActionResult RedirectToDashboard()
        {
            var role = HttpContext.Session.GetString("UserRole");

            return role?.ToLower() switch
            {
                "admin" => RedirectToAction("Dashboard", "Admin"),
                "engineer" => RedirectToAction("Dashboard", "Engineer"),
                "staff" => RedirectToAction("Dashboard", "Staff"),
                _ => RedirectToAction("Login")
            };
        }
    }
}

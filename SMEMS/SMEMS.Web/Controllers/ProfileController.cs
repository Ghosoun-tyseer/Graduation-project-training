using Microsoft.AspNetCore.Mvc;
using SMEMS.Web.Helpers;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Account;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [Authenticated]
    public class ProfileController : Controller
    {
        private readonly IUserService _userService;
        private readonly IMaintenanceService _maintenanceService;

        public ProfileController(IUserService userService, IMaintenanceService maintenanceService)
        {
            _userService = userService;
            _maintenanceService = maintenanceService;
        }

        public async Task<IActionResult> Index()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var user = await _userService.GetByIdAsync(userId);

            if (user == null)
            {
                return RedirectToAction("Login", "Account");
            }

            var role = user.Role?.Name ?? "";
            var maintenanceRequests = 0;
            var completedMaintenances = 0;

            if (role == "engineer")
            {
                var requests = await _maintenanceService.GetMaintenanceListAsync(null, null, null, null, null, 1, 1000, engineerId: userId);
                maintenanceRequests = requests.TotalItems;
                completedMaintenances = requests.Requests.Count(r => r.Status == "Completed");
            }
            else if (role == "staff")
            {
                var requests = await _maintenanceService.GetMaintenanceListAsync(null, null, null, null, null, 1, 1000, requesterId: userId);
                maintenanceRequests = requests.TotalItems;
            }

            var model = new ProfileViewModel
            {
                Id = user.Id,
                Username = user.Username,
                FullName = user.FullName,
                Email = user.Email,
                Phone = user.Phone,
                Role = user.Role?.Name ?? "",
                RoleDisplayName = user.Role?.DisplayName ?? "",
                Department = user.Department?.Name,
                Position = user.Position,
                ProfileImage = user.ProfileImage,
                JoinDate = user.JoinDate,
                LastLogin = user.LastLogin,
                MaintenanceRequests = maintenanceRequests,
                CompletedMaintenances = completedMaintenances
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        public async Task<IActionResult> Edit()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var user = await _userService.GetByIdAsync(userId);

            if (user == null)
            {
                return RedirectToAction("Login", "Account");
            }

            var model = new EditProfileViewModel
            {
                Id = user.Id,
                FullName = user.FullName,
                Email = user.Email,
                Phone = user.Phone,
                Position = user.Position
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(EditProfileViewModel model)
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            if (model.Id != userId)
            {
                return RedirectToAction("AccessDenied", "Account");
            }

            if (!ModelState.IsValid)
            {
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            // Check if email exists (excluding current user)
            if (await _userService.EmailExistsAsync(model.Email, model.Id))
            {
                ModelState.AddModelError("Email", "Email already exists");
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var user = await _userService.GetByIdAsync(userId);
            if (user == null)
            {
                return RedirectToAction("Login", "Account");
            }

            // Update user
            user.FullName = model.FullName;
            user.Email = model.Email;
            user.Phone = model.Phone;
            user.Position = model.Position;
            user.UpdatedAt = DateTime.Now;

            // Update session
            HttpContext.Session.SetString("FullName", model.FullName);

            TempData["SuccessMessage"] = "Profile updated successfully";
            return RedirectToAction("Index");
        }

        public IActionResult ChangePassword()
        {
            ViewBag.CurrentUser = GetCurrentUser();
            return View(new ChangePasswordViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangePassword(ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var result = await _userService.ChangePasswordAsync(userId, model.CurrentPassword, model.NewPassword);

            if (!result)
            {
                ModelState.AddModelError("CurrentPassword", "Current password is incorrect");
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            TempData["SuccessMessage"] = "Password changed successfully";
            return RedirectToAction("Index");
        }

        private CurrentUserViewModel GetCurrentUser()
        {
            return new CurrentUserViewModel
            {
                Id = HttpContext.Session.GetInt32("UserId") ?? 0,
                Username = HttpContext.Session.GetString("Username") ?? "",
                FullName = HttpContext.Session.GetString("FullName") ?? "",
                Role = HttpContext.Session.GetString("UserRole") ?? "",
                RoleDisplayName = HttpContext.Session.GetString("RoleDisplayName") ?? "",
                Department = HttpContext.Session.GetString("DepartmentName"),
                DepartmentId = HttpContext.Session.GetInt32("DepartmentId"),
                ProfileImage = HttpContext.Session.GetString("ProfileImage")
            };
        }
    }
}

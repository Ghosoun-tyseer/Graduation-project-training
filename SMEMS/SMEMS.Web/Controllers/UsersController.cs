using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Helpers;
using SMEMS.Web.Models;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Users;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [RoleAuthorize("admin")]
    public class UsersController : Controller
    {
        private readonly IUserService _userService;
        private readonly INotificationService _notificationService;
        private readonly SMEMSDbContext _context;

        public UsersController(
            IUserService userService,
            INotificationService notificationService,
            SMEMSDbContext context)
        {
            _userService = userService;
            _notificationService = notificationService;
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, int? roleId, int? departmentId, bool? isActive, int page = 1)
        {
            var model = await _userService.GetUserListAsync(search, roleId, departmentId, isActive, page, 10);
            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        public async Task<IActionResult> Details(int id)
        {
            var model = await _userService.GetUserDetailsAsync(id);
            if (model == null)
            {
                return NotFound();
            }

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        public async Task<IActionResult> Create()
        {
            var model = new AddUserViewModel
            {
                Roles = await _context.Roles.ToListAsync(),
                Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync(),
                JoinDate = DateTime.Today
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(AddUserViewModel model)
        {
            if (!ModelState.IsValid)
            {
                model.Roles = await _context.Roles.ToListAsync();
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            // Check if username exists
            if (await _userService.UsernameExistsAsync(model.Username))
            {
                ModelState.AddModelError("Username", "Username already exists");
                model.Roles = await _context.Roles.ToListAsync();
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            // Check if email exists
            if (await _userService.EmailExistsAsync(model.Email))
            {
                ModelState.AddModelError("Email", "Email already exists");
                model.Roles = await _context.Roles.ToListAsync();
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var user = await _userService.CreateAsync(model);

            // Notify admin about new user
            var currentUserId = HttpContext.Session.GetInt32("UserId") ?? 0;
            await _notificationService.CreateAsync(
                currentUserId,
                "User Created",
                $"New user {user.FullName} has been created",
                "user_added",
                "low");

            TempData["SuccessMessage"] = "User created successfully";
            return RedirectToAction("Details", new { id = user.Id });
        }

        public async Task<IActionResult> Edit(int id)
        {
            var user = await _userService.GetByIdAsync(id);
            if (user == null)
            {
                return NotFound();
            }

            var model = new EditUserViewModel
            {
                Id = user.Id,
                Username = user.Username,
                FullName = user.FullName,
                Email = user.Email,
                Phone = user.Phone,
                RoleId = user.RoleId,
                DepartmentId = user.DepartmentId,
                Position = user.Position,
                IsActive = user.IsActive,
                Roles = await _context.Roles.ToListAsync(),
                Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync()
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(EditUserViewModel model)
        {
            if (!ModelState.IsValid)
            {
                model.Roles = await _context.Roles.ToListAsync();
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            // Check if username exists (excluding current user)
            if (await _userService.UsernameExistsAsync(model.Username, model.Id))
            {
                ModelState.AddModelError("Username", "Username already exists");
                model.Roles = await _context.Roles.ToListAsync();
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            // Check if email exists (excluding current user)
            if (await _userService.EmailExistsAsync(model.Email, model.Id))
            {
                ModelState.AddModelError("Email", "Email already exists");
                model.Roles = await _context.Roles.ToListAsync();
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var result = await _userService.UpdateAsync(model);
            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = "User updated successfully";
            return RedirectToAction("Details", new { id = model.Id });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleActive(int id)
        {
            var currentUserId = HttpContext.Session.GetInt32("UserId") ?? 0;

            // Prevent deactivating self
            if (id == currentUserId)
            {
                TempData["ErrorMessage"] = "You cannot deactivate your own account";
                return RedirectToAction("Index");
            }

            var result = await _userService.ToggleActiveAsync(id);
            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = "User status updated";
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(int id)
        {
            // Generate a temporary password
            var tempPassword = "Temp@123";
            var result = await _userService.ResetPasswordAsync(id, tempPassword);

            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = $"Password has been reset to: {tempPassword}";
            return RedirectToAction("Details", new { id });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var currentUserId = HttpContext.Session.GetInt32("UserId") ?? 0;

            // Prevent deleting self
            if (id == currentUserId)
            {
                TempData["ErrorMessage"] = "You cannot delete your own account";
                return RedirectToAction("Index");
            }

            var result = await _userService.DeleteAsync(id);
            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = "User deleted successfully";
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

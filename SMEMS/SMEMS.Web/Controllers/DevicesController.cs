using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Helpers;
using SMEMS.Web.Models;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Devices;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [Authenticated]
    public class DevicesController : Controller
    {
        private readonly IDeviceService _deviceService;
        private readonly SMEMSDbContext _context;

        public DevicesController(IDeviceService deviceService, SMEMSDbContext context)
        {
            _deviceService = deviceService;
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, int? departmentId, int? statusId, int? riskLevelId, int page = 1)
        {
            var role = HttpContext.Session.GetString("UserRole");
            var userDepartmentId = HttpContext.Session.GetInt32("DepartmentId");

            // Staff can only see devices in their department
            int? filterDepartmentId = role == "staff" ? userDepartmentId : departmentId;

            var model = await _deviceService.GetDeviceListAsync(
                search, filterDepartmentId, statusId, riskLevelId, page, 10,
                role == "staff" ? userDepartmentId : null);

            ViewBag.CurrentUser = GetCurrentUser();
            ViewBag.CanEdit = role == "admin";
            return View(model);
        }

        public async Task<IActionResult> Details(int id)
        {
            var model = await _deviceService.GetDeviceDetailsAsync(id);
            if (model == null)
            {
                return NotFound();
            }

            var role = HttpContext.Session.GetString("UserRole");
            var userDepartmentId = HttpContext.Session.GetInt32("DepartmentId");

            // Staff can only see devices in their department
            if (role == "staff")
            {
                var device = await _deviceService.GetByIdAsync(id);
                if (device?.DepartmentId != userDepartmentId)
                {
                    return RedirectToAction("AccessDenied", "Account");
                }
            }

            ViewBag.CurrentUser = GetCurrentUser();
            ViewBag.CanEdit = role == "admin";
            return View(model);
        }

        [RoleAuthorize("admin")]
        public async Task<IActionResult> Create()
        {
            var model = new AddDeviceViewModel
            {
                DeviceCode = await _deviceService.GenerateDeviceCodeAsync(),
                Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync(),
                Statuses = await _context.DeviceStatuses.ToListAsync(),
                RiskLevels = await _context.RiskLevels.OrderBy(r => r.Priority).ToListAsync()
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin")]
        public async Task<IActionResult> Create(AddDeviceViewModel model)
        {
            if (!ModelState.IsValid)
            {
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                model.Statuses = await _context.DeviceStatuses.ToListAsync();
                model.RiskLevels = await _context.RiskLevels.OrderBy(r => r.Priority).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            // Check if device code already exists
            var existingDevice = await _deviceService.GetByCodeAsync(model.DeviceCode);
            if (existingDevice != null)
            {
                ModelState.AddModelError("DeviceCode", "Device code already exists");
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                model.Statuses = await _context.DeviceStatuses.ToListAsync();
                model.RiskLevels = await _context.RiskLevels.OrderBy(r => r.Priority).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            await _deviceService.CreateAsync(model);
            TempData["SuccessMessage"] = "Device created successfully";
            return RedirectToAction("Index");
        }

        [RoleAuthorize("admin")]
        public async Task<IActionResult> Edit(int id)
        {
            var device = await _deviceService.GetByIdAsync(id);
            if (device == null)
            {
                return NotFound();
            }

            var model = new EditDeviceViewModel
            {
                Id = device.Id,
                DeviceCode = device.DeviceCode,
                Name = device.Name,
                Model = device.Model,
                SerialNumber = device.SerialNumber,
                Manufacturer = device.Manufacturer,
                Supplier = device.Supplier,
                DepartmentId = device.DepartmentId,
                Location = device.Location,
                StatusId = device.StatusId,
                RiskLevelId = device.RiskLevelId,
                PurchaseDate = device.PurchaseDate,
                WarrantyExpiry = device.WarrantyExpiry,
                ExpectedLifespan = device.ExpectedLifespan,
                MaintenanceIntervalDays = device.MaintenanceIntervalDays,
                Accessories = device.Accessories,
                Notes = device.Notes,
                LastMaintenanceDate = device.LastMaintenanceDate,
                NextMaintenanceDate = device.NextMaintenanceDate,
                FailureCount = device.FailureCount,
                Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync(),
                Statuses = await _context.DeviceStatuses.ToListAsync(),
                RiskLevels = await _context.RiskLevels.OrderBy(r => r.Priority).ToListAsync()
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin")]
        public async Task<IActionResult> Edit(EditDeviceViewModel model)
        {
            if (!ModelState.IsValid)
            {
                model.Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync();
                model.Statuses = await _context.DeviceStatuses.ToListAsync();
                model.RiskLevels = await _context.RiskLevels.OrderBy(r => r.Priority).ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var result = await _deviceService.UpdateAsync(model);
            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = "Device updated successfully";
            return RedirectToAction("Details", new { id = model.Id });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _deviceService.DeleteAsync(id);
            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = "Device deleted successfully";
            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<IActionResult> GetDeviceDetails(int id)
        {
            var device = await _deviceService.GetDeviceDetailsAsync(id);
            if (device == null)
            {
                return NotFound();
            }
            return Json(device);
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

using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Helpers;
using SMEMS.Web.Models;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Maintenance;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [Authenticated]
    public class MaintenanceController : Controller
    {
        private readonly IMaintenanceService _maintenanceService;
        private readonly IDeviceService _deviceService;
        private readonly IUserService _userService;
        private readonly INotificationService _notificationService;
        private readonly SMEMSDbContext _context;

        public MaintenanceController(
            IMaintenanceService maintenanceService,
            IDeviceService deviceService,
            IUserService userService,
            INotificationService notificationService,
            SMEMSDbContext context)
        {
            _maintenanceService = maintenanceService;
            _deviceService = deviceService;
            _userService = userService;
            _notificationService = notificationService;
            _context = context;
        }

        public async Task<IActionResult> Index(string? search, int? statusId, int? typeId, int? departmentId, string? priority, int page = 1)
        {
            var role = HttpContext.Session.GetString("UserRole");
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            int? engineerId = null;
            int? requesterId = null;

            // Filter based on role
            if (role == "engineer")
            {
                engineerId = userId;
            }
            else if (role == "staff")
            {
                requesterId = userId;
            }

            var model = await _maintenanceService.GetMaintenanceListAsync(
                search, statusId, typeId, departmentId, priority, page, 10, engineerId, requesterId);

            ViewBag.CurrentUser = GetCurrentUser();
            ViewBag.CanAssign = role == "admin";
            ViewBag.CanStart = role == "engineer" || role == "admin";
            ViewBag.CanComplete = role == "engineer" || role == "admin";
            return View(model);
        }

        public async Task<IActionResult> Details(int id)
        {
            var model = await _maintenanceService.GetMaintenanceDetailsAsync(id);
            if (model == null)
            {
                return NotFound();
            }

            var role = HttpContext.Session.GetString("UserRole");
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            // Check access for staff
            if (role == "staff")
            {
                var request = await _maintenanceService.GetByIdAsync(id);
                if (request?.RequestedById != userId)
                {
                    return RedirectToAction("AccessDenied", "Account");
                }
            }

            ViewBag.CurrentUser = GetCurrentUser();
            ViewBag.CanAssign = role == "admin";
            ViewBag.CanStart = (role == "engineer" && model.AssignedEngineerId == userId) || role == "admin";
            ViewBag.CanComplete = (role == "engineer" && model.AssignedEngineerId == userId) || role == "admin";
            return View(model);
        }

        public async Task<IActionResult> Create()
        {
            var role = HttpContext.Session.GetString("UserRole");
            var departmentId = HttpContext.Session.GetInt32("DepartmentId");

            var devices = role == "staff" && departmentId.HasValue
                ? await _deviceService.GetByDepartmentAsync(departmentId.Value)
                : await _deviceService.GetAllAsync();

            var model = new CreateMaintenanceRequestViewModel
            {
                Devices = devices,
                Types = await _context.MaintenanceTypes.ToListAsync()
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CreateMaintenanceRequestViewModel model)
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            if (!ModelState.IsValid)
            {
                var role = HttpContext.Session.GetString("UserRole");
                var departmentId = HttpContext.Session.GetInt32("DepartmentId");

                model.Devices = role == "staff" && departmentId.HasValue
                    ? await _deviceService.GetByDepartmentAsync(departmentId.Value)
                    : await _deviceService.GetAllAsync();
                model.Types = await _context.MaintenanceTypes.ToListAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var request = await _maintenanceService.CreateAsync(model, userId);

            // Notify engineers about new request
            await _notificationService.CreateForRoleAsync(
                "engineer",
                "New Maintenance Request",
                $"New maintenance request {request.RequestCode} has been submitted",
                "maintenance_request",
                model.Priority);

            // Notify admin
            await _notificationService.CreateForRoleAsync(
                "admin",
                "New Maintenance Request",
                $"New maintenance request {request.RequestCode} has been submitted",
                "maintenance_request",
                model.Priority);

            TempData["SuccessMessage"] = "Maintenance request created successfully";
            return RedirectToAction("Details", new { id = request.Id });
        }

        [RoleAuthorize("admin")]
        public async Task<IActionResult> Assign(int id)
        {
            var request = await _maintenanceService.GetByIdAsync(id);
            if (request == null)
            {
                return NotFound();
            }

            var engineers = await _userService.GetEngineersAsync();

            var model = new AssignMaintenanceViewModel
            {
                RequestId = id,
                RequestCode = request.RequestCode,
                DeviceName = request.Device?.Name ?? "",
                Issue = request.Issue,
                Engineers = engineers
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin")]
        public async Task<IActionResult> Assign(AssignMaintenanceViewModel model)
        {
            if (!ModelState.IsValid)
            {
                model.Engineers = await _userService.GetEngineersAsync();
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var result = await _maintenanceService.AssignEngineerAsync(
                model.RequestId, model.EngineerId, model.ExpectedCompletionDate);

            if (!result)
            {
                return NotFound();
            }

            // Notify the assigned engineer
            var request = await _maintenanceService.GetByIdAsync(model.RequestId);
            await _notificationService.CreateAsync(
                model.EngineerId,
                "New Assignment",
                $"You have been assigned to maintenance request {request?.RequestCode}",
                "assignment",
                "high",
                actionUrl: Url.Action("Details", "Maintenance", new { id = model.RequestId }));

            TempData["SuccessMessage"] = "Engineer assigned successfully";
            return RedirectToAction("Details", new { id = model.RequestId });
        }

        [RoleAuthorize("admin", "engineer")]
        public async Task<IActionResult> Start(int id)
        {
            var request = await _maintenanceService.GetByIdAsync(id);
            if (request == null)
            {
                return NotFound();
            }

            var role = HttpContext.Session.GetString("UserRole");
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            // Engineer can only start their assigned requests
            if (role == "engineer" && request.AssignedEngineerId != userId)
            {
                return RedirectToAction("AccessDenied", "Account");
            }

            var model = new StartMaintenanceViewModel
            {
                RequestId = id,
                RequestCode = request.RequestCode,
                DeviceName = request.Device?.Name ?? "",
                Issue = request.Issue
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin", "engineer")]
        public async Task<IActionResult> Start(StartMaintenanceViewModel model)
        {
            var result = await _maintenanceService.StartMaintenanceAsync(model.RequestId, model.Notes);
            if (!result)
            {
                return NotFound();
            }

            // Notify the requester
            var request = await _maintenanceService.GetByIdAsync(model.RequestId);
            if (request != null)
            {
                await _notificationService.CreateAsync(
                    request.RequestedById,
                    "Maintenance Started",
                    $"Maintenance has started on your request {request.RequestCode}",
                    "maintenance_update",
                    "medium");
            }

            TempData["SuccessMessage"] = "Maintenance started";
            return RedirectToAction("Details", new { id = model.RequestId });
        }

        [RoleAuthorize("admin", "engineer")]
        public async Task<IActionResult> Complete(int id)
        {
            var request = await _maintenanceService.GetByIdAsync(id);
            if (request == null)
            {
                return NotFound();
            }

            var role = HttpContext.Session.GetString("UserRole");
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            // Engineer can only complete their assigned requests
            if (role == "engineer" && request.AssignedEngineerId != userId)
            {
                return RedirectToAction("AccessDenied", "Account");
            }

            var model = new CompleteMaintenanceViewModel
            {
                RequestId = id,
                RequestCode = request.RequestCode,
                DeviceName = request.Device?.Name ?? "",
                Issue = request.Issue
            };

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin", "engineer")]
        public async Task<IActionResult> Complete(CompleteMaintenanceViewModel model)
        {
            if (!ModelState.IsValid)
            {
                ViewBag.CurrentUser = GetCurrentUser();
                return View(model);
            }

            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var result = await _maintenanceService.CompleteMaintenanceAsync(model, userId);

            if (!result)
            {
                return NotFound();
            }

            // Notify the requester
            var request = await _maintenanceService.GetByIdAsync(model.RequestId);
            if (request != null)
            {
                await _notificationService.CreateAsync(
                    request.RequestedById,
                    "Maintenance Completed",
                    $"Maintenance on your request {request.RequestCode} has been completed",
                    "maintenance_update",
                    "low");
            }

            TempData["SuccessMessage"] = "Maintenance completed successfully";
            return RedirectToAction("Details", new { id = model.RequestId });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [RoleAuthorize("admin")]
        public async Task<IActionResult> Cancel(int id, string reason)
        {
            var result = await _maintenanceService.CancelAsync(id, reason);
            if (!result)
            {
                return NotFound();
            }

            TempData["SuccessMessage"] = "Maintenance request cancelled";
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

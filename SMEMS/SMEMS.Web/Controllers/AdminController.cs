using Microsoft.AspNetCore.Mvc;
using SMEMS.Web.Helpers;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Dashboard;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [RoleAuthorize("admin")]
    public class AdminController : Controller
    {
        private readonly IUserService _userService;
        private readonly IDeviceService _deviceService;
        private readonly IMaintenanceService _maintenanceService;
        private readonly INotificationService _notificationService;
        private readonly IReportService _reportService;

        public AdminController(
            IUserService userService,
            IDeviceService deviceService,
            IMaintenanceService maintenanceService,
            INotificationService notificationService,
            IReportService reportService)
        {
            _userService = userService;
            _deviceService = deviceService;
            _maintenanceService = maintenanceService;
            _notificationService = notificationService;
            _reportService = reportService;
        }

        public async Task<IActionResult> Dashboard()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            var model = new AdminDashboardViewModel
            {
                TotalDevices = await _deviceService.GetTotalDeviceCountAsync(),
                OperationalDevices = await _deviceService.GetDeviceCountByStatusAsync("operational"),
                DevicesNeedingMaintenance = await _deviceService.GetDeviceCountByStatusAsync("maintenance_needed"),
                DevicesUnderMaintenance = await _deviceService.GetDeviceCountByStatusAsync("under_maintenance"),
                OutOfServiceDevices = await _deviceService.GetDeviceCountByStatusAsync("out_of_service"),
                
                TotalUsers = (await _userService.GetAllAsync()).Count,
                TotalEngineers = await _userService.GetUserCountByRoleAsync("engineer"),
                TotalStaff = await _userService.GetUserCountByRoleAsync("staff"),
                
                PendingRequests = await _maintenanceService.GetCountByStatusAsync("pending") + 
                                  await _maintenanceService.GetCountByStatusAsync("assigned"),
                InProgressRequests = await _maintenanceService.GetCountByStatusAsync("in_progress"),
                CompletedThisMonth = await GetCompletedThisMonthAsync(),
                
                UnreadNotifications = await _notificationService.GetUnreadCountAsync(userId),
                
                DevicesByDepartment = await _deviceService.GetDeviceCountByDepartmentAsync(),
                MaintenanceByMonth = await _maintenanceService.GetMaintenanceByMonthAsync(DateTime.Now.Year)
            };

            // Get recent activities (last 10 notifications for admin)
            var recentNotifications = await _notificationService.GetByUserAsync(userId, false);
            model.RecentActivities = recentNotifications.Take(10).Select(n => new RecentActivityItem
            {
                Id = n.Id,
                Title = n.Title,
                Description = n.Message ?? "",
                Type = n.Type ?? "",
                Icon = n.Icon ?? "fa-bell",
                TimeAgo = TimeAgoHelper.GetTimeAgo(n.CreatedAt),
                CreatedAt = n.CreatedAt
            }).ToList();

            // Get recent maintenance requests
            var recentRequests = await _maintenanceService.GetMaintenanceListAsync(null, null, null, null, null, 1, 5);
            model.RecentRequests = recentRequests.Requests.Select(r => new MaintenanceRequestSummary
            {
                Id = r.Id,
                RequestCode = r.RequestCode,
                DeviceName = r.DeviceName,
                DeviceCode = r.DeviceCode,
                Department = r.Department,
                Issue = r.Issue,
                Status = r.Status,
                StatusCss = r.StatusCss,
                Priority = r.Priority,
                Type = r.Type,
                RequestedBy = r.RequestedBy,
                AssignedTo = r.AssignedTo ?? "Unassigned",
                RequestDate = r.RequestDate
            }).ToList();

            // Get critical devices
            var criticalDevices = await _deviceService.GetCriticalDevicesAsync();
            model.CriticalDevices = criticalDevices.Take(5).Select(d => new DeviceSummary
            {
                Id = d.Id,
                DeviceCode = d.DeviceCode,
                Name = d.Name,
                Model = d.Model ?? "",
                Department = d.Department?.Name ?? "",
                Location = d.Location ?? "",
                Status = d.Status?.DisplayName ?? "",
                StatusCss = d.Status?.CssClass ?? "",
                RiskLevel = d.RiskLevel?.DisplayName ?? "",
                RiskCss = d.RiskLevel?.CssClass ?? "",
                NextMaintenanceDate = d.NextMaintenanceDate,
                FailureCount = d.FailureCount
            }).ToList();

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpGet]
        public async Task<IActionResult> Reports(DateTime? startDate, DateTime? endDate, string reportType = "summary")
        {
            var start = startDate ?? DateTime.Now.AddMonths(-1);
            var end = endDate ?? DateTime.Now;

            var report = await _reportService.GenerateReportAsync(start, end, reportType);
            
            ViewBag.CurrentUser = GetCurrentUser();
            return View(report);
        }

        private async Task<int> GetCompletedThisMonthAsync()
        {
            var startOfMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            var maintenances = await _maintenanceService.GetMaintenanceListAsync(null, null, null, null, null, 1, 1000);
            return maintenances.Requests.Count(r => r.Status == "Completed" && r.CompletionDate >= startOfMonth);
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

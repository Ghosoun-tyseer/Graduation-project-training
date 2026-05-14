using Microsoft.AspNetCore.Mvc;
using SMEMS.Web.Helpers;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Dashboard;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [RoleAuthorize("engineer")]
    public class EngineerController : Controller
    {
        private readonly IDeviceService _deviceService;
        private readonly IMaintenanceService _maintenanceService;
        private readonly INotificationService _notificationService;

        public EngineerController(
            IDeviceService deviceService,
            IMaintenanceService maintenanceService,
            INotificationService notificationService)
        {
            _deviceService = deviceService;
            _maintenanceService = maintenanceService;
            _notificationService = notificationService;
        }

        public async Task<IActionResult> Dashboard()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;

            // Get my requests
            var myRequests = await _maintenanceService.GetMaintenanceListAsync(
                null, null, null, null, null, 1, 100, engineerId: userId);

            var model = new EngineerDashboardViewModel
            {
                AssignedRequests = myRequests.Requests.Count(r => r.Status == "Assigned" || r.Status == "Pending"),
                InProgressRequests = myRequests.Requests.Count(r => r.Status == "In Progress"),
                CompletedToday = myRequests.Requests.Count(r => 
                    r.Status == "Completed" && r.CompletionDate?.Date == DateTime.Today),
                CompletedThisWeek = myRequests.Requests.Count(r => 
                    r.Status == "Completed" && r.CompletionDate >= DateTime.Today.AddDays(-7)),
                CompletedThisMonth = myRequests.Requests.Count(r => 
                    r.Status == "Completed" && r.CompletionDate >= new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)),
                
                UnreadNotifications = await _notificationService.GetUnreadCountAsync(userId)
            };

            // Get devices needing attention
            var devicesNeedingMaintenance = await _deviceService.GetDevicesNeedingMaintenanceAsync();
            model.DevicesNeedingAttention = devicesNeedingMaintenance.Take(5).Select(d => new DeviceSummary
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
                NextMaintenanceDate = d.NextMaintenanceDate
            }).ToList();

            // My current requests
            model.MyRequests = myRequests.Requests
                .Where(r => r.Status != "Completed" && r.Status != "Cancelled")
                .OrderByDescending(r => r.Priority == "critical")
                .ThenByDescending(r => r.Priority == "high")
                .Take(10)
                .Select(r => new MaintenanceRequestSummary
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
                    RequestDate = r.RequestDate
                }).ToList();

            // Urgent requests
            var urgentRequests = await _maintenanceService.GetUrgentRequestsAsync();
            model.UrgentRequests = urgentRequests
                .Where(r => r.AssignedEngineerId == userId || r.AssignedEngineerId == null)
                .Take(5)
                .Select(r => new MaintenanceRequestSummary
                {
                    Id = r.Id,
                    RequestCode = r.RequestCode,
                    DeviceName = r.Device?.Name ?? "",
                    DeviceCode = r.Device?.DeviceCode ?? "",
                    Department = r.Device?.Department?.Name ?? "",
                    Issue = r.Issue,
                    Status = r.Status?.DisplayName ?? "",
                    StatusCss = r.Status?.CssClass ?? "",
                    Priority = r.Priority,
                    Type = r.Type?.DisplayName ?? "",
                    RequestedBy = r.RequestedBy?.FullName ?? "",
                    RequestDate = r.RequestDate
                }).ToList();

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
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

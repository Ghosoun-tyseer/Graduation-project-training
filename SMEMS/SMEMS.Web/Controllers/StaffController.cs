using Microsoft.AspNetCore.Mvc;
using SMEMS.Web.Helpers;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Dashboard;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [RoleAuthorize("staff")]
    public class StaffController : Controller
    {
        private readonly IDeviceService _deviceService;
        private readonly IMaintenanceService _maintenanceService;
        private readonly INotificationService _notificationService;

        public StaffController(
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
            var departmentId = HttpContext.Session.GetInt32("DepartmentId");
            var departmentName = HttpContext.Session.GetString("DepartmentName") ?? "Unknown";

            // Get department devices
            var departmentDevices = departmentId.HasValue
                ? await _deviceService.GetDeviceListAsync(null, departmentId, null, null, 1, 100, departmentId)
                : await _deviceService.GetDeviceListAsync(null, null, null, null, 1, 100);

            // Get my requests
            var myRequests = await _maintenanceService.GetMaintenanceListAsync(
                null, null, null, null, null, 1, 100, requesterId: userId);

            var model = new StaffDashboardViewModel
            {
                DepartmentName = departmentName,
                DepartmentDevices = departmentDevices.TotalDevices,
                OperationalDevices = departmentDevices.OperationalCount,
                DevicesNeedingMaintenance = departmentDevices.MaintenanceNeededCount,
                DevicesUnderMaintenance = departmentDevices.UnderMaintenanceCount,
                
                MyActiveRequests = myRequests.Requests.Count(r => r.Status != "Completed" && r.Status != "Cancelled"),
                MyPendingRequests = myRequests.Requests.Count(r => r.Status == "Pending" || r.Status == "Assigned"),
                MyCompletedRequests = myRequests.Requests.Count(r => r.Status == "Completed"),
                
                UnreadNotifications = await _notificationService.GetUnreadCountAsync(userId)
            };

            // My requests list
            model.MyRequests = myRequests.Requests
                .OrderByDescending(r => r.RequestDate)
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
                    AssignedTo = r.AssignedTo ?? "Unassigned",
                    RequestDate = r.RequestDate,
                    CompletionDate = r.CompletionDate
                }).ToList();

            // Department devices list
            model.DepartmentDevicesList = departmentDevices.Devices
                .Take(10)
                .Select(d => new DeviceSummary
                {
                    Id = d.Id,
                    DeviceCode = d.DeviceCode,
                    Name = d.Name,
                    Model = d.Model ?? "",
                    Department = d.Department ?? "",
                    Location = d.Location ?? "",
                    Status = d.Status,
                    StatusCss = d.StatusCss,
                    RiskLevel = d.RiskLevel ?? "",
                    RiskCss = d.RiskCss ?? "",
                    NextMaintenanceDate = d.NextMaintenanceDate
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

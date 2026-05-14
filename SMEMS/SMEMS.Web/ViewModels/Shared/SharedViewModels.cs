using System.ComponentModel.DataAnnotations;

namespace SMEMS.Web.ViewModels.Shared
{
    public class NotificationListViewModel
    {
        public List<NotificationItemViewModel> Notifications { get; set; } = new();
        public int UnreadCount { get; set; }
        
        // Filters
        public bool? IsRead { get; set; }
        public string? Type { get; set; }
        
        // Pagination
        public int CurrentPage { get; set; } = 1;
        public int TotalPages { get; set; }
        public int TotalItems { get; set; }
        public int PageSize { get; set; } = 20;
    }

    public class NotificationItemViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Message { get; set; }
        public string? Type { get; set; }
        public string Priority { get; set; } = "medium";
        public string? Icon { get; set; }
        public bool IsRead { get; set; }
        public DateTime CreatedAt { get; set; }
        public string TimeAgo { get; set; } = string.Empty;
        public string? ActionUrl { get; set; }
    }

    public class ProfileViewModel
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Phone { get; set; }
        public string Role { get; set; } = string.Empty;
        public string RoleDisplayName { get; set; } = string.Empty;
        public string? Department { get; set; }
        public string? Position { get; set; }
        public string? ProfileImage { get; set; }
        public DateTime? JoinDate { get; set; }
        public DateTime? LastLogin { get; set; }
        
        // Stats
        public int TotalActivities { get; set; }
        public int MaintenanceRequests { get; set; }
        public int CompletedMaintenances { get; set; }
    }

    public class EditProfileViewModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Full name is required")]
        [StringLength(100)]
        [Display(Name = "Full Name")]
        public string FullName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email is required")]
        [EmailAddress]
        [StringLength(100)]
        [Display(Name = "Email")]
        public string Email { get; set; } = string.Empty;

        [Phone]
        [StringLength(20)]
        [Display(Name = "Phone")]
        public string? Phone { get; set; }

        [StringLength(100)]
        [Display(Name = "Position")]
        public string? Position { get; set; }
    }

    public class ReportViewModel
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string ReportType { get; set; } = "summary";
        
        // Summary Stats
        public int TotalDevices { get; set; }
        public int TotalMaintenanceRequests { get; set; }
        public int CompletedMaintenances { get; set; }
        public int PendingMaintenances { get; set; }
        public decimal TotalMaintenanceCost { get; set; }
        
        // Charts Data
        public Dictionary<string, int> MaintenanceByMonth { get; set; } = new();
        public Dictionary<string, int> DevicesByStatus { get; set; } = new();
        public Dictionary<string, int> MaintenanceByType { get; set; } = new();
        public Dictionary<string, int> MaintenanceByDepartment { get; set; } = new();
        
        // Detailed Lists
        public List<DeviceReportItem> Devices { get; set; } = new();
        public List<MaintenanceReportItem> Maintenances { get; set; } = new();
    }

    public class DeviceReportItem
    {
        public string DeviceCode { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public int MaintenanceCount { get; set; }
        public int FailureCount { get; set; }
        public decimal TotalCost { get; set; }
    }

    public class MaintenanceReportItem
    {
        public string RequestCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string Engineer { get; set; } = string.Empty;
        public DateTime RequestDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public decimal? Cost { get; set; }
    }

    // User session info passed to views
    public class CurrentUserViewModel
    {
        public int Id { get; set; }
        public string Username { get; set; } = string.Empty;
        public string FullName { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
        public string RoleDisplayName { get; set; } = string.Empty;
        public string? Department { get; set; }
        public int? DepartmentId { get; set; }
        public string? ProfileImage { get; set; }
        public int UnreadNotifications { get; set; }
    }
}

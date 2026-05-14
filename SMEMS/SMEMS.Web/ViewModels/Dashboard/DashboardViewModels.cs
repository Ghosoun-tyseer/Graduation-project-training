namespace SMEMS.Web.ViewModels.Dashboard
{
    // Admin Dashboard ViewModel
    public class AdminDashboardViewModel
    {
        public int TotalDevices { get; set; }
        public int OperationalDevices { get; set; }
        public int DevicesNeedingMaintenance { get; set; }
        public int DevicesUnderMaintenance { get; set; }
        public int OutOfServiceDevices { get; set; }
        
        public int TotalUsers { get; set; }
        public int TotalEngineers { get; set; }
        public int TotalStaff { get; set; }
        
        public int PendingRequests { get; set; }
        public int InProgressRequests { get; set; }
        public int CompletedThisMonth { get; set; }
        
        public int UnreadNotifications { get; set; }
        
        public List<RecentActivityItem> RecentActivities { get; set; } = new();
        public List<MaintenanceRequestSummary> RecentRequests { get; set; } = new();
        public List<DeviceSummary> CriticalDevices { get; set; } = new();
        public Dictionary<string, int> DevicesByDepartment { get; set; } = new();
        public Dictionary<string, int> MaintenanceByMonth { get; set; } = new();
    }

    // Engineer Dashboard ViewModel
    public class EngineerDashboardViewModel
    {
        public int AssignedRequests { get; set; }
        public int InProgressRequests { get; set; }
        public int CompletedToday { get; set; }
        public int CompletedThisWeek { get; set; }
        public int CompletedThisMonth { get; set; }
        
        public int PendingPreventive { get; set; }
        public int OverdueMaintenances { get; set; }
        
        public int UnreadNotifications { get; set; }
        
        public List<MaintenanceRequestSummary> MyRequests { get; set; } = new();
        public List<MaintenanceRequestSummary> UrgentRequests { get; set; } = new();
        public List<DeviceSummary> DevicesNeedingAttention { get; set; } = new();
    }

    // Staff Dashboard ViewModel
    public class StaffDashboardViewModel
    {
        public int DepartmentDevices { get; set; }
        public int OperationalDevices { get; set; }
        public int DevicesNeedingMaintenance { get; set; }
        public int DevicesUnderMaintenance { get; set; }
        
        public int MyActiveRequests { get; set; }
        public int MyPendingRequests { get; set; }
        public int MyCompletedRequests { get; set; }
        
        public int UnreadNotifications { get; set; }
        
        public string DepartmentName { get; set; } = string.Empty;
        
        public List<MaintenanceRequestSummary> MyRequests { get; set; } = new();
        public List<DeviceSummary> DepartmentDevicesList { get; set; } = new();
    }

    // Supporting classes
    public class RecentActivityItem
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string Icon { get; set; } = string.Empty;
        public string TimeAgo { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
    }

    public class MaintenanceRequestSummary
    {
        public int Id { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string DeviceCode { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public string Issue { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public string Type { get; set; } = string.Empty;
        public string RequestedBy { get; set; } = string.Empty;
        public string AssignedTo { get; set; } = string.Empty;
        public DateTime RequestDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? CompletionDate { get; set; }
    }

    public class DeviceSummary
    {
        public int Id { get; set; }
        public string DeviceCode { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Model { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public string RiskLevel { get; set; } = string.Empty;
        public string RiskCss { get; set; } = string.Empty;
        public DateTime? NextMaintenanceDate { get; set; }
        public int FailureCount { get; set; }
    }
}

using System.ComponentModel.DataAnnotations;
using SMEMS.Web.Models;

namespace SMEMS.Web.ViewModels.Devices
{
    public class DeviceListViewModel
    {
        public List<DeviceItemViewModel> Devices { get; set; } = new();
        public List<Department> Departments { get; set; } = new();
        public List<DeviceStatus> Statuses { get; set; } = new();
        public List<RiskLevel> RiskLevels { get; set; } = new();
        
        // Filters
        public string? SearchTerm { get; set; }
        public int? DepartmentId { get; set; }
        public int? StatusId { get; set; }
        public int? RiskLevelId { get; set; }
        
        // Pagination
        public int CurrentPage { get; set; } = 1;
        public int TotalPages { get; set; }
        public int TotalItems { get; set; }
        public int PageSize { get; set; } = 10;
        
        // Stats
        public int TotalDevices { get; set; }
        public int OperationalCount { get; set; }
        public int MaintenanceNeededCount { get; set; }
        public int UnderMaintenanceCount { get; set; }
        public int OutOfServiceCount { get; set; }
    }

    public class DeviceItemViewModel
    {
        public int Id { get; set; }
        public string DeviceCode { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string? Model { get; set; }
        public string? SerialNumber { get; set; }
        public string? Manufacturer { get; set; }
        public string? Department { get; set; }
        public int? DepartmentId { get; set; }
        public string? Location { get; set; }
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public string? RiskLevel { get; set; }
        public string? RiskCss { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public DateTime? WarrantyExpiry { get; set; }
        public DateTime? NextMaintenanceDate { get; set; }
        public int FailureCount { get; set; }
        public bool IsActive { get; set; }
    }

    public class DeviceDetailsViewModel
    {
        public int Id { get; set; }
        public string DeviceCode { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string? Model { get; set; }
        public string? SerialNumber { get; set; }
        public string? Manufacturer { get; set; }
        public string? Supplier { get; set; }
        public string? Department { get; set; }
        public string? Location { get; set; }
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public string? RiskLevel { get; set; }
        public string? RiskCss { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public DateTime? WarrantyExpiry { get; set; }
        public string? ExpectedLifespan { get; set; }
        public int FailureCount { get; set; }
        public DateTime? LastMaintenanceDate { get; set; }
        public DateTime? NextMaintenanceDate { get; set; }
        public int MaintenanceIntervalDays { get; set; }
        public string? Accessories { get; set; }
        public string? Notes { get; set; }
        public string? ImagePath { get; set; }
        
        public List<MaintenanceHistoryItem> MaintenanceHistory { get; set; } = new();
        public List<MaintenanceRequestItem> ActiveRequests { get; set; } = new();
    }

    public class MaintenanceHistoryItem
    {
        public int Id { get; set; }
        public string Type { get; set; } = string.Empty;
        public DateTime MaintenanceDate { get; set; }
        public string? Description { get; set; }
        public string PerformedBy { get; set; } = string.Empty;
    }

    public class MaintenanceRequestItem
    {
        public int Id { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        public string Issue { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public DateTime RequestDate { get; set; }
    }

    public class AddDeviceViewModel
    {
        [Required(ErrorMessage = "Device code is required")]
        [StringLength(20)]
        [Display(Name = "Device Code")]
        public string DeviceCode { get; set; } = string.Empty;

        [Required(ErrorMessage = "Device name is required")]
        [StringLength(100)]
        [Display(Name = "Device Name")]
        public string Name { get; set; } = string.Empty;

        [StringLength(100)]
        [Display(Name = "Model")]
        public string? Model { get; set; }

        [StringLength(100)]
        [Display(Name = "Serial Number")]
        public string? SerialNumber { get; set; }

        [StringLength(100)]
        [Display(Name = "Manufacturer")]
        public string? Manufacturer { get; set; }

        [StringLength(100)]
        [Display(Name = "Supplier")]
        public string? Supplier { get; set; }

        [Display(Name = "Department")]
        public int? DepartmentId { get; set; }

        [StringLength(200)]
        [Display(Name = "Location")]
        public string? Location { get; set; }

        [Required(ErrorMessage = "Status is required")]
        [Display(Name = "Status")]
        public int StatusId { get; set; }

        [Display(Name = "Risk Level")]
        public int? RiskLevelId { get; set; }

        [Display(Name = "Purchase Date")]
        [DataType(DataType.Date)]
        public DateTime? PurchaseDate { get; set; }

        [Display(Name = "Warranty Expiry")]
        [DataType(DataType.Date)]
        public DateTime? WarrantyExpiry { get; set; }

        [StringLength(50)]
        [Display(Name = "Expected Lifespan")]
        public string? ExpectedLifespan { get; set; }

        [Display(Name = "Maintenance Interval (Days)")]
        public int MaintenanceIntervalDays { get; set; } = 90;

        [StringLength(500)]
        [Display(Name = "Accessories")]
        public string? Accessories { get; set; }

        [Display(Name = "Notes")]
        public string? Notes { get; set; }

        // For dropdowns
        public List<Department> Departments { get; set; } = new();
        public List<DeviceStatus> Statuses { get; set; } = new();
        public List<RiskLevel> RiskLevels { get; set; } = new();
    }

    public class EditDeviceViewModel : AddDeviceViewModel
    {
        public int Id { get; set; }
        public DateTime? LastMaintenanceDate { get; set; }
        public DateTime? NextMaintenanceDate { get; set; }
        public int FailureCount { get; set; }
    }
}

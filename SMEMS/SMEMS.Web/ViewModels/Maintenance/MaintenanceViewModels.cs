using System.ComponentModel.DataAnnotations;
using SMEMS.Web.Models;

namespace SMEMS.Web.ViewModels.Maintenance
{
    public class MaintenanceListViewModel
    {
        public List<MaintenanceRequestItemViewModel> Requests { get; set; } = new();
        public List<MaintenanceStatus> Statuses { get; set; } = new();
        public List<MaintenanceType> Types { get; set; } = new();
        public List<Department> Departments { get; set; } = new();
        
        // Filters
        public string? SearchTerm { get; set; }
        public int? StatusId { get; set; }
        public int? TypeId { get; set; }
        public int? DepartmentId { get; set; }
        public string? Priority { get; set; }
        
        // Pagination
        public int CurrentPage { get; set; } = 1;
        public int TotalPages { get; set; }
        public int TotalItems { get; set; }
        public int PageSize { get; set; } = 10;
        
        // Stats
        public int PendingCount { get; set; }
        public int InProgressCount { get; set; }
        public int CompletedCount { get; set; }
        public int TotalCount { get; set; }
    }

    public class MaintenanceRequestItemViewModel
    {
        public int Id { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        public string DeviceCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public string Issue { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string Type { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public string RequestedBy { get; set; } = string.Empty;
        public string? AssignedTo { get; set; }
        public DateTime RequestDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public bool HasAlternative { get; set; }
    }

    public class MaintenanceDetailsViewModel
    {
        public int Id { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        
        // Device Info
        public int DeviceId { get; set; }
        public string DeviceCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string? DeviceModel { get; set; }
        public string? DeviceLocation { get; set; }
        public string Department { get; set; } = string.Empty;
        
        // Request Info
        public string Issue { get; set; } = string.Empty;
        public string? Description { get; set; }
        public string Type { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string StatusCss { get; set; } = string.Empty;
        public string Priority { get; set; } = string.Empty;
        public bool HasAlternative { get; set; }
        public string? AlternativeDescription { get; set; }
        
        // People
        public string RequestedBy { get; set; } = string.Empty;
        public string? AssignedTo { get; set; }
        public int? AssignedEngineerId { get; set; }
        
        // Dates
        public DateTime RequestDate { get; set; }
        public DateTime? AssignedDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? ExpectedCompletionDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        
        // Resolution
        public string? EngineerNotes { get; set; }
        public string? Resolution { get; set; }
        public string? PartsUsed { get; set; }
        public decimal? Cost { get; set; }
        
        // For engineers dropdown
        public List<User> Engineers { get; set; } = new();
    }

    public class CreateMaintenanceRequestViewModel
    {
        [Required(ErrorMessage = "Device is required")]
        [Display(Name = "Device")]
        public int DeviceId { get; set; }

        [Required(ErrorMessage = "Maintenance type is required")]
        [Display(Name = "Maintenance Type")]
        public int TypeId { get; set; }

        [Required(ErrorMessage = "Priority is required")]
        [Display(Name = "Priority")]
        public string Priority { get; set; } = "medium";

        [Required(ErrorMessage = "Issue description is required")]
        [StringLength(200)]
        [Display(Name = "Issue")]
        public string Issue { get; set; } = string.Empty;

        [Display(Name = "Detailed Description")]
        public string? Description { get; set; }

        [Display(Name = "Alternative Device Available")]
        public bool HasAlternative { get; set; }

        [StringLength(255)]
        [Display(Name = "Alternative Description")]
        public string? AlternativeDescription { get; set; }

        // For dropdowns
        public List<Device> Devices { get; set; } = new();
        public List<MaintenanceType> Types { get; set; } = new();
    }

    public class AssignMaintenanceViewModel
    {
        public int RequestId { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string Issue { get; set; } = string.Empty;

        [Required(ErrorMessage = "Engineer is required")]
        [Display(Name = "Assign to Engineer")]
        public int EngineerId { get; set; }

        [Display(Name = "Expected Completion Date")]
        [DataType(DataType.Date)]
        public DateTime? ExpectedCompletionDate { get; set; }

        public List<User> Engineers { get; set; } = new();
    }

    public class CompleteMaintenanceViewModel
    {
        public int RequestId { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string Issue { get; set; } = string.Empty;

        [Required(ErrorMessage = "Resolution is required")]
        [Display(Name = "Resolution Description")]
        public string Resolution { get; set; } = string.Empty;

        [Display(Name = "Parts Used")]
        public string? PartsUsed { get; set; }

        [Display(Name = "Cost")]
        [DataType(DataType.Currency)]
        public decimal? Cost { get; set; }

        [Display(Name = "Engineer Notes")]
        public string? EngineerNotes { get; set; }

        [Display(Name = "Schedule Next Maintenance")]
        [DataType(DataType.Date)]
        public DateTime? NextMaintenanceDate { get; set; }
    }

    public class StartMaintenanceViewModel
    {
        public int RequestId { get; set; }
        public string RequestCode { get; set; } = string.Empty;
        public string DeviceName { get; set; } = string.Empty;
        public string Issue { get; set; } = string.Empty;

        [Display(Name = "Initial Notes")]
        public string? Notes { get; set; }
    }
}

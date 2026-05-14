// =============================================
// SMEMS Entity Framework Core Models
// Smart Medical Equipment Management System
// =============================================

// =============================================
// FILE: Models/Role.cs
// =============================================
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMEMS.Core.Entities
{
    public class Role
    {
        [Key]
        public int RoleId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string RoleName { get; set; } = string.Empty;
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<User> Users { get; set; } = new List<User>();
    }
}

// =============================================
// FILE: Models/Department.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Department
    {
        [Key]
        public int DepartmentId { get; set; }
        
        [Required]
        [StringLength(100)]
        public string DepartmentName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string DepartmentCode { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string? Description { get; set; }
        
        [StringLength(255)]
        public string? Location { get; set; }
        
        [StringLength(20)]
        public string? PhoneExtension { get; set; }
        
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<User> Users { get; set; } = new List<User>();
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
        public virtual ICollection<DeviceAssignment> DeviceAssignments { get; set; } = new List<DeviceAssignment>();
    }
}

// =============================================
// FILE: Models/User.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class User
    {
        [Key]
        public int UserId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string Username { get; set; } = string.Empty;
        
        [Required]
        [StringLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;
        
        [Required]
        [StringLength(255)]
        public string PasswordHash { get; set; } = string.Empty;
        
        [StringLength(255)]
        public string? PasswordSalt { get; set; }
        
        [Required]
        [StringLength(150)]
        public string FullName { get; set; } = string.Empty;
        
        [StringLength(30)]
        public string? Phone { get; set; }
        
        [StringLength(100)]
        public string? Position { get; set; }
        
        [StringLength(50)]
        public string? EmployeeId { get; set; }
        
        [StringLength(500)]
        public string? ProfileImageUrl { get; set; }
        
        // Foreign Keys
        public int RoleId { get; set; }
        public int DepartmentId { get; set; }
        
        public bool IsActive { get; set; } = true;
        public bool IsEmailVerified { get; set; } = false;
        public DateTime? LastLoginAt { get; set; }
        public DateTime? PasswordChangedAt { get; set; }
        public int FailedLoginAttempts { get; set; } = 0;
        public DateTime? LockoutEndAt { get; set; }
        
        [StringLength(500)]
        public string? RefreshToken { get; set; }
        public DateTime? RefreshTokenExpiryTime { get; set; }
        
        public DateTime? JoinedDate { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("RoleId")]
        public virtual Role Role { get; set; } = null!;
        
        [ForeignKey("DepartmentId")]
        public virtual Department Department { get; set; } = null!;
        
        public virtual ICollection<MaintenanceRequest> RequestedMaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<MaintenanceRequest> AssignedMaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<MaintenanceLog> MaintenanceLogs { get; set; } = new List<MaintenanceLog>();
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
        public virtual ICollection<Report> Reports { get; set; } = new List<Report>();
        public virtual ICollection<AuditLog> AuditLogs { get; set; } = new List<AuditLog>();
    }
}

// =============================================
// FILE: Models/DeviceCategory.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class DeviceCategory
    {
        [Key]
        public int CategoryId { get; set; }
        
        [Required]
        [StringLength(100)]
        public string CategoryName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string CategoryCode { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string? Description { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
    }
}

// =============================================
// FILE: Models/Manufacturer.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Manufacturer
    {
        [Key]
        public int ManufacturerId { get; set; }
        
        [Required]
        [StringLength(150)]
        public string ManufacturerName { get; set; } = string.Empty;
        
        [StringLength(100)]
        public string? ContactPerson { get; set; }
        
        [StringLength(100)]
        [EmailAddress]
        public string? Email { get; set; }
        
        [StringLength(30)]
        public string? Phone { get; set; }
        
        [StringLength(500)]
        public string? Address { get; set; }
        
        [StringLength(255)]
        public string? Website { get; set; }
        
        [StringLength(100)]
        public string? Country { get; set; }
        
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
    }
}

// =============================================
// FILE: Models/Supplier.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Supplier
    {
        [Key]
        public int SupplierId { get; set; }
        
        [Required]
        [StringLength(150)]
        public string SupplierName { get; set; } = string.Empty;
        
        [StringLength(100)]
        public string? ContactPerson { get; set; }
        
        [StringLength(100)]
        [EmailAddress]
        public string? Email { get; set; }
        
        [StringLength(30)]
        public string? Phone { get; set; }
        
        [StringLength(500)]
        public string? Address { get; set; }
        
        [StringLength(255)]
        public string? Website { get; set; }
        
        [StringLength(100)]
        public string? Country { get; set; }
        
        public DateTime? ContractStartDate { get; set; }
        public DateTime? ContractEndDate { get; set; }
        
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
    }
}

// =============================================
// FILE: Models/DeviceStatus.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class DeviceStatus
    {
        [Key]
        public int StatusId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string StatusName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string StatusCode { get; set; } = string.Empty;
        
        [StringLength(7)]
        public string? ColorCode { get; set; }
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public int DisplayOrder { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
    }
}

// =============================================
// FILE: Models/RiskLevel.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class RiskLevel
    {
        [Key]
        public int RiskLevelId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string RiskLevelName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string RiskLevelCode { get; set; } = string.Empty;
        
        [StringLength(7)]
        public string? ColorCode { get; set; }
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public int DisplayOrder { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
    }
}

// =============================================
// FILE: Models/Device.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Device
    {
        [Key]
        public int DeviceId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string DeviceCode { get; set; } = string.Empty;
        
        [Required]
        [StringLength(200)]
        public string DeviceName { get; set; } = string.Empty;
        
        [StringLength(100)]
        public string? Model { get; set; }
        
        [StringLength(100)]
        public string? SerialNumber { get; set; }
        
        [StringLength(1000)]
        public string? Description { get; set; }
        
        // Foreign Keys
        public int CategoryId { get; set; }
        public int? ManufacturerId { get; set; }
        public int? SupplierId { get; set; }
        public int DepartmentId { get; set; }
        public int StatusId { get; set; }
        public int RiskLevelId { get; set; }
        
        [StringLength(255)]
        public string? Location { get; set; }
        
        public DateTime? PurchaseDate { get; set; }
        
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? PurchasePrice { get; set; }
        
        public DateTime? WarrantyExpiryDate { get; set; }
        public int? ExpectedLifespanYears { get; set; }
        public DateTime? InstallationDate { get; set; }
        public DateTime? LastMaintenanceDate { get; set; }
        public DateTime? NextMaintenanceDate { get; set; }
        public int MaintenanceIntervalDays { get; set; } = 180;
        public int FailureCount { get; set; } = 0;
        
        [StringLength(500)]
        public string? ImageUrl { get; set; }
        
        public string? Notes { get; set; }
        
        public bool IsActive { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public int? CreatedByUserId { get; set; }
        public int? UpdatedByUserId { get; set; }
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("CategoryId")]
        public virtual DeviceCategory Category { get; set; } = null!;
        
        [ForeignKey("ManufacturerId")]
        public virtual Manufacturer? Manufacturer { get; set; }
        
        [ForeignKey("SupplierId")]
        public virtual Supplier? Supplier { get; set; }
        
        [ForeignKey("DepartmentId")]
        public virtual Department Department { get; set; } = null!;
        
        [ForeignKey("StatusId")]
        public virtual DeviceStatus Status { get; set; } = null!;
        
        [ForeignKey("RiskLevelId")]
        public virtual RiskLevel RiskLevel { get; set; } = null!;
        
        [ForeignKey("CreatedByUserId")]
        public virtual User? CreatedBy { get; set; }
        
        [ForeignKey("UpdatedByUserId")]
        public virtual User? UpdatedBy { get; set; }
        
        public virtual ICollection<DeviceAccessory> Accessories { get; set; } = new List<DeviceAccessory>();
        public virtual ICollection<MaintenanceRequest> MaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<MaintenanceLog> MaintenanceLogs { get; set; } = new List<MaintenanceLog>();
        public virtual ICollection<DeviceAssignment> Assignments { get; set; } = new List<DeviceAssignment>();
        public virtual ICollection<ActivityHistory> ActivityHistories { get; set; } = new List<ActivityHistory>();
    }
}

// =============================================
// FILE: Models/DeviceAccessory.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class DeviceAccessory
    {
        [Key]
        public int AccessoryId { get; set; }
        
        public int DeviceId { get; set; }
        
        [Required]
        [StringLength(200)]
        public string AccessoryName { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string? Description { get; set; }
        
        public int Quantity { get; set; } = 1;
        
        [StringLength(100)]
        public string? SerialNumber { get; set; }
        
        public DateTime? PurchaseDate { get; set; }
        public DateTime? ExpiryDate { get; set; }
        public bool IsAvailable { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("DeviceId")]
        public virtual Device Device { get; set; } = null!;
    }
}

// =============================================
// FILE: Models/Priority.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Priority
    {
        [Key]
        public int PriorityId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string PriorityName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string PriorityCode { get; set; } = string.Empty;
        
        [StringLength(7)]
        public string? ColorCode { get; set; }
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public int? ResponseTimeHours { get; set; }
        public int DisplayOrder { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<MaintenanceRequest> MaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
    }
}

// =============================================
// FILE: Models/MaintenanceType.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class MaintenanceType
    {
        [Key]
        public int MaintenanceTypeId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string TypeName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string TypeCode { get; set; } = string.Empty;
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<MaintenanceRequest> MaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<MaintenanceLog> MaintenanceLogs { get; set; } = new List<MaintenanceLog>();
    }
}

// =============================================
// FILE: Models/RequestStatus.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class RequestStatus
    {
        [Key]
        public int RequestStatusId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string StatusName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(20)]
        public string StatusCode { get; set; } = string.Empty;
        
        [StringLength(7)]
        public string? ColorCode { get; set; }
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public int DisplayOrder { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<MaintenanceRequest> MaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
    }
}

// =============================================
// FILE: Models/MaintenanceRequest.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class MaintenanceRequest
    {
        [Key]
        public int RequestId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string RequestCode { get; set; } = string.Empty;
        
        public int DeviceId { get; set; }
        public int RequestedByUserId { get; set; }
        public int? AssignedToUserId { get; set; }
        public int MaintenanceTypeId { get; set; }
        public int PriorityId { get; set; }
        public int RequestStatusId { get; set; }
        
        [Required]
        [StringLength(200)]
        public string IssueTitle { get; set; } = string.Empty;
        
        public string? IssueDescription { get; set; }
        
        public bool HasAlternativeDevice { get; set; } = false;
        public int? AlternativeDeviceId { get; set; }
        
        public DateTime RequestedDate { get; set; } = DateTime.UtcNow;
        public DateTime? AssignedDate { get; set; }
        public DateTime? StartedDate { get; set; }
        public DateTime? CompletedDate { get; set; }
        public DateTime? EstimatedCompletionDate { get; set; }
        
        [Column(TypeName = "decimal(5, 2)")]
        public decimal? ActualWorkHours { get; set; }
        
        public string? EngineerNotes { get; set; }
        public string? ResolutionSummary { get; set; }
        
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? PartsCost { get; set; }
        
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? LaborCost { get; set; }
        
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Column(TypeName = "decimal(18, 2)")]
        public decimal TotalCost { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("DeviceId")]
        public virtual Device Device { get; set; } = null!;
        
        [ForeignKey("RequestedByUserId")]
        public virtual User RequestedBy { get; set; } = null!;
        
        [ForeignKey("AssignedToUserId")]
        public virtual User? AssignedTo { get; set; }
        
        [ForeignKey("MaintenanceTypeId")]
        public virtual MaintenanceType MaintenanceType { get; set; } = null!;
        
        [ForeignKey("PriorityId")]
        public virtual Priority Priority { get; set; } = null!;
        
        [ForeignKey("RequestStatusId")]
        public virtual RequestStatus RequestStatus { get; set; } = null!;
        
        [ForeignKey("AlternativeDeviceId")]
        public virtual Device? AlternativeDevice { get; set; }
        
        public virtual ICollection<MaintenanceLog> MaintenanceLogs { get; set; } = new List<MaintenanceLog>();
        public virtual ICollection<Attachment> Attachments { get; set; } = new List<Attachment>();
    }
}

// =============================================
// FILE: Models/MaintenanceLog.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class MaintenanceLog
    {
        [Key]
        public int LogId { get; set; }
        
        public int? RequestId { get; set; }
        public int DeviceId { get; set; }
        public int PerformedByUserId { get; set; }
        public int MaintenanceTypeId { get; set; }
        
        [Required]
        public DateTime MaintenanceDate { get; set; }
        
        public string? Description { get; set; }
        public string? ActionsTaken { get; set; }
        
        [StringLength(1000)]
        public string? PartsReplaced { get; set; }
        
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? PartsCost { get; set; }
        
        [Column(TypeName = "decimal(5, 2)")]
        public decimal? LaborHours { get; set; }
        
        [Column(TypeName = "decimal(18, 2)")]
        public decimal? LaborCost { get; set; }
        
        [DatabaseGenerated(DatabaseGeneratedOption.Computed)]
        [Column(TypeName = "decimal(18, 2)")]
        public decimal TotalCost { get; set; }
        
        public DateTime? NextMaintenanceDate { get; set; }
        public bool IsScheduled { get; set; } = false;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("RequestId")]
        public virtual MaintenanceRequest? Request { get; set; }
        
        [ForeignKey("DeviceId")]
        public virtual Device Device { get; set; } = null!;
        
        [ForeignKey("PerformedByUserId")]
        public virtual User PerformedBy { get; set; } = null!;
        
        [ForeignKey("MaintenanceTypeId")]
        public virtual MaintenanceType MaintenanceType { get; set; } = null!;
    }
}

// =============================================
// FILE: Models/NotificationType.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class NotificationType
    {
        [Key]
        public int NotificationTypeId { get; set; }
        
        [Required]
        [StringLength(100)]
        public string TypeName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(30)]
        public string TypeCode { get; set; } = string.Empty;
        
        [StringLength(50)]
        public string? IconName { get; set; }
        
        [StringLength(7)]
        public string? ColorCode { get; set; }
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
    }
}

// =============================================
// FILE: Models/Notification.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Notification
    {
        [Key]
        public int NotificationId { get; set; }
        
        public int UserId { get; set; }
        public int NotificationTypeId { get; set; }
        
        [Required]
        [StringLength(200)]
        public string Title { get; set; } = string.Empty;
        
        [Required]
        [StringLength(1000)]
        public string Message { get; set; } = string.Empty;
        
        public int? PriorityId { get; set; }
        
        [StringLength(50)]
        public string? RelatedEntityType { get; set; }
        
        public int? RelatedEntityId { get; set; }
        
        public bool IsRead { get; set; } = false;
        public DateTime? ReadAt { get; set; }
        public DateTime? ExpiresAt { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
        
        [ForeignKey("NotificationTypeId")]
        public virtual NotificationType NotificationType { get; set; } = null!;
        
        [ForeignKey("PriorityId")]
        public virtual Priority? Priority { get; set; }
    }
}

// =============================================
// FILE: Models/ReportType.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class ReportType
    {
        [Key]
        public int ReportTypeId { get; set; }
        
        [Required]
        [StringLength(100)]
        public string TypeName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(30)]
        public string TypeCode { get; set; } = string.Empty;
        
        [StringLength(255)]
        public string? Description { get; set; }
        
        [StringLength(255)]
        public string? TemplateFileName { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        public virtual ICollection<Report> Reports { get; set; } = new List<Report>();
    }
}

// =============================================
// FILE: Models/Report.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Report
    {
        [Key]
        public int ReportId { get; set; }
        
        [Required]
        [StringLength(50)]
        public string ReportCode { get; set; } = string.Empty;
        
        public int ReportTypeId { get; set; }
        
        [Required]
        [StringLength(200)]
        public string Title { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string? Description { get; set; }
        
        public int GeneratedByUserId { get; set; }
        
        public string? FilterCriteria { get; set; } // JSON
        
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        
        [Required]
        [StringLength(10)]
        public string Format { get; set; } = "PDF";
        
        [StringLength(500)]
        public string? FileUrl { get; set; }
        
        public long? FileSizeBytes { get; set; }
        public bool IncludesCharts { get; set; } = false;
        public DateTime GeneratedAt { get; set; } = DateTime.UtcNow;
        public DateTime? ExpiresAt { get; set; }
        public int DownloadCount { get; set; } = 0;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("ReportTypeId")]
        public virtual ReportType ReportType { get; set; } = null!;
        
        [ForeignKey("GeneratedByUserId")]
        public virtual User GeneratedBy { get; set; } = null!;
    }
}

// =============================================
// FILE: Models/DeviceAssignment.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class DeviceAssignment
    {
        [Key]
        public int AssignmentId { get; set; }
        
        public int DeviceId { get; set; }
        public int DepartmentId { get; set; }
        
        [StringLength(255)]
        public string? Location { get; set; }
        
        public int AssignedByUserId { get; set; }
        
        public DateTime AssignedDate { get; set; } = DateTime.UtcNow;
        public DateTime? ReturnedDate { get; set; }
        
        [StringLength(500)]
        public string? Notes { get; set; }
        
        public bool IsCurrentAssignment { get; set; } = true;
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("DeviceId")]
        public virtual Device Device { get; set; } = null!;
        
        [ForeignKey("DepartmentId")]
        public virtual Department Department { get; set; } = null!;
        
        [ForeignKey("AssignedByUserId")]
        public virtual User AssignedBy { get; set; } = null!;
    }
}

// =============================================
// FILE: Models/Attachment.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class Attachment
    {
        [Key]
        public int AttachmentId { get; set; }
        
        [Required]
        [StringLength(255)]
        public string FileName { get; set; } = string.Empty;
        
        [Required]
        [StringLength(255)]
        public string OriginalFileName { get; set; } = string.Empty;
        
        [StringLength(10)]
        public string? FileExtension { get; set; }
        
        [StringLength(100)]
        public string? ContentType { get; set; }
        
        public long? FileSizeBytes { get; set; }
        
        [Required]
        [StringLength(500)]
        public string FileUrl { get; set; } = string.Empty;
        
        [Required]
        [StringLength(50)]
        public string EntityType { get; set; } = string.Empty;
        
        public int EntityId { get; set; }
        public int UploadedByUserId { get; set; }
        
        [StringLength(500)]
        public string? Description { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public bool IsDeleted { get; set; } = false;
        
        // Navigation Properties
        [ForeignKey("UploadedByUserId")]
        public virtual User UploadedBy { get; set; } = null!;
    }
}

// =============================================
// FILE: Models/AuditLog.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class AuditLog
    {
        [Key]
        public long AuditLogId { get; set; }
        
        public int? UserId { get; set; }
        
        [StringLength(100)]
        public string? UserName { get; set; }
        
        [Required]
        [StringLength(100)]
        public string Action { get; set; } = string.Empty;
        
        [StringLength(100)]
        public string? EntityType { get; set; }
        
        public int? EntityId { get; set; }
        
        public string? OldValues { get; set; } // JSON
        public string? NewValues { get; set; } // JSON
        
        [StringLength(50)]
        public string? IpAddress { get; set; }
        
        [StringLength(500)]
        public string? UserAgent { get; set; }
        
        public string? AdditionalInfo { get; set; }
        
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
        
        // Navigation Properties
        [ForeignKey("UserId")]
        public virtual User? User { get; set; }
    }
}

// =============================================
// FILE: Models/ActivityHistory.cs
// =============================================
namespace SMEMS.Core.Entities
{
    public class ActivityHistory
    {
        [Key]
        public long ActivityId { get; set; }
        
        public int DeviceId { get; set; }
        public int? UserId { get; set; }
        
        [Required]
        [StringLength(100)]
        public string ActivityType { get; set; } = string.Empty;
        
        [StringLength(500)]
        public string? Description { get; set; }
        
        [StringLength(255)]
        public string? OldValue { get; set; }
        
        [StringLength(255)]
        public string? NewValue { get; set; }
        
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        
        // Navigation Properties
        [ForeignKey("DeviceId")]
        public virtual Device Device { get; set; } = null!;
        
        [ForeignKey("UserId")]
        public virtual User? User { get; set; }
    }
}

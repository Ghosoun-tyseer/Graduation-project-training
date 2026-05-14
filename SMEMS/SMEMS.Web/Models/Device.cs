using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMEMS.Web.Models
{
    [Table("Devices")]
    public class Device
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(20)]
        public string DeviceCode { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string Name { get; set; } = string.Empty;

        [StringLength(100)]
        public string? Model { get; set; }

        [StringLength(100)]
        public string? SerialNumber { get; set; }

        [StringLength(100)]
        public string? Manufacturer { get; set; }

        [StringLength(100)]
        public string? Supplier { get; set; }

        public int? DepartmentId { get; set; }

        [StringLength(200)]
        public string? Location { get; set; }

        [Required]
        public int StatusId { get; set; }

        public int? RiskLevelId { get; set; }

        public DateTime? PurchaseDate { get; set; }

        public DateTime? WarrantyExpiry { get; set; }

        [StringLength(50)]
        public string? ExpectedLifespan { get; set; }

        public int FailureCount { get; set; } = 0;

        public DateTime? LastMaintenanceDate { get; set; }

        public DateTime? NextMaintenanceDate { get; set; }

        public int MaintenanceIntervalDays { get; set; } = 90;

        [StringLength(500)]
        public string? Accessories { get; set; }

        public string? Notes { get; set; }

        [StringLength(255)]
        public string? ImagePath { get; set; }

        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation properties
        [ForeignKey("DepartmentId")]
        public virtual Department? Department { get; set; }

        [ForeignKey("StatusId")]
        public virtual DeviceStatus? Status { get; set; }

        [ForeignKey("RiskLevelId")]
        public virtual RiskLevel? RiskLevel { get; set; }

        public virtual ICollection<MaintenanceRequest> MaintenanceRequests { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<MaintenanceRecord> MaintenanceRecords { get; set; } = new List<MaintenanceRecord>();
    }
}

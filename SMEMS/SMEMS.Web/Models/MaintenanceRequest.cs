using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMEMS.Web.Models
{
    [Table("MaintenanceRequests")]
    public class MaintenanceRequest
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(20)]
        public string RequestCode { get; set; } = string.Empty;

        [Required]
        public int DeviceId { get; set; }

        [Required]
        public int RequestedById { get; set; }

        public int? AssignedEngineerId { get; set; }

        [Required]
        public int TypeId { get; set; }

        [Required]
        public int StatusId { get; set; }

        [StringLength(20)]
        public string Priority { get; set; } = "medium";

        [Required]
        [StringLength(200)]
        public string Issue { get; set; } = string.Empty;

        public string? Description { get; set; }

        public bool HasAlternative { get; set; } = false;

        [StringLength(255)]
        public string? AlternativeDescription { get; set; }

        public string? EngineerNotes { get; set; }

        public DateTime RequestDate { get; set; } = DateTime.Now;

        public DateTime? AssignedDate { get; set; }

        public DateTime? StartDate { get; set; }

        public DateTime? ExpectedCompletionDate { get; set; }

        public DateTime? CompletionDate { get; set; }

        public string? Resolution { get; set; }

        [StringLength(500)]
        public string? PartsUsed { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? Cost { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation properties
        [ForeignKey("DeviceId")]
        public virtual Device? Device { get; set; }

        [ForeignKey("RequestedById")]
        public virtual User? RequestedBy { get; set; }

        [ForeignKey("AssignedEngineerId")]
        public virtual User? AssignedEngineer { get; set; }

        [ForeignKey("TypeId")]
        public virtual MaintenanceType? Type { get; set; }

        [ForeignKey("StatusId")]
        public virtual MaintenanceStatus? Status { get; set; }

        public virtual ICollection<MaintenanceRecord> MaintenanceRecords { get; set; } = new List<MaintenanceRecord>();
    }
}

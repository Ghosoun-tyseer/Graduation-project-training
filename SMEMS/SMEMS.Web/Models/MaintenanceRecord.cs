using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMEMS.Web.Models
{
    [Table("MaintenanceRecords")]
    public class MaintenanceRecord
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public int DeviceId { get; set; }

        public int? MaintenanceRequestId { get; set; }

        [Required]
        public int TypeId { get; set; }

        [Required]
        public DateTime MaintenanceDate { get; set; }

        public string? Description { get; set; }

        public string? Actions { get; set; }

        [StringLength(500)]
        public string? PartsReplaced { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal? Cost { get; set; }

        [Required]
        public int PerformedById { get; set; }

        public DateTime? NextScheduledDate { get; set; }

        public string? Notes { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation properties
        [ForeignKey("DeviceId")]
        public virtual Device? Device { get; set; }

        [ForeignKey("MaintenanceRequestId")]
        public virtual MaintenanceRequest? MaintenanceRequest { get; set; }

        [ForeignKey("TypeId")]
        public virtual MaintenanceType? Type { get; set; }

        [ForeignKey("PerformedById")]
        public virtual User? PerformedBy { get; set; }
    }
}

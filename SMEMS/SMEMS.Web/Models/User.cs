using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMEMS.Web.Models
{
    [Table("Users")]
    public class User
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Username { get; set; } = string.Empty;

        [Required]
        [StringLength(256)]
        public string PasswordHash { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string FullName { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [StringLength(20)]
        public string? Phone { get; set; }

        [Required]
        public int RoleId { get; set; }

        public int? DepartmentId { get; set; }

        [StringLength(100)]
        public string? Position { get; set; }

        [StringLength(255)]
        public string? ProfileImage { get; set; }

        public DateTime? JoinDate { get; set; }

        public DateTime? LastLogin { get; set; }

        public bool IsActive { get; set; } = true;

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation properties
        [ForeignKey("RoleId")]
        public virtual Role? Role { get; set; }

        [ForeignKey("DepartmentId")]
        public virtual Department? Department { get; set; }

        public virtual ICollection<MaintenanceRequest> RequestedMaintenances { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<MaintenanceRequest> AssignedMaintenances { get; set; } = new List<MaintenanceRequest>();
        public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();
    }
}

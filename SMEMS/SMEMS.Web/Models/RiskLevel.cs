using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMEMS.Web.Models
{
    [Table("RiskLevels")]
    public class RiskLevel
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        public string Name { get; set; } = string.Empty;

        [Required]
        [StringLength(100)]
        public string DisplayName { get; set; } = string.Empty;

        [StringLength(50)]
        public string? CssClass { get; set; }

        public int Priority { get; set; } = 0;

        // Navigation property
        public virtual ICollection<Device> Devices { get; set; } = new List<Device>();
    }
}

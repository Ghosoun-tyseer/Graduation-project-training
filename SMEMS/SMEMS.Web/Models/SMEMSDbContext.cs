using Microsoft.EntityFrameworkCore;

namespace SMEMS.Web.Models
{
    public class SMEMSDbContext : DbContext
    {
        public SMEMSDbContext(DbContextOptions<SMEMSDbContext> options)
            : base(options)
        {
        }

        public DbSet<Role> Roles { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<DeviceStatus> DeviceStatuses { get; set; }
        public DbSet<RiskLevel> RiskLevels { get; set; }
        public DbSet<Device> Devices { get; set; }
        public DbSet<MaintenanceType> MaintenanceTypes { get; set; }
        public DbSet<MaintenanceStatus> MaintenanceStatuses { get; set; }
        public DbSet<MaintenanceRequest> MaintenanceRequests { get; set; }
        public DbSet<MaintenanceRecord> MaintenanceRecords { get; set; }
        public DbSet<Notification> Notifications { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure User relationships
            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithMany(r => r.Users)
                .HasForeignKey(u => u.RoleId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<User>()
                .HasOne(u => u.Department)
                .WithMany(d => d.Users)
                .HasForeignKey(u => u.DepartmentId)
                .OnDelete(DeleteBehavior.SetNull);

            // Configure Device relationships
            modelBuilder.Entity<Device>()
                .HasOne(d => d.Department)
                .WithMany(dep => dep.Devices)
                .HasForeignKey(d => d.DepartmentId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<Device>()
                .HasOne(d => d.Status)
                .WithMany(s => s.Devices)
                .HasForeignKey(d => d.StatusId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Device>()
                .HasOne(d => d.RiskLevel)
                .WithMany(r => r.Devices)
                .HasForeignKey(d => d.RiskLevelId)
                .OnDelete(DeleteBehavior.SetNull);

            // Configure MaintenanceRequest relationships
            modelBuilder.Entity<MaintenanceRequest>()
                .HasOne(mr => mr.Device)
                .WithMany(d => d.MaintenanceRequests)
                .HasForeignKey(mr => mr.DeviceId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MaintenanceRequest>()
                .HasOne(mr => mr.RequestedBy)
                .WithMany(u => u.RequestedMaintenances)
                .HasForeignKey(mr => mr.RequestedById)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MaintenanceRequest>()
                .HasOne(mr => mr.AssignedEngineer)
                .WithMany(u => u.AssignedMaintenances)
                .HasForeignKey(mr => mr.AssignedEngineerId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<MaintenanceRequest>()
                .HasOne(mr => mr.Type)
                .WithMany(t => t.MaintenanceRequests)
                .HasForeignKey(mr => mr.TypeId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MaintenanceRequest>()
                .HasOne(mr => mr.Status)
                .WithMany(s => s.MaintenanceRequests)
                .HasForeignKey(mr => mr.StatusId)
                .OnDelete(DeleteBehavior.Restrict);

            // Configure MaintenanceRecord relationships
            modelBuilder.Entity<MaintenanceRecord>()
                .HasOne(mr => mr.Device)
                .WithMany(d => d.MaintenanceRecords)
                .HasForeignKey(mr => mr.DeviceId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<MaintenanceRecord>()
                .HasOne(mr => mr.MaintenanceRequest)
                .WithMany(req => req.MaintenanceRecords)
                .HasForeignKey(mr => mr.MaintenanceRequestId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<MaintenanceRecord>()
                .HasOne(mr => mr.Type)
                .WithMany(t => t.MaintenanceRecords)
                .HasForeignKey(mr => mr.TypeId)
                .OnDelete(DeleteBehavior.Restrict);

            // Configure Notification relationships
            modelBuilder.Entity<Notification>()
                .HasOne(n => n.User)
                .WithMany(u => u.Notifications)
                .HasForeignKey(n => n.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // Configure unique indexes
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique();

            modelBuilder.Entity<Device>()
                .HasIndex(d => d.DeviceCode)
                .IsUnique();

            modelBuilder.Entity<MaintenanceRequest>()
                .HasIndex(mr => mr.RequestCode)
                .IsUnique();

            modelBuilder.Entity<Role>()
                .HasIndex(r => r.Name)
                .IsUnique();

            modelBuilder.Entity<Department>()
                .HasIndex(d => d.Code)
                .IsUnique();
        }
    }
}

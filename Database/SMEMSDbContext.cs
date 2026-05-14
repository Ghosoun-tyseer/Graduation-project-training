// =============================================
// SMEMS DbContext Configuration
// Smart Medical Equipment Management System
// =============================================

using Microsoft.EntityFrameworkCore;
using SMEMS.Core.Entities;

namespace SMEMS.Infrastructure.Data
{
    public class SMEMSDbContext : DbContext
    {
        public SMEMSDbContext(DbContextOptions<SMEMSDbContext> options) : base(options)
        {
        }

        // DbSets
        public DbSet<Role> Roles { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<DeviceCategory> DeviceCategories { get; set; }
        public DbSet<Manufacturer> Manufacturers { get; set; }
        public DbSet<Supplier> Suppliers { get; set; }
        public DbSet<DeviceStatus> DeviceStatuses { get; set; }
        public DbSet<RiskLevel> RiskLevels { get; set; }
        public DbSet<Device> Devices { get; set; }
        public DbSet<DeviceAccessory> DeviceAccessories { get; set; }
        public DbSet<Priority> Priorities { get; set; }
        public DbSet<MaintenanceType> MaintenanceTypes { get; set; }
        public DbSet<RequestStatus> RequestStatuses { get; set; }
        public DbSet<MaintenanceRequest> MaintenanceRequests { get; set; }
        public DbSet<MaintenanceLog> MaintenanceLogs { get; set; }
        public DbSet<NotificationType> NotificationTypes { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<ReportType> ReportTypes { get; set; }
        public DbSet<Report> Reports { get; set; }
        public DbSet<DeviceAssignment> DeviceAssignments { get; set; }
        public DbSet<Attachment> Attachments { get; set; }
        public DbSet<AuditLog> AuditLogs { get; set; }
        public DbSet<ActivityHistory> ActivityHistories { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // =============================================
            // ROLE CONFIGURATION
            // =============================================
            modelBuilder.Entity<Role>(entity =>
            {
                entity.ToTable("Roles");
                entity.HasKey(e => e.RoleId);
                entity.HasIndex(e => e.RoleName).IsUnique();
                entity.Property(e => e.RoleName).IsRequired().HasMaxLength(50);
            });

            // =============================================
            // DEPARTMENT CONFIGURATION
            // =============================================
            modelBuilder.Entity<Department>(entity =>
            {
                entity.ToTable("Departments");
                entity.HasKey(e => e.DepartmentId);
                entity.HasIndex(e => e.DepartmentName).IsUnique();
                entity.HasIndex(e => e.DepartmentCode).IsUnique();
            });

            // =============================================
            // USER CONFIGURATION
            // =============================================
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("Users");
                entity.HasKey(e => e.UserId);
                entity.HasIndex(e => e.Username).IsUnique();
                entity.HasIndex(e => e.Email).IsUnique();
                entity.HasIndex(e => e.EmployeeId).IsUnique();

                entity.HasOne(e => e.Role)
                    .WithMany(r => r.Users)
                    .HasForeignKey(e => e.RoleId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Department)
                    .WithMany(d => d.Users)
                    .HasForeignKey(e => e.DepartmentId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // =============================================
            // DEVICE CATEGORY CONFIGURATION
            // =============================================
            modelBuilder.Entity<DeviceCategory>(entity =>
            {
                entity.ToTable("DeviceCategories");
                entity.HasKey(e => e.CategoryId);
                entity.HasIndex(e => e.CategoryName).IsUnique();
                entity.HasIndex(e => e.CategoryCode).IsUnique();
            });

            // =============================================
            // MANUFACTURER CONFIGURATION
            // =============================================
            modelBuilder.Entity<Manufacturer>(entity =>
            {
                entity.ToTable("Manufacturers");
                entity.HasKey(e => e.ManufacturerId);
            });

            // =============================================
            // SUPPLIER CONFIGURATION
            // =============================================
            modelBuilder.Entity<Supplier>(entity =>
            {
                entity.ToTable("Suppliers");
                entity.HasKey(e => e.SupplierId);
            });

            // =============================================
            // DEVICE STATUS CONFIGURATION
            // =============================================
            modelBuilder.Entity<DeviceStatus>(entity =>
            {
                entity.ToTable("DeviceStatuses");
                entity.HasKey(e => e.StatusId);
                entity.HasIndex(e => e.StatusName).IsUnique();
                entity.HasIndex(e => e.StatusCode).IsUnique();
            });

            // =============================================
            // RISK LEVEL CONFIGURATION
            // =============================================
            modelBuilder.Entity<RiskLevel>(entity =>
            {
                entity.ToTable("RiskLevels");
                entity.HasKey(e => e.RiskLevelId);
                entity.HasIndex(e => e.RiskLevelName).IsUnique();
                entity.HasIndex(e => e.RiskLevelCode).IsUnique();
            });

            // =============================================
            // DEVICE CONFIGURATION
            // =============================================
            modelBuilder.Entity<Device>(entity =>
            {
                entity.ToTable("Devices");
                entity.HasKey(e => e.DeviceId);
                entity.HasIndex(e => e.DeviceCode).IsUnique();
                entity.HasIndex(e => e.SerialNumber).IsUnique();

                entity.HasOne(e => e.Category)
                    .WithMany(c => c.Devices)
                    .HasForeignKey(e => e.CategoryId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Manufacturer)
                    .WithMany(m => m.Devices)
                    .HasForeignKey(e => e.ManufacturerId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.HasOne(e => e.Supplier)
                    .WithMany(s => s.Devices)
                    .HasForeignKey(e => e.SupplierId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.HasOne(e => e.Department)
                    .WithMany(d => d.Devices)
                    .HasForeignKey(e => e.DepartmentId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Status)
                    .WithMany(s => s.Devices)
                    .HasForeignKey(e => e.StatusId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.RiskLevel)
                    .WithMany(r => r.Devices)
                    .HasForeignKey(e => e.RiskLevelId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.CreatedBy)
                    .WithMany()
                    .HasForeignKey(e => e.CreatedByUserId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.HasOne(e => e.UpdatedBy)
                    .WithMany()
                    .HasForeignKey(e => e.UpdatedByUserId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.Property(e => e.PurchasePrice).HasColumnType("decimal(18,2)");
            });

            // =============================================
            // DEVICE ACCESSORY CONFIGURATION
            // =============================================
            modelBuilder.Entity<DeviceAccessory>(entity =>
            {
                entity.ToTable("DeviceAccessories");
                entity.HasKey(e => e.AccessoryId);

                entity.HasOne(e => e.Device)
                    .WithMany(d => d.Accessories)
                    .HasForeignKey(e => e.DeviceId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // =============================================
            // PRIORITY CONFIGURATION
            // =============================================
            modelBuilder.Entity<Priority>(entity =>
            {
                entity.ToTable("Priorities");
                entity.HasKey(e => e.PriorityId);
                entity.HasIndex(e => e.PriorityName).IsUnique();
                entity.HasIndex(e => e.PriorityCode).IsUnique();
            });

            // =============================================
            // MAINTENANCE TYPE CONFIGURATION
            // =============================================
            modelBuilder.Entity<MaintenanceType>(entity =>
            {
                entity.ToTable("MaintenanceTypes");
                entity.HasKey(e => e.MaintenanceTypeId);
                entity.HasIndex(e => e.TypeName).IsUnique();
                entity.HasIndex(e => e.TypeCode).IsUnique();
            });

            // =============================================
            // REQUEST STATUS CONFIGURATION
            // =============================================
            modelBuilder.Entity<RequestStatus>(entity =>
            {
                entity.ToTable("RequestStatuses");
                entity.HasKey(e => e.RequestStatusId);
                entity.HasIndex(e => e.StatusName).IsUnique();
                entity.HasIndex(e => e.StatusCode).IsUnique();
            });

            // =============================================
            // MAINTENANCE REQUEST CONFIGURATION
            // =============================================
            modelBuilder.Entity<MaintenanceRequest>(entity =>
            {
                entity.ToTable("MaintenanceRequests");
                entity.HasKey(e => e.RequestId);
                entity.HasIndex(e => e.RequestCode).IsUnique();

                entity.HasOne(e => e.Device)
                    .WithMany(d => d.MaintenanceRequests)
                    .HasForeignKey(e => e.DeviceId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.RequestedBy)
                    .WithMany(u => u.RequestedMaintenanceRequests)
                    .HasForeignKey(e => e.RequestedByUserId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.AssignedTo)
                    .WithMany(u => u.AssignedMaintenanceRequests)
                    .HasForeignKey(e => e.AssignedToUserId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.HasOne(e => e.MaintenanceType)
                    .WithMany(m => m.MaintenanceRequests)
                    .HasForeignKey(e => e.MaintenanceTypeId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Priority)
                    .WithMany(p => p.MaintenanceRequests)
                    .HasForeignKey(e => e.PriorityId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.RequestStatus)
                    .WithMany(s => s.MaintenanceRequests)
                    .HasForeignKey(e => e.RequestStatusId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.AlternativeDevice)
                    .WithMany()
                    .HasForeignKey(e => e.AlternativeDeviceId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.Property(e => e.PartsCost).HasColumnType("decimal(18,2)");
                entity.Property(e => e.LaborCost).HasColumnType("decimal(18,2)");
                entity.Property(e => e.TotalCost).HasColumnType("decimal(18,2)")
                    .HasComputedColumnSql("(ISNULL([PartsCost], 0) + ISNULL([LaborCost], 0))", stored: true);
            });

            // =============================================
            // MAINTENANCE LOG CONFIGURATION
            // =============================================
            modelBuilder.Entity<MaintenanceLog>(entity =>
            {
                entity.ToTable("MaintenanceLogs");
                entity.HasKey(e => e.LogId);

                entity.HasOne(e => e.Request)
                    .WithMany(r => r.MaintenanceLogs)
                    .HasForeignKey(e => e.RequestId)
                    .OnDelete(DeleteBehavior.SetNull);

                entity.HasOne(e => e.Device)
                    .WithMany(d => d.MaintenanceLogs)
                    .HasForeignKey(e => e.DeviceId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.PerformedBy)
                    .WithMany(u => u.MaintenanceLogs)
                    .HasForeignKey(e => e.PerformedByUserId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.MaintenanceType)
                    .WithMany(m => m.MaintenanceLogs)
                    .HasForeignKey(e => e.MaintenanceTypeId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.Property(e => e.PartsCost).HasColumnType("decimal(18,2)");
                entity.Property(e => e.LaborCost).HasColumnType("decimal(18,2)");
                entity.Property(e => e.TotalCost).HasColumnType("decimal(18,2)")
                    .HasComputedColumnSql("(ISNULL([PartsCost], 0) + ISNULL([LaborCost], 0))", stored: true);
            });

            // =============================================
            // NOTIFICATION TYPE CONFIGURATION
            // =============================================
            modelBuilder.Entity<NotificationType>(entity =>
            {
                entity.ToTable("NotificationTypes");
                entity.HasKey(e => e.NotificationTypeId);
                entity.HasIndex(e => e.TypeName).IsUnique();
                entity.HasIndex(e => e.TypeCode).IsUnique();
            });

            // =============================================
            // NOTIFICATION CONFIGURATION
            // =============================================
            modelBuilder.Entity<Notification>(entity =>
            {
                entity.ToTable("Notifications");
                entity.HasKey(e => e.NotificationId);

                entity.HasOne(e => e.User)
                    .WithMany(u => u.Notifications)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(e => e.NotificationType)
                    .WithMany(t => t.Notifications)
                    .HasForeignKey(e => e.NotificationTypeId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Priority)
                    .WithMany(p => p.Notifications)
                    .HasForeignKey(e => e.PriorityId)
                    .OnDelete(DeleteBehavior.SetNull);
            });

            // =============================================
            // REPORT TYPE CONFIGURATION
            // =============================================
            modelBuilder.Entity<ReportType>(entity =>
            {
                entity.ToTable("ReportTypes");
                entity.HasKey(e => e.ReportTypeId);
                entity.HasIndex(e => e.TypeName).IsUnique();
                entity.HasIndex(e => e.TypeCode).IsUnique();
            });

            // =============================================
            // REPORT CONFIGURATION
            // =============================================
            modelBuilder.Entity<Report>(entity =>
            {
                entity.ToTable("Reports");
                entity.HasKey(e => e.ReportId);
                entity.HasIndex(e => e.ReportCode).IsUnique();

                entity.HasOne(e => e.ReportType)
                    .WithMany(t => t.Reports)
                    .HasForeignKey(e => e.ReportTypeId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.GeneratedBy)
                    .WithMany(u => u.Reports)
                    .HasForeignKey(e => e.GeneratedByUserId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // =============================================
            // DEVICE ASSIGNMENT CONFIGURATION
            // =============================================
            modelBuilder.Entity<DeviceAssignment>(entity =>
            {
                entity.ToTable("DeviceAssignments");
                entity.HasKey(e => e.AssignmentId);

                entity.HasOne(e => e.Device)
                    .WithMany(d => d.Assignments)
                    .HasForeignKey(e => e.DeviceId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.Department)
                    .WithMany(d => d.DeviceAssignments)
                    .HasForeignKey(e => e.DepartmentId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.AssignedBy)
                    .WithMany()
                    .HasForeignKey(e => e.AssignedByUserId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // =============================================
            // ATTACHMENT CONFIGURATION
            // =============================================
            modelBuilder.Entity<Attachment>(entity =>
            {
                entity.ToTable("Attachments");
                entity.HasKey(e => e.AttachmentId);

                entity.HasOne(e => e.UploadedBy)
                    .WithMany()
                    .HasForeignKey(e => e.UploadedByUserId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // =============================================
            // AUDIT LOG CONFIGURATION
            // =============================================
            modelBuilder.Entity<AuditLog>(entity =>
            {
                entity.ToTable("AuditLogs");
                entity.HasKey(e => e.AuditLogId);

                entity.HasOne(e => e.User)
                    .WithMany(u => u.AuditLogs)
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.SetNull);
            });

            // =============================================
            // ACTIVITY HISTORY CONFIGURATION
            // =============================================
            modelBuilder.Entity<ActivityHistory>(entity =>
            {
                entity.ToTable("ActivityHistory");
                entity.HasKey(e => e.ActivityId);

                entity.HasOne(e => e.Device)
                    .WithMany(d => d.ActivityHistories)
                    .HasForeignKey(e => e.DeviceId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(e => e.User)
                    .WithMany()
                    .HasForeignKey(e => e.UserId)
                    .OnDelete(DeleteBehavior.SetNull);
            });

            // =============================================
            // GLOBAL QUERY FILTERS (Soft Delete)
            // =============================================
            modelBuilder.Entity<Role>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Department>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<User>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<DeviceCategory>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Manufacturer>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Supplier>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<DeviceStatus>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<RiskLevel>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Device>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<DeviceAccessory>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Priority>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<MaintenanceType>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<RequestStatus>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<MaintenanceRequest>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<MaintenanceLog>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<NotificationType>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Notification>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<ReportType>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Report>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<DeviceAssignment>().HasQueryFilter(e => !e.IsDeleted);
            modelBuilder.Entity<Attachment>().HasQueryFilter(e => !e.IsDeleted);
        }

        // =============================================
        // OVERRIDE SAVE CHANGES FOR AUDIT
        // =============================================
        public override int SaveChanges()
        {
            UpdateTimestamps();
            return base.SaveChanges();
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            UpdateTimestamps();
            return base.SaveChangesAsync(cancellationToken);
        }

        private void UpdateTimestamps()
        {
            var entries = ChangeTracker.Entries()
                .Where(e => e.State == EntityState.Modified);

            foreach (var entry in entries)
            {
                if (entry.Entity.GetType().GetProperty("UpdatedAt") != null)
                {
                    entry.Property("UpdatedAt").CurrentValue = DateTime.UtcNow;
                }
            }
        }
    }
}

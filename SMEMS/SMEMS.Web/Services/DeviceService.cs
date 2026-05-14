using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Devices;

namespace SMEMS.Web.Services
{
    public class DeviceService : IDeviceService
    {
        private readonly SMEMSDbContext _context;

        public DeviceService(SMEMSDbContext context)
        {
            _context = context;
        }

        public async Task<Device?> GetByIdAsync(int id)
        {
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .FirstOrDefaultAsync(d => d.Id == id);
        }

        public async Task<Device?> GetByCodeAsync(string deviceCode)
        {
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .FirstOrDefaultAsync(d => d.DeviceCode == deviceCode);
        }

        public async Task<List<Device>> GetAllAsync()
        {
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .Where(d => d.IsActive)
                .OrderBy(d => d.Name)
                .ToListAsync();
        }

        public async Task<List<Device>> GetByDepartmentAsync(int departmentId)
        {
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .Where(d => d.DepartmentId == departmentId && d.IsActive)
                .OrderBy(d => d.Name)
                .ToListAsync();
        }

        public async Task<List<Device>> GetByStatusAsync(string statusName)
        {
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .Where(d => d.Status!.Name == statusName && d.IsActive)
                .OrderBy(d => d.Name)
                .ToListAsync();
        }

        public async Task<DeviceListViewModel> GetDeviceListAsync(string? searchTerm, int? departmentId, int? statusId, int? riskLevelId, int page, int pageSize, int? userDepartmentId = null)
        {
            var query = _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .Where(d => d.IsActive)
                .AsQueryable();

            // Filter by user's department if specified (for staff)
            if (userDepartmentId.HasValue)
                query = query.Where(d => d.DepartmentId == userDepartmentId.Value);

            // Apply filters
            if (!string.IsNullOrEmpty(searchTerm))
            {
                searchTerm = searchTerm.ToLower();
                query = query.Where(d =>
                    d.DeviceCode.ToLower().Contains(searchTerm) ||
                    d.Name.ToLower().Contains(searchTerm) ||
                    (d.Model != null && d.Model.ToLower().Contains(searchTerm)) ||
                    (d.SerialNumber != null && d.SerialNumber.ToLower().Contains(searchTerm)));
            }

            if (departmentId.HasValue)
                query = query.Where(d => d.DepartmentId == departmentId.Value);

            if (statusId.HasValue)
                query = query.Where(d => d.StatusId == statusId.Value);

            if (riskLevelId.HasValue)
                query = query.Where(d => d.RiskLevelId == riskLevelId.Value);

            // Get total count
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Get paginated results
            var devices = await query
                .OrderBy(d => d.Name)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Get stats (for all active devices, respecting userDepartmentId filter)
            var statsQuery = _context.Devices.Where(d => d.IsActive);
            if (userDepartmentId.HasValue)
                statsQuery = statsQuery.Where(d => d.DepartmentId == userDepartmentId.Value);

            return new DeviceListViewModel
            {
                Devices = devices.Select(d => new DeviceItemViewModel
                {
                    Id = d.Id,
                    DeviceCode = d.DeviceCode,
                    Name = d.Name,
                    Model = d.Model,
                    SerialNumber = d.SerialNumber,
                    Manufacturer = d.Manufacturer,
                    Department = d.Department?.Name,
                    DepartmentId = d.DepartmentId,
                    Location = d.Location,
                    Status = d.Status?.DisplayName ?? "",
                    StatusCss = d.Status?.CssClass ?? "",
                    RiskLevel = d.RiskLevel?.DisplayName,
                    RiskCss = d.RiskLevel?.CssClass,
                    PurchaseDate = d.PurchaseDate,
                    WarrantyExpiry = d.WarrantyExpiry,
                    NextMaintenanceDate = d.NextMaintenanceDate,
                    FailureCount = d.FailureCount,
                    IsActive = d.IsActive
                }).ToList(),
                Departments = await _context.Departments.Where(dep => dep.IsActive).ToListAsync(),
                Statuses = await _context.DeviceStatuses.ToListAsync(),
                RiskLevels = await _context.RiskLevels.OrderBy(r => r.Priority).ToListAsync(),
                SearchTerm = searchTerm,
                DepartmentId = departmentId,
                StatusId = statusId,
                RiskLevelId = riskLevelId,
                CurrentPage = page,
                TotalPages = totalPages,
                TotalItems = totalItems,
                PageSize = pageSize,
                TotalDevices = await statsQuery.CountAsync(),
                OperationalCount = await statsQuery.CountAsync(d => d.Status!.Name == "operational"),
                MaintenanceNeededCount = await statsQuery.CountAsync(d => d.Status!.Name == "maintenance_needed"),
                UnderMaintenanceCount = await statsQuery.CountAsync(d => d.Status!.Name == "under_maintenance"),
                OutOfServiceCount = await statsQuery.CountAsync(d => d.Status!.Name == "out_of_service")
            };
        }

        public async Task<DeviceDetailsViewModel?> GetDeviceDetailsAsync(int id)
        {
            var device = await GetByIdAsync(id);
            if (device == null) return null;

            var maintenanceHistory = await _context.MaintenanceRecords
                .Include(mr => mr.Type)
                .Include(mr => mr.PerformedBy)
                .Where(mr => mr.DeviceId == id)
                .OrderByDescending(mr => mr.MaintenanceDate)
                .Take(10)
                .ToListAsync();

            var activeRequests = await _context.MaintenanceRequests
                .Include(mr => mr.Status)
                .Where(mr => mr.DeviceId == id && mr.Status!.Name != "completed" && mr.Status!.Name != "cancelled")
                .OrderByDescending(mr => mr.RequestDate)
                .ToListAsync();

            return new DeviceDetailsViewModel
            {
                Id = device.Id,
                DeviceCode = device.DeviceCode,
                Name = device.Name,
                Model = device.Model,
                SerialNumber = device.SerialNumber,
                Manufacturer = device.Manufacturer,
                Supplier = device.Supplier,
                Department = device.Department?.Name,
                Location = device.Location,
                Status = device.Status?.DisplayName ?? "",
                StatusCss = device.Status?.CssClass ?? "",
                RiskLevel = device.RiskLevel?.DisplayName,
                RiskCss = device.RiskLevel?.CssClass,
                PurchaseDate = device.PurchaseDate,
                WarrantyExpiry = device.WarrantyExpiry,
                ExpectedLifespan = device.ExpectedLifespan,
                FailureCount = device.FailureCount,
                LastMaintenanceDate = device.LastMaintenanceDate,
                NextMaintenanceDate = device.NextMaintenanceDate,
                MaintenanceIntervalDays = device.MaintenanceIntervalDays,
                Accessories = device.Accessories,
                Notes = device.Notes,
                ImagePath = device.ImagePath,
                MaintenanceHistory = maintenanceHistory.Select(mh => new MaintenanceHistoryItem
                {
                    Id = mh.Id,
                    Type = mh.Type?.DisplayName ?? "",
                    MaintenanceDate = mh.MaintenanceDate,
                    Description = mh.Description,
                    PerformedBy = mh.PerformedBy?.FullName ?? ""
                }).ToList(),
                ActiveRequests = activeRequests.Select(ar => new MaintenanceRequestItem
                {
                    Id = ar.Id,
                    RequestCode = ar.RequestCode,
                    Issue = ar.Issue,
                    Status = ar.Status?.DisplayName ?? "",
                    StatusCss = ar.Status?.CssClass ?? "",
                    RequestDate = ar.RequestDate
                }).ToList()
            };
        }

        public async Task<Device> CreateAsync(AddDeviceViewModel model)
        {
            var device = new Device
            {
                DeviceCode = model.DeviceCode,
                Name = model.Name,
                Model = model.Model,
                SerialNumber = model.SerialNumber,
                Manufacturer = model.Manufacturer,
                Supplier = model.Supplier,
                DepartmentId = model.DepartmentId,
                Location = model.Location,
                StatusId = model.StatusId,
                RiskLevelId = model.RiskLevelId,
                PurchaseDate = model.PurchaseDate,
                WarrantyExpiry = model.WarrantyExpiry,
                ExpectedLifespan = model.ExpectedLifespan,
                MaintenanceIntervalDays = model.MaintenanceIntervalDays,
                Accessories = model.Accessories,
                Notes = model.Notes,
                NextMaintenanceDate = model.PurchaseDate?.AddDays(model.MaintenanceIntervalDays),
                IsActive = true,
                CreatedAt = DateTime.Now
            };

            _context.Devices.Add(device);
            await _context.SaveChangesAsync();

            return device;
        }

        public async Task<bool> UpdateAsync(EditDeviceViewModel model)
        {
            var device = await _context.Devices.FindAsync(model.Id);
            if (device == null) return false;

            device.DeviceCode = model.DeviceCode;
            device.Name = model.Name;
            device.Model = model.Model;
            device.SerialNumber = model.SerialNumber;
            device.Manufacturer = model.Manufacturer;
            device.Supplier = model.Supplier;
            device.DepartmentId = model.DepartmentId;
            device.Location = model.Location;
            device.StatusId = model.StatusId;
            device.RiskLevelId = model.RiskLevelId;
            device.PurchaseDate = model.PurchaseDate;
            device.WarrantyExpiry = model.WarrantyExpiry;
            device.ExpectedLifespan = model.ExpectedLifespan;
            device.MaintenanceIntervalDays = model.MaintenanceIntervalDays;
            device.Accessories = model.Accessories;
            device.Notes = model.Notes;
            device.UpdatedAt = DateTime.Now;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var device = await _context.Devices.FindAsync(id);
            if (device == null) return false;

            device.IsActive = false;
            device.UpdatedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdateStatusAsync(int deviceId, int statusId)
        {
            var device = await _context.Devices.FindAsync(deviceId);
            if (device == null) return false;

            device.StatusId = statusId;
            device.UpdatedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<int> GetDeviceCountByStatusAsync(string statusName)
        {
            return await _context.Devices
                .CountAsync(d => d.Status!.Name == statusName && d.IsActive);
        }

        public async Task<int> GetTotalDeviceCountAsync()
        {
            return await _context.Devices.CountAsync(d => d.IsActive);
        }

        public async Task<Dictionary<string, int>> GetDeviceCountByDepartmentAsync()
        {
            return await _context.Devices
                .Where(d => d.IsActive && d.DepartmentId != null)
                .GroupBy(d => d.Department!.Name)
                .Select(g => new { Department = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.Department, x => x.Count);
        }

        public async Task<List<Device>> GetDevicesNeedingMaintenanceAsync()
        {
            var today = DateTime.Today;
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .Where(d => d.IsActive && 
                    (d.Status!.Name == "maintenance_needed" || 
                     (d.NextMaintenanceDate != null && d.NextMaintenanceDate <= today)))
                .OrderBy(d => d.NextMaintenanceDate)
                .ToListAsync();
        }

        public async Task<List<Device>> GetCriticalDevicesAsync()
        {
            return await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Include(d => d.RiskLevel)
                .Where(d => d.IsActive && d.RiskLevel!.Name == "critical")
                .OrderBy(d => d.Name)
                .ToListAsync();
        }

        public async Task<string> GenerateDeviceCodeAsync()
        {
            var lastDevice = await _context.Devices
                .OrderByDescending(d => d.Id)
                .FirstOrDefaultAsync();

            int nextNumber = 1;
            if (lastDevice != null)
            {
                var code = lastDevice.DeviceCode;
                if (code.StartsWith("DEV") && int.TryParse(code.Substring(3), out int num))
                {
                    nextNumber = num + 1;
                }
            }

            return $"DEV{nextNumber:D3}";
        }
    }
}

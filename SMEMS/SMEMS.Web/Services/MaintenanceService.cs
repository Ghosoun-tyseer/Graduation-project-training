using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Maintenance;

namespace SMEMS.Web.Services
{
    public class MaintenanceService : IMaintenanceService
    {
        private readonly SMEMSDbContext _context;

        public MaintenanceService(SMEMSDbContext context)
        {
            _context = context;
        }

        public async Task<MaintenanceRequest?> GetByIdAsync(int id)
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.AssignedEngineer)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .FirstOrDefaultAsync(mr => mr.Id == id);
        }

        public async Task<MaintenanceRequest?> GetByCodeAsync(string requestCode)
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.AssignedEngineer)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .FirstOrDefaultAsync(mr => mr.RequestCode == requestCode);
        }

        public async Task<List<MaintenanceRequest>> GetAllAsync()
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.AssignedEngineer)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .OrderByDescending(mr => mr.RequestDate)
                .ToListAsync();
        }

        public async Task<List<MaintenanceRequest>> GetByEngineerAsync(int engineerId)
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .Where(mr => mr.AssignedEngineerId == engineerId)
                .OrderByDescending(mr => mr.RequestDate)
                .ToListAsync();
        }

        public async Task<List<MaintenanceRequest>> GetByRequesterAsync(int requesterId)
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.AssignedEngineer)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .Where(mr => mr.RequestedById == requesterId)
                .OrderByDescending(mr => mr.RequestDate)
                .ToListAsync();
        }

        public async Task<List<MaintenanceRequest>> GetPendingAsync()
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .Where(mr => mr.Status!.Name == "pending")
                .OrderByDescending(mr => mr.RequestDate)
                .ToListAsync();
        }

        public async Task<MaintenanceListViewModel> GetMaintenanceListAsync(string? searchTerm, int? statusId, int? typeId, int? departmentId, string? priority, int page, int pageSize, int? engineerId = null, int? requesterId = null)
        {
            var query = _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.AssignedEngineer)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .AsQueryable();

            // Filter by engineer or requester if specified
            if (engineerId.HasValue)
                query = query.Where(mr => mr.AssignedEngineerId == engineerId.Value);

            if (requesterId.HasValue)
                query = query.Where(mr => mr.RequestedById == requesterId.Value);

            // Apply filters
            if (!string.IsNullOrEmpty(searchTerm))
            {
                searchTerm = searchTerm.ToLower();
                query = query.Where(mr =>
                    mr.RequestCode.ToLower().Contains(searchTerm) ||
                    mr.Device!.Name.ToLower().Contains(searchTerm) ||
                    mr.Device.DeviceCode.ToLower().Contains(searchTerm) ||
                    mr.Issue.ToLower().Contains(searchTerm));
            }

            if (statusId.HasValue)
                query = query.Where(mr => mr.StatusId == statusId.Value);

            if (typeId.HasValue)
                query = query.Where(mr => mr.TypeId == typeId.Value);

            if (departmentId.HasValue)
                query = query.Where(mr => mr.Device!.DepartmentId == departmentId.Value);

            if (!string.IsNullOrEmpty(priority))
                query = query.Where(mr => mr.Priority == priority);

            // Get total count
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Get paginated results
            var requests = await query
                .OrderByDescending(mr => mr.RequestDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Get stats
            var statsQuery = _context.MaintenanceRequests.AsQueryable();
            if (engineerId.HasValue)
                statsQuery = statsQuery.Where(mr => mr.AssignedEngineerId == engineerId.Value);
            if (requesterId.HasValue)
                statsQuery = statsQuery.Where(mr => mr.RequestedById == requesterId.Value);

            return new MaintenanceListViewModel
            {
                Requests = requests.Select(mr => new MaintenanceRequestItemViewModel
                {
                    Id = mr.Id,
                    RequestCode = mr.RequestCode,
                    DeviceCode = mr.Device?.DeviceCode ?? "",
                    DeviceName = mr.Device?.Name ?? "",
                    Department = mr.Device?.Department?.Name ?? "",
                    Issue = mr.Issue,
                    Description = mr.Description,
                    Type = mr.Type?.DisplayName ?? "",
                    Status = mr.Status?.DisplayName ?? "",
                    StatusCss = mr.Status?.CssClass ?? "",
                    Priority = mr.Priority,
                    RequestedBy = mr.RequestedBy?.FullName ?? "",
                    AssignedTo = mr.AssignedEngineer?.FullName,
                    RequestDate = mr.RequestDate,
                    StartDate = mr.StartDate,
                    CompletionDate = mr.CompletionDate,
                    HasAlternative = mr.HasAlternative
                }).ToList(),
                Statuses = await _context.MaintenanceStatuses.ToListAsync(),
                Types = await _context.MaintenanceTypes.ToListAsync(),
                Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync(),
                SearchTerm = searchTerm,
                StatusId = statusId,
                TypeId = typeId,
                DepartmentId = departmentId,
                Priority = priority,
                CurrentPage = page,
                TotalPages = totalPages,
                TotalItems = totalItems,
                PageSize = pageSize,
                PendingCount = await statsQuery.CountAsync(mr => mr.Status!.Name == "pending" || mr.Status!.Name == "assigned"),
                InProgressCount = await statsQuery.CountAsync(mr => mr.Status!.Name == "in_progress"),
                CompletedCount = await statsQuery.CountAsync(mr => mr.Status!.Name == "completed"),
                TotalCount = await statsQuery.CountAsync()
            };
        }

        public async Task<MaintenanceDetailsViewModel?> GetMaintenanceDetailsAsync(int id)
        {
            var request = await GetByIdAsync(id);
            if (request == null) return null;

            return new MaintenanceDetailsViewModel
            {
                Id = request.Id,
                RequestCode = request.RequestCode,
                DeviceId = request.DeviceId,
                DeviceCode = request.Device?.DeviceCode ?? "",
                DeviceName = request.Device?.Name ?? "",
                DeviceModel = request.Device?.Model,
                DeviceLocation = request.Device?.Location,
                Department = request.Device?.Department?.Name ?? "",
                Issue = request.Issue,
                Description = request.Description,
                Type = request.Type?.DisplayName ?? "",
                Status = request.Status?.DisplayName ?? "",
                StatusCss = request.Status?.CssClass ?? "",
                Priority = request.Priority,
                HasAlternative = request.HasAlternative,
                AlternativeDescription = request.AlternativeDescription,
                RequestedBy = request.RequestedBy?.FullName ?? "",
                AssignedTo = request.AssignedEngineer?.FullName,
                AssignedEngineerId = request.AssignedEngineerId,
                RequestDate = request.RequestDate,
                AssignedDate = request.AssignedDate,
                StartDate = request.StartDate,
                ExpectedCompletionDate = request.ExpectedCompletionDate,
                CompletionDate = request.CompletionDate,
                EngineerNotes = request.EngineerNotes,
                Resolution = request.Resolution,
                PartsUsed = request.PartsUsed,
                Cost = request.Cost,
                Engineers = await _context.Users
                    .Include(u => u.Role)
                    .Where(u => u.Role!.Name == "engineer" && u.IsActive)
                    .ToListAsync()
            };
        }

        public async Task<MaintenanceRequest> CreateAsync(CreateMaintenanceRequestViewModel model, int requestedById)
        {
            var request = new MaintenanceRequest
            {
                RequestCode = await GenerateRequestCodeAsync(),
                DeviceId = model.DeviceId,
                RequestedById = requestedById,
                TypeId = model.TypeId,
                StatusId = (await _context.MaintenanceStatuses.FirstAsync(s => s.Name == "pending")).Id,
                Priority = model.Priority,
                Issue = model.Issue,
                Description = model.Description,
                HasAlternative = model.HasAlternative,
                AlternativeDescription = model.AlternativeDescription,
                RequestDate = DateTime.Now,
                CreatedAt = DateTime.Now
            };

            _context.MaintenanceRequests.Add(request);

            // Update device status to maintenance_needed
            var device = await _context.Devices.FindAsync(model.DeviceId);
            if (device != null)
            {
                var maintenanceNeededStatus = await _context.DeviceStatuses.FirstAsync(s => s.Name == "maintenance_needed");
                device.StatusId = maintenanceNeededStatus.Id;
            }

            await _context.SaveChangesAsync();

            return request;
        }

        public async Task<bool> AssignEngineerAsync(int requestId, int engineerId, DateTime? expectedCompletion)
        {
            var request = await _context.MaintenanceRequests.FindAsync(requestId);
            if (request == null) return false;

            var assignedStatus = await _context.MaintenanceStatuses.FirstAsync(s => s.Name == "assigned");

            request.AssignedEngineerId = engineerId;
            request.StatusId = assignedStatus.Id;
            request.AssignedDate = DateTime.Now;
            request.ExpectedCompletionDate = expectedCompletion;
            request.UpdatedAt = DateTime.Now;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> StartMaintenanceAsync(int requestId, string? notes)
        {
            var request = await _context.MaintenanceRequests.FindAsync(requestId);
            if (request == null) return false;

            var inProgressStatus = await _context.MaintenanceStatuses.FirstAsync(s => s.Name == "in_progress");
            var underMaintenanceDeviceStatus = await _context.DeviceStatuses.FirstAsync(s => s.Name == "under_maintenance");

            request.StatusId = inProgressStatus.Id;
            request.StartDate = DateTime.Now;
            request.EngineerNotes = notes;
            request.UpdatedAt = DateTime.Now;

            // Update device status
            var device = await _context.Devices.FindAsync(request.DeviceId);
            if (device != null)
            {
                device.StatusId = underMaintenanceDeviceStatus.Id;
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> CompleteMaintenanceAsync(CompleteMaintenanceViewModel model, int engineerId)
        {
            var request = await _context.MaintenanceRequests.FindAsync(model.RequestId);
            if (request == null) return false;

            var completedStatus = await _context.MaintenanceStatuses.FirstAsync(s => s.Name == "completed");
            var operationalDeviceStatus = await _context.DeviceStatuses.FirstAsync(s => s.Name == "operational");

            request.StatusId = completedStatus.Id;
            request.CompletionDate = DateTime.Now;
            request.Resolution = model.Resolution;
            request.PartsUsed = model.PartsUsed;
            request.Cost = model.Cost;
            request.EngineerNotes = model.EngineerNotes;
            request.UpdatedAt = DateTime.Now;

            // Update device
            var device = await _context.Devices.FindAsync(request.DeviceId);
            if (device != null)
            {
                device.StatusId = operationalDeviceStatus.Id;
                device.LastMaintenanceDate = DateTime.Now;
                device.NextMaintenanceDate = model.NextMaintenanceDate ?? DateTime.Now.AddDays(device.MaintenanceIntervalDays);
            }

            // Create maintenance record
            var record = new MaintenanceRecord
            {
                DeviceId = request.DeviceId,
                MaintenanceRequestId = request.Id,
                TypeId = request.TypeId,
                MaintenanceDate = DateTime.Now,
                Description = model.Resolution,
                Actions = model.Resolution,
                PartsReplaced = model.PartsUsed,
                Cost = model.Cost,
                PerformedById = engineerId,
                NextScheduledDate = model.NextMaintenanceDate,
                Notes = model.EngineerNotes,
                CreatedAt = DateTime.Now
            };

            _context.MaintenanceRecords.Add(record);

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> CancelAsync(int requestId, string reason)
        {
            var request = await _context.MaintenanceRequests.FindAsync(requestId);
            if (request == null) return false;

            var cancelledStatus = await _context.MaintenanceStatuses.FirstAsync(s => s.Name == "cancelled");

            request.StatusId = cancelledStatus.Id;
            request.EngineerNotes = reason;
            request.UpdatedAt = DateTime.Now;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<int> GetCountByStatusAsync(string statusName)
        {
            return await _context.MaintenanceRequests
                .CountAsync(mr => mr.Status!.Name == statusName);
        }

        public async Task<int> GetCountByEngineerAndStatusAsync(int engineerId, string statusName)
        {
            return await _context.MaintenanceRequests
                .CountAsync(mr => mr.AssignedEngineerId == engineerId && mr.Status!.Name == statusName);
        }

        public async Task<Dictionary<string, int>> GetMaintenanceByMonthAsync(int year)
        {
            var result = await _context.MaintenanceRequests
                .Where(mr => mr.RequestDate.Year == year)
                .GroupBy(mr => mr.RequestDate.Month)
                .Select(g => new { Month = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => GetMonthName(x.Month), x => x.Count);

            return result;
        }

        private static string GetMonthName(int month)
        {
            return month switch
            {
                1 => "Jan", 2 => "Feb", 3 => "Mar", 4 => "Apr",
                5 => "May", 6 => "Jun", 7 => "Jul", 8 => "Aug",
                9 => "Sep", 10 => "Oct", 11 => "Nov", 12 => "Dec",
                _ => ""
            };
        }

        public async Task<List<MaintenanceRequest>> GetUrgentRequestsAsync()
        {
            return await _context.MaintenanceRequests
                .Include(mr => mr.Device).ThenInclude(d => d!.Department)
                .Include(mr => mr.RequestedBy)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .Where(mr => (mr.Priority == "high" || mr.Priority == "critical") &&
                             mr.Status!.Name != "completed" && mr.Status!.Name != "cancelled")
                .OrderByDescending(mr => mr.Priority == "critical")
                .ThenByDescending(mr => mr.RequestDate)
                .ToListAsync();
        }

        public async Task<string> GenerateRequestCodeAsync()
        {
            var lastRequest = await _context.MaintenanceRequests
                .OrderByDescending(mr => mr.Id)
                .FirstOrDefaultAsync();

            int nextNumber = 1;
            if (lastRequest != null)
            {
                var code = lastRequest.RequestCode;
                if (code.StartsWith("MR") && int.TryParse(code.Substring(2), out int num))
                {
                    nextNumber = num + 1;
                }
            }

            return $"MR{nextNumber:D3}";
        }
    }
}

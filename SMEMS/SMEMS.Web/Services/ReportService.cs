using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Services
{
    public class ReportService : IReportService
    {
        private readonly SMEMSDbContext _context;

        public ReportService(SMEMSDbContext context)
        {
            _context = context;
        }

        public async Task<ReportViewModel> GenerateReportAsync(DateTime startDate, DateTime endDate, string reportType)
        {
            var report = new ReportViewModel
            {
                StartDate = startDate,
                EndDate = endDate,
                ReportType = reportType,
                TotalDevices = await _context.Devices.CountAsync(d => d.IsActive),
                TotalMaintenanceRequests = await _context.MaintenanceRequests
                    .CountAsync(mr => mr.RequestDate >= startDate && mr.RequestDate <= endDate),
                CompletedMaintenances = await _context.MaintenanceRequests
                    .CountAsync(mr => mr.CompletionDate >= startDate && mr.CompletionDate <= endDate && mr.Status!.Name == "completed"),
                PendingMaintenances = await _context.MaintenanceRequests
                    .CountAsync(mr => mr.Status!.Name == "pending" || mr.Status!.Name == "assigned" || mr.Status!.Name == "in_progress"),
                TotalMaintenanceCost = await GetTotalMaintenanceCostAsync(startDate, endDate),
                MaintenanceByMonth = await GetMaintenanceByMonthAsync(startDate, endDate),
                DevicesByStatus = await GetDevicesByStatusAsync(),
                MaintenanceByType = await GetMaintenanceByTypeAsync(startDate, endDate),
                MaintenanceByDepartment = await GetMaintenanceByDepartmentAsync(startDate, endDate)
            };

            // Get detailed lists if needed
            if (reportType == "detailed")
            {
                report.Devices = await GetDeviceReportItemsAsync();
                report.Maintenances = await GetMaintenanceReportItemsAsync(startDate, endDate);
            }

            return report;
        }

        public async Task<Dictionary<string, int>> GetDevicesByStatusAsync()
        {
            return await _context.Devices
                .Where(d => d.IsActive)
                .GroupBy(d => d.Status!.DisplayName)
                .Select(g => new { Status = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.Status, x => x.Count);
        }

        public async Task<Dictionary<string, int>> GetMaintenanceByTypeAsync(DateTime startDate, DateTime endDate)
        {
            return await _context.MaintenanceRequests
                .Where(mr => mr.RequestDate >= startDate && mr.RequestDate <= endDate)
                .GroupBy(mr => mr.Type!.DisplayName)
                .Select(g => new { Type = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.Type, x => x.Count);
        }

        public async Task<Dictionary<string, int>> GetMaintenanceByDepartmentAsync(DateTime startDate, DateTime endDate)
        {
            return await _context.MaintenanceRequests
                .Where(mr => mr.RequestDate >= startDate && mr.RequestDate <= endDate && mr.Device!.DepartmentId != null)
                .GroupBy(mr => mr.Device!.Department!.Name)
                .Select(g => new { Department = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.Department, x => x.Count);
        }

        public async Task<decimal> GetTotalMaintenanceCostAsync(DateTime startDate, DateTime endDate)
        {
            return await _context.MaintenanceRequests
                .Where(mr => mr.CompletionDate >= startDate && mr.CompletionDate <= endDate && mr.Cost.HasValue)
                .SumAsync(mr => mr.Cost ?? 0);
        }

        private async Task<Dictionary<string, int>> GetMaintenanceByMonthAsync(DateTime startDate, DateTime endDate)
        {
            var result = await _context.MaintenanceRequests
                .Where(mr => mr.RequestDate >= startDate && mr.RequestDate <= endDate)
                .GroupBy(mr => new { mr.RequestDate.Year, mr.RequestDate.Month })
                .Select(g => new { g.Key.Year, g.Key.Month, Count = g.Count() })
                .ToListAsync();

            return result.ToDictionary(
                x => $"{GetMonthName(x.Month)} {x.Year}",
                x => x.Count
            );
        }

        private async Task<List<DeviceReportItem>> GetDeviceReportItemsAsync()
        {
            var devices = await _context.Devices
                .Include(d => d.Department)
                .Include(d => d.Status)
                .Where(d => d.IsActive)
                .ToListAsync();

            var result = new List<DeviceReportItem>();

            foreach (var device in devices)
            {
                var maintenanceCount = await _context.MaintenanceRequests
                    .CountAsync(mr => mr.DeviceId == device.Id);

                var totalCost = await _context.MaintenanceRequests
                    .Where(mr => mr.DeviceId == device.Id && mr.Cost.HasValue)
                    .SumAsync(mr => mr.Cost ?? 0);

                result.Add(new DeviceReportItem
                {
                    DeviceCode = device.DeviceCode,
                    Name = device.Name,
                    Department = device.Department?.Name ?? "",
                    Status = device.Status?.DisplayName ?? "",
                    MaintenanceCount = maintenanceCount,
                    FailureCount = device.FailureCount,
                    TotalCost = totalCost
                });
            }

            return result.OrderByDescending(d => d.MaintenanceCount).ToList();
        }

        private async Task<List<MaintenanceReportItem>> GetMaintenanceReportItemsAsync(DateTime startDate, DateTime endDate)
        {
            var maintenances = await _context.MaintenanceRequests
                .Include(mr => mr.Device)
                .Include(mr => mr.Type)
                .Include(mr => mr.Status)
                .Include(mr => mr.AssignedEngineer)
                .Where(mr => mr.RequestDate >= startDate && mr.RequestDate <= endDate)
                .OrderByDescending(mr => mr.RequestDate)
                .ToListAsync();

            return maintenances.Select(mr => new MaintenanceReportItem
            {
                RequestCode = mr.RequestCode,
                DeviceName = mr.Device?.Name ?? "",
                Type = mr.Type?.DisplayName ?? "",
                Status = mr.Status?.DisplayName ?? "",
                Engineer = mr.AssignedEngineer?.FullName ?? "Unassigned",
                RequestDate = mr.RequestDate,
                CompletionDate = mr.CompletionDate,
                Cost = mr.Cost
            }).ToList();
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
    }
}

using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Services
{
    public interface IReportService
    {
        Task<ReportViewModel> GenerateReportAsync(DateTime startDate, DateTime endDate, string reportType);
        Task<Dictionary<string, int>> GetDevicesByStatusAsync();
        Task<Dictionary<string, int>> GetMaintenanceByTypeAsync(DateTime startDate, DateTime endDate);
        Task<Dictionary<string, int>> GetMaintenanceByDepartmentAsync(DateTime startDate, DateTime endDate);
        Task<decimal> GetTotalMaintenanceCostAsync(DateTime startDate, DateTime endDate);
    }
}

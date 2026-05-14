using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Maintenance;

namespace SMEMS.Web.Services
{
    public interface IMaintenanceService
    {
        Task<MaintenanceRequest?> GetByIdAsync(int id);
        Task<MaintenanceRequest?> GetByCodeAsync(string requestCode);
        Task<List<MaintenanceRequest>> GetAllAsync();
        Task<List<MaintenanceRequest>> GetByEngineerAsync(int engineerId);
        Task<List<MaintenanceRequest>> GetByRequesterAsync(int requesterId);
        Task<List<MaintenanceRequest>> GetPendingAsync();
        Task<MaintenanceListViewModel> GetMaintenanceListAsync(string? searchTerm, int? statusId, int? typeId, int? departmentId, string? priority, int page, int pageSize, int? engineerId = null, int? requesterId = null);
        Task<MaintenanceDetailsViewModel?> GetMaintenanceDetailsAsync(int id);
        Task<MaintenanceRequest> CreateAsync(CreateMaintenanceRequestViewModel model, int requestedById);
        Task<bool> AssignEngineerAsync(int requestId, int engineerId, DateTime? expectedCompletion);
        Task<bool> StartMaintenanceAsync(int requestId, string? notes);
        Task<bool> CompleteMaintenanceAsync(CompleteMaintenanceViewModel model, int engineerId);
        Task<bool> CancelAsync(int requestId, string reason);
        Task<int> GetCountByStatusAsync(string statusName);
        Task<int> GetCountByEngineerAndStatusAsync(int engineerId, string statusName);
        Task<Dictionary<string, int>> GetMaintenanceByMonthAsync(int year);
        Task<List<MaintenanceRequest>> GetUrgentRequestsAsync();
        Task<string> GenerateRequestCodeAsync();
    }
}

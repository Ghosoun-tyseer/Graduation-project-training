using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Devices;

namespace SMEMS.Web.Services
{
    public interface IDeviceService
    {
        Task<Device?> GetByIdAsync(int id);
        Task<Device?> GetByCodeAsync(string deviceCode);
        Task<List<Device>> GetAllAsync();
        Task<List<Device>> GetByDepartmentAsync(int departmentId);
        Task<List<Device>> GetByStatusAsync(string statusName);
        Task<DeviceListViewModel> GetDeviceListAsync(string? searchTerm, int? departmentId, int? statusId, int? riskLevelId, int page, int pageSize, int? userDepartmentId = null);
        Task<DeviceDetailsViewModel?> GetDeviceDetailsAsync(int id);
        Task<Device> CreateAsync(AddDeviceViewModel model);
        Task<bool> UpdateAsync(EditDeviceViewModel model);
        Task<bool> DeleteAsync(int id);
        Task<bool> UpdateStatusAsync(int deviceId, int statusId);
        Task<int> GetDeviceCountByStatusAsync(string statusName);
        Task<int> GetTotalDeviceCountAsync();
        Task<Dictionary<string, int>> GetDeviceCountByDepartmentAsync();
        Task<List<Device>> GetDevicesNeedingMaintenanceAsync();
        Task<List<Device>> GetCriticalDevicesAsync();
        Task<string> GenerateDeviceCodeAsync();
    }
}

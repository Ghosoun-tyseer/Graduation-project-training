using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Users;

namespace SMEMS.Web.Services
{
    public interface IUserService
    {
        Task<User?> AuthenticateAsync(string username, string password);
        Task<User?> GetByIdAsync(int id);
        Task<User?> GetByUsernameAsync(string username);
        Task<List<User>> GetAllAsync();
        Task<List<User>> GetByRoleAsync(string roleName);
        Task<List<User>> GetEngineersAsync();
        Task<UserListViewModel> GetUserListAsync(string? searchTerm, int? roleId, int? departmentId, bool? isActive, int page, int pageSize);
        Task<UserDetailsViewModel?> GetUserDetailsAsync(int id);
        Task<User> CreateAsync(AddUserViewModel model);
        Task<bool> UpdateAsync(EditUserViewModel model);
        Task<bool> DeleteAsync(int id);
        Task<bool> ToggleActiveAsync(int id);
        Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword);
        Task<bool> ResetPasswordAsync(int userId, string newPassword);
        Task UpdateLastLoginAsync(int userId);
        Task<bool> UsernameExistsAsync(string username, int? excludeId = null);
        Task<bool> EmailExistsAsync(string email, int? excludeId = null);
        Task<int> GetUserCountByRoleAsync(string roleName);
    }
}

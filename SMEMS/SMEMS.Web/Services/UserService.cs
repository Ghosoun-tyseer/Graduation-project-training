using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Users;

namespace SMEMS.Web.Services
{
    public class UserService : IUserService
    {
        private readonly SMEMSDbContext _context;

        public UserService(SMEMSDbContext context)
        {
            _context = context;
        }

        public async Task<User?> AuthenticateAsync(string username, string password)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Department)
                .FirstOrDefaultAsync(u => u.Username == username && u.IsActive);

            if (user == null)
                return null;

            // Verify password using BCrypt
            if (!BCrypt.Net.BCrypt.Verify(password, user.PasswordHash))
                return null;

            return user;
        }

        public async Task<User?> GetByIdAsync(int id)
        {
            return await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Department)
                .FirstOrDefaultAsync(u => u.Id == id);
        }

        public async Task<User?> GetByUsernameAsync(string username)
        {
            return await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Department)
                .FirstOrDefaultAsync(u => u.Username == username);
        }

        public async Task<List<User>> GetAllAsync()
        {
            return await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Department)
                .OrderBy(u => u.FullName)
                .ToListAsync();
        }

        public async Task<List<User>> GetByRoleAsync(string roleName)
        {
            return await _context.Users
                .Include(u => u.Role)
                .Include(u => u.Department)
                .Where(u => u.Role!.Name == roleName && u.IsActive)
                .OrderBy(u => u.FullName)
                .ToListAsync();
        }

        public async Task<List<User>> GetEngineersAsync()
        {
            return await GetByRoleAsync("engineer");
        }

        public async Task<UserListViewModel> GetUserListAsync(string? searchTerm, int? roleId, int? departmentId, bool? isActive, int page, int pageSize)
        {
            var query = _context.Users
                .Include(u => u.Role)
                .Include(u => u.Department)
                .AsQueryable();

            // Apply filters
            if (!string.IsNullOrEmpty(searchTerm))
            {
                searchTerm = searchTerm.ToLower();
                query = query.Where(u => 
                    u.Username.ToLower().Contains(searchTerm) ||
                    u.FullName.ToLower().Contains(searchTerm) ||
                    u.Email.ToLower().Contains(searchTerm));
            }

            if (roleId.HasValue)
                query = query.Where(u => u.RoleId == roleId.Value);

            if (departmentId.HasValue)
                query = query.Where(u => u.DepartmentId == departmentId.Value);

            if (isActive.HasValue)
                query = query.Where(u => u.IsActive == isActive.Value);

            // Get total count
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Get paginated results
            var users = await query
                .OrderBy(u => u.FullName)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Get stats
            var allUsers = _context.Users.AsQueryable();

            return new UserListViewModel
            {
                Users = users.Select(u => new UserItemViewModel
                {
                    Id = u.Id,
                    Username = u.Username,
                    FullName = u.FullName,
                    Email = u.Email,
                    Phone = u.Phone,
                    Role = u.Role?.Name ?? "",
                    RoleName = u.Role?.DisplayName ?? "",
                    Department = u.Department?.Name,
                    Position = u.Position,
                    JoinDate = u.JoinDate,
                    LastLogin = u.LastLogin,
                    IsActive = u.IsActive
                }).ToList(),
                Roles = await _context.Roles.ToListAsync(),
                Departments = await _context.Departments.Where(d => d.IsActive).ToListAsync(),
                SearchTerm = searchTerm,
                RoleId = roleId,
                DepartmentId = departmentId,
                IsActive = isActive,
                CurrentPage = page,
                TotalPages = totalPages,
                TotalItems = totalItems,
                PageSize = pageSize,
                TotalUsers = await allUsers.CountAsync(),
                AdminCount = await allUsers.CountAsync(u => u.Role!.Name == "admin"),
                EngineerCount = await allUsers.CountAsync(u => u.Role!.Name == "engineer"),
                StaffCount = await allUsers.CountAsync(u => u.Role!.Name == "staff"),
                ActiveCount = await allUsers.CountAsync(u => u.IsActive)
            };
        }

        public async Task<UserDetailsViewModel?> GetUserDetailsAsync(int id)
        {
            var user = await GetByIdAsync(id);
            if (user == null) return null;

            var maintenanceRequests = await _context.MaintenanceRequests
                .Where(mr => mr.RequestedById == id || mr.AssignedEngineerId == id)
                .CountAsync();

            var completedMaintenances = await _context.MaintenanceRequests
                .Where(mr => mr.AssignedEngineerId == id && mr.Status!.Name == "completed")
                .CountAsync();

            return new UserDetailsViewModel
            {
                Id = user.Id,
                Username = user.Username,
                FullName = user.FullName,
                Email = user.Email,
                Phone = user.Phone,
                Role = user.Role?.Name ?? "",
                RoleDisplayName = user.Role?.DisplayName ?? "",
                Department = user.Department?.Name,
                Position = user.Position,
                ProfileImage = user.ProfileImage,
                JoinDate = user.JoinDate,
                LastLogin = user.LastLogin,
                IsActive = user.IsActive,
                CreatedAt = user.CreatedAt,
                TotalMaintenanceRequests = maintenanceRequests,
                CompletedMaintenances = completedMaintenances
            };
        }

        public async Task<User> CreateAsync(AddUserViewModel model)
        {
            var user = new User
            {
                Username = model.Username,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.Password),
                FullName = model.FullName,
                Email = model.Email,
                Phone = model.Phone,
                RoleId = model.RoleId,
                DepartmentId = model.DepartmentId,
                Position = model.Position,
                JoinDate = model.JoinDate ?? DateTime.Now,
                IsActive = true,
                CreatedAt = DateTime.Now
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return user;
        }

        public async Task<bool> UpdateAsync(EditUserViewModel model)
        {
            var user = await _context.Users.FindAsync(model.Id);
            if (user == null) return false;

            user.Username = model.Username;
            user.FullName = model.FullName;
            user.Email = model.Email;
            user.Phone = model.Phone;
            user.RoleId = model.RoleId;
            user.DepartmentId = model.DepartmentId;
            user.Position = model.Position;
            user.IsActive = model.IsActive;
            user.UpdatedAt = DateTime.Now;

            if (!string.IsNullOrEmpty(model.NewPassword))
            {
                user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(model.NewPassword);
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ToggleActiveAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return false;

            user.IsActive = !user.IsActive;
            user.UpdatedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ChangePasswordAsync(int userId, string currentPassword, string newPassword)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return false;

            if (!BCrypt.Net.BCrypt.Verify(currentPassword, user.PasswordHash))
                return false;

            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(newPassword);
            user.UpdatedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ResetPasswordAsync(int userId, string newPassword)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null) return false;

            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(newPassword);
            user.UpdatedAt = DateTime.Now;
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task UpdateLastLoginAsync(int userId)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user != null)
            {
                user.LastLogin = DateTime.Now;
                await _context.SaveChangesAsync();
            }
        }

        public async Task<bool> UsernameExistsAsync(string username, int? excludeId = null)
        {
            var query = _context.Users.Where(u => u.Username == username);
            if (excludeId.HasValue)
                query = query.Where(u => u.Id != excludeId.Value);
            return await query.AnyAsync();
        }

        public async Task<bool> EmailExistsAsync(string email, int? excludeId = null)
        {
            var query = _context.Users.Where(u => u.Email == email);
            if (excludeId.HasValue)
                query = query.Where(u => u.Id != excludeId.Value);
            return await query.AnyAsync();
        }

        public async Task<int> GetUserCountByRoleAsync(string roleName)
        {
            return await _context.Users
                .CountAsync(u => u.Role!.Name == roleName && u.IsActive);
        }
    }
}

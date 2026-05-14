using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Services
{
    public interface INotificationService
    {
        Task<Notification?> GetByIdAsync(int id);
        Task<List<Notification>> GetByUserAsync(int userId, bool unreadOnly = false);
        Task<NotificationListViewModel> GetNotificationListAsync(int userId, bool? isRead, string? type, int page, int pageSize);
        Task<int> GetUnreadCountAsync(int userId);
        Task CreateAsync(int userId, string title, string message, string type, string priority = "medium", string? icon = null, string? relatedEntityType = null, int? relatedEntityId = null, string? actionUrl = null);
        Task CreateForRoleAsync(string roleName, string title, string message, string type, string priority = "medium", string? icon = null);
        Task MarkAsReadAsync(int notificationId);
        Task MarkAllAsReadAsync(int userId);
        Task DeleteAsync(int notificationId);
        Task DeleteOldNotificationsAsync(int daysOld);
    }
}

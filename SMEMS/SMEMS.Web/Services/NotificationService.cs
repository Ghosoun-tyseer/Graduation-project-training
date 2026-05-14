using Microsoft.EntityFrameworkCore;
using SMEMS.Web.Helpers;
using SMEMS.Web.Models;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Services
{
    public class NotificationService : INotificationService
    {
        private readonly SMEMSDbContext _context;

        public NotificationService(SMEMSDbContext context)
        {
            _context = context;
        }

        public async Task<Notification?> GetByIdAsync(int id)
        {
            return await _context.Notifications.FindAsync(id);
        }

        public async Task<List<Notification>> GetByUserAsync(int userId, bool unreadOnly = false)
        {
            var query = _context.Notifications
                .Where(n => n.UserId == userId);

            if (unreadOnly)
                query = query.Where(n => !n.IsRead);

            return await query
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();
        }

        public async Task<NotificationListViewModel> GetNotificationListAsync(int userId, bool? isRead, string? type, int page, int pageSize)
        {
            var query = _context.Notifications
                .Where(n => n.UserId == userId)
                .AsQueryable();

            if (isRead.HasValue)
                query = query.Where(n => n.IsRead == isRead.Value);

            if (!string.IsNullOrEmpty(type))
                query = query.Where(n => n.Type == type);

            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            var notifications = await query
                .OrderByDescending(n => n.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            return new NotificationListViewModel
            {
                Notifications = notifications.Select(n => new NotificationItemViewModel
                {
                    Id = n.Id,
                    Title = n.Title,
                    Message = n.Message,
                    Type = n.Type,
                    Priority = n.Priority,
                    Icon = n.Icon,
                    IsRead = n.IsRead,
                    CreatedAt = n.CreatedAt,
                    TimeAgo = TimeAgoHelper.GetTimeAgo(n.CreatedAt),
                    ActionUrl = n.ActionUrl
                }).ToList(),
                UnreadCount = await GetUnreadCountAsync(userId),
                IsRead = isRead,
                Type = type,
                CurrentPage = page,
                TotalPages = totalPages,
                TotalItems = totalItems,
                PageSize = pageSize
            };
        }

        public async Task<int> GetUnreadCountAsync(int userId)
        {
            return await _context.Notifications
                .CountAsync(n => n.UserId == userId && !n.IsRead);
        }

        public async Task CreateAsync(int userId, string title, string message, string type, string priority = "medium", string? icon = null, string? relatedEntityType = null, int? relatedEntityId = null, string? actionUrl = null)
        {
            var notification = new Notification
            {
                UserId = userId,
                Title = title,
                Message = message,
                Type = type,
                Priority = priority,
                Icon = icon ?? GetDefaultIcon(type),
                RelatedEntityType = relatedEntityType,
                RelatedEntityId = relatedEntityId,
                ActionUrl = actionUrl,
                IsRead = false,
                CreatedAt = DateTime.Now
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
        }

        public async Task CreateForRoleAsync(string roleName, string title, string message, string type, string priority = "medium", string? icon = null)
        {
            var users = await _context.Users
                .Include(u => u.Role)
                .Where(u => u.Role!.Name == roleName && u.IsActive)
                .ToListAsync();

            foreach (var user in users)
            {
                var notification = new Notification
                {
                    UserId = user.Id,
                    Title = title,
                    Message = message,
                    Type = type,
                    Priority = priority,
                    Icon = icon ?? GetDefaultIcon(type),
                    IsRead = false,
                    CreatedAt = DateTime.Now
                };

                _context.Notifications.Add(notification);
            }

            await _context.SaveChangesAsync();
        }

        public async Task MarkAsReadAsync(int notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification != null)
            {
                notification.IsRead = true;
                notification.ReadAt = DateTime.Now;
                await _context.SaveChangesAsync();
            }
        }

        public async Task MarkAllAsReadAsync(int userId)
        {
            var notifications = await _context.Notifications
                .Where(n => n.UserId == userId && !n.IsRead)
                .ToListAsync();

            foreach (var notification in notifications)
            {
                notification.IsRead = true;
                notification.ReadAt = DateTime.Now;
            }

            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification != null)
            {
                _context.Notifications.Remove(notification);
                await _context.SaveChangesAsync();
            }
        }

        public async Task DeleteOldNotificationsAsync(int daysOld)
        {
            var cutoffDate = DateTime.Now.AddDays(-daysOld);
            var oldNotifications = await _context.Notifications
                .Where(n => n.CreatedAt < cutoffDate && n.IsRead)
                .ToListAsync();

            _context.Notifications.RemoveRange(oldNotifications);
            await _context.SaveChangesAsync();
        }

        private static string GetDefaultIcon(string type)
        {
            return type switch
            {
                "maintenance_request" => "fa-tools",
                "maintenance_update" => "fa-wrench",
                "assignment" => "fa-user-check",
                "device_status" => "fa-laptop-medical",
                "user_added" => "fa-user-plus",
                "preventive_due" => "fa-calendar-check",
                _ => "fa-bell"
            };
        }
    }
}

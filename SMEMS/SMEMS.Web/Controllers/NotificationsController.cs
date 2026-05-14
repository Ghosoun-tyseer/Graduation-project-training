using Microsoft.AspNetCore.Mvc;
using SMEMS.Web.Helpers;
using SMEMS.Web.Services;
using SMEMS.Web.ViewModels.Shared;

namespace SMEMS.Web.Controllers
{
    [Authenticated]
    public class NotificationsController : Controller
    {
        private readonly INotificationService _notificationService;

        public NotificationsController(INotificationService notificationService)
        {
            _notificationService = notificationService;
        }

        public async Task<IActionResult> Index(bool? isRead, string? type, int page = 1)
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var model = await _notificationService.GetNotificationListAsync(userId, isRead, type, page, 20);

            ViewBag.CurrentUser = GetCurrentUser();
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            await _notificationService.MarkAsReadAsync(id);
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> MarkAllAsRead()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            await _notificationService.MarkAllAsReadAsync(userId);
            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _notificationService.DeleteAsync(id);
            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<IActionResult> GetUnreadCount()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var count = await _notificationService.GetUnreadCountAsync(userId);
            return Json(new { count });
        }

        [HttpGet]
        public async Task<IActionResult> GetRecentNotifications()
        {
            var userId = HttpContext.Session.GetInt32("UserId") ?? 0;
            var notifications = await _notificationService.GetByUserAsync(userId, false);
            var recent = notifications.Take(5).Select(n => new NotificationItemViewModel
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
            }).ToList();

            return Json(recent);
        }

        private CurrentUserViewModel GetCurrentUser()
        {
            return new CurrentUserViewModel
            {
                Id = HttpContext.Session.GetInt32("UserId") ?? 0,
                Username = HttpContext.Session.GetString("Username") ?? "",
                FullName = HttpContext.Session.GetString("FullName") ?? "",
                Role = HttpContext.Session.GetString("UserRole") ?? "",
                RoleDisplayName = HttpContext.Session.GetString("RoleDisplayName") ?? "",
                Department = HttpContext.Session.GetString("DepartmentName"),
                DepartmentId = HttpContext.Session.GetInt32("DepartmentId"),
                ProfileImage = HttpContext.Session.GetString("ProfileImage")
            };
        }
    }
}

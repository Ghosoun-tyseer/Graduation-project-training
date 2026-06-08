using Microsoft.AspNetCore.Mvc;
using SMEMS.Models;
using BCrypt.Net;

namespace SMEMS.Controllers
{
    public class SeedController : Controller
    {
        private readonly MyDbContext _db;

        public SeedController(MyDbContext db)
        {
            _db = db;
        }

        public IActionResult CreateUsers()
        {
            try
            {
                var admin = new Admin
                {
                    FullName = "System Admin",
                    Username = "admin",
                    Email = "admin@test.com",
                    Phone = "0790000000",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Admin@123"),
                    Position = "Administrator",
                    IsActive = true
                };

                var engineer = new Engineer
                {
                    FullName = "Test Engineer",
                    Username = "engineer1",
                    Email = "engineer@test.com",
                    Phone = "0791111111",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Eng$12"),
                    Position = "Engineer",
                    IsActive = true
                };

                var staff = new Staff
                {
                    FullName = "Test Staff",
                    Username = "staff1",
                    Email = "staff@test.com",
                    Phone = "0792222222",
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword("Staff@14"),
                    Position = "Staff Member",
                    IsActive = true
                };

                _db.Admins.Add(admin);
                _db.Engineers.Add(engineer);
                _db.Staff.Add(staff);

                _db.SaveChanges();

                return Content("SUCCESS");
            }
            catch (Exception ex)
            {
                return Content("ERROR: " + ex.Message);
            }
        }
    }
}
using Microsoft.AspNetCore.Mvc;
using DatabaseLayer.DatabaseModels;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseControllers;

using System.Linq;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using Core.Model;


namespace REST_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly DatabaseContext _context;
        public UsersController(DatabaseContext context)
        {
            _context = context;
        }

        [HttpGet("check")]
        public ActionResult<bool> CheckConnection()
        {
            Console.WriteLine("Connected");
            return Ok(new { status = "online", timestamp = DateTime.UtcNow });
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<DatabaseUser>>> GetUsers()
        {
            return await _context.Users.ToListAsync();
        }


        [HttpGet("{id}")]
        public async Task<ActionResult<DatabaseUser>> GetUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        [HttpPost("login")]
        public async Task<ActionResult<DatabaseUser>> Login([FromBody] LoginRequest loginData)
        {
            Console.WriteLine("Login attempt for " + loginData.Username);
            var user = await DatabaseUserController.LogIn(loginData.Username, loginData.Password);

            if (user == null)
            {
                Console.WriteLine("Not Logged in");
                return Unauthorized(new { message = "Invalid username or password" });
            }

            Console.WriteLine("Logged in");
            return Ok(user); 
        }

        [HttpPost("register")]
        public async Task<ActionResult<DatabaseUser>> RegisterUser([FromForm] User user)
        {
            string? imagePath = null;

            if (user.ProfilePicture != null && user.ProfilePicture.Length > 0)
            {
                // Define where to save (ensure this folder exists in your project)
                var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads/profiles");
                if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);

                // Create a unique filename to prevent overwriting
                var fileName = $"{Guid.NewGuid()}_{user.ProfilePicture.FileName}";
                var fullPath = Path.Combine(uploadsFolder, fileName);

                // Save the file to the server disk
                using (var stream = new FileStream(fullPath, FileMode.Create))
                {
                    await user.ProfilePicture.CopyToAsync(stream);
                }

                // This is the path we save to the DB (relative URL)
                imagePath = $"/uploads/profiles/{fileName}";
            }

            DatabaseUser newUser = new DatabaseUser() { 
                Username = user.Username,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Password = user.Password,
                BirthDate = user.BirthDate,
                Age = user.CalculateAge(),
                Sex = user.Sex,
                HomeCityId = user.HomeCity?.Id,
                PhoneNumber = user.PhoneNumber,
                ProfilePicturePath = imagePath,
            };

            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();
            return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
        }

        [HttpPatch("{id}")]
        public async Task<IActionResult> PatchUser(int id, [FromBody] DatabaseUser updatedData)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            // Only update fields that are provided (not null)
            if (updatedData.Username != null) user.Username = updatedData.Username;
            if (updatedData.Email != null) user.Email = updatedData.Email;
            // ... apply other fields ...

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                return Conflict("The data was modified by another user. Please refresh.");
            }

            return NoContent(); // 204 Success
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "User deleted successfully" });
        }
    }
}

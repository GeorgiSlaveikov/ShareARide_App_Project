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
            Console.WriteLine("Login attempt");
            // Pass the context into your static helper
            var user = await DatabaseUserController.LogIn(loginData.Username, loginData.Password);

            if (user == null)
            {
                // 401 Unauthorized is better than 404 for failed logins
                Console.WriteLine("not Logged in");
                return Unauthorized(new { message = "Invalid username or password" });
            }

            Console.WriteLine("Logged in");
            return Ok(user); // Returns 200 OK with the User JSON
        }

        [HttpPost("register")]
        public async Task<ActionResult<DatabaseUser>> RegisterUser([FromBody] User user)
        {
            DatabaseUser newUser = new DatabaseUser() { 
                Username = user.Username,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Password = user.Password,
                BirthDate = user.BirthDate,
                Age = user.CalculateAge(),
                Sex = user.Sex,
                HomeCityId = user.HomeCity.Id
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

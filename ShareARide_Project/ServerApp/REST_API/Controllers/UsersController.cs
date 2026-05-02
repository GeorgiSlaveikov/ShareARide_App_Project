using Core.Model;
using DatabaseLayer.Database;
using DatabaseLayer.DatabaseControllers;
using DatabaseLayer.DatabaseModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using REST_API.Objects;
using REST_API.RequestObjects;
using REST_API.ResponseObjects;
using System;


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

        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserResponse>>> GetUsers()
        {
            return await _context.Users
                .AsNoTracking()
                .Select(user => new UserResponse()
                {
                    Id = user.Id,
                    UserName = user.Username,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    Email = user.Email,
                    Age = DatabaseUserController.CalculateAge(user.BirthDate),
                    PhoneNumber = user.PhoneNumber,
                    Sex = user.Sex,
                    Rating = user.Rating,
                    ProfilePicturePath = user.ProfilePicturePath
                }).ToListAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserResponse>> GetUser(int id)
        {
            var user = await DatabaseUserController.GetUser(id);
            if (user == null) return NotFound();
            return Ok(new UserResponse()
            {
                Id = user.Id,
                UserName = user.Username,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Age = DatabaseUserController.CalculateAge(user.BirthDate),
                PhoneNumber = user.PhoneNumber,
                Sex = user.Sex,
                Rating = user.Rating,
                ProfilePicturePath = user.ProfilePicturePath
            });
        }

        [HttpPost("login")]
        public async Task<ActionResult<DatabaseUser>> Login([FromBody] LoginRequest loginData)
        {
            Console.WriteLine("Login attempt for " + loginData.Username);
            var user = await DatabaseUserController.LogIn(loginData.Username, loginData.Password);

            if (user == null)
            {
                return Unauthorized(new { message = "Invalid username or password" });
            }

            return Ok(new UserResponse()
            {
                Id = user.Id,
                UserName = user.Username,
                FirstName = user.FirstName,
                LastName = user.LastName,
                Email = user.Email,
                Age = DatabaseUserController.CalculateAge(user.BirthDate),
                PhoneNumber = user.PhoneNumber,
                Sex = user.Sex,
                Rating = user.Rating,
                ProfilePicturePath = user.ProfilePicturePath
            });
        }

        [HttpPost("register")]
        public async Task<ActionResult<DatabaseUser>> RegisterUser([FromForm] UserCreateRequest request)
        {
            try
            {
                if (await DatabaseUserController.IsUsernameFree(request.Username) == false)
                    return BadRequest("Този прякор е вече зает! Опитайте с друг.");

                if (await DatabaseUserController.IsEmailValid(request.Email) == false)
                    return BadRequest("Имейл адресът не е в правилния форат [еmail@email.com]");

                if (await DatabaseUserController.IsPasswordValid(request.Password) == false)
                    return BadRequest("Паролата трябва да съдържа поне една главна буква и поне една малка буква, както и цифри!");

                if (await DatabaseUserController.IsPhoneNumberValid(request.PhoneNumber) == false)
                    return BadRequest("Въведеният телефонен номер не е валиден!");

                string? imagePath = null;

                if (request.ProfilePicture != null && request.ProfilePicture.Length > 0)
                {
                    var uploadsFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads/profiles");
                    if (!Directory.Exists(uploadsFolder)) Directory.CreateDirectory(uploadsFolder);
                   
                    var fileName = $"{Guid.NewGuid()}_{request.ProfilePicture.FileName}";
                    var fullPath = Path.Combine(uploadsFolder, fileName);
                    
                    using (var stream = new FileStream(fullPath, FileMode.Create))
                    {
                        await request.ProfilePicture.CopyToAsync(stream);
                    }
                    
                    imagePath = $"/uploads/profiles/{fileName}";
                }

                DatabaseUser newUser = new DatabaseUser()
                {
                    Username = request.Username,
                    FirstName = request.FirstName,
                    LastName = request.LastName,
                    Email = request.Email,
                    Password = DatabaseUserController.HashPassword(request.Password),
                    BirthDate = request.BirthDate,
                    Sex = request.Sex,
                    Age = DatabaseUserController.CalculateAge(request.BirthDate),
                    PhoneNumber = request.PhoneNumber,
                    ProfilePicturePath = imagePath,
                };

                _context.Users.Add(newUser);
                await _context.SaveChangesAsync();
                return Ok(new { message = "Registration successful" });
            }
            catch (Exception e)
            {
                return StatusCode(500, $"Error");
            }
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
